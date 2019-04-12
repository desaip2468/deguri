library(shiny)
library(shinydashboard)
library(DBI)
library(DT)
library(ggplot2)

source('multiplot.R')

connection <- dbConnect(RMariaDB::MariaDB(), group = "desaip")
approval_stores <- as.vector(
  t(
    dbGetQuery(
      connection,
      "SELECT approval_store FROM payments WHERE approval_store IS NOT NULL GROUP BY approval_store HAVING COUNT(panel_id) > 100"
    )
  )
)

ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(
    sidebarMenu(
      menuItem("가맹점별 간편결제 빈도", tabName = "freq_by_approval_store")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "freq_by_approval_store",
        box(
          selectInput(
            "approval_store",
            "가맹점 선택 (100개 이상의 결제건)",
            choices = c('전체', approval_stores)
          ),
          radioButtons(
            "gender",
            "성별을 선택하세요",
            choiceNames = c("전체", "남성", "여성"),
            choiceValues = c(0, 1, 2)
          )
        ),
        plotOutput(outputId = "approvalStorePlot")
      )
    )
  )
)

server <- function(input, output) {
  output$approvalStorePlot <- renderPlot({
    if (input$approval_store == '전체') {
      if (input$gender == 0) {
        query <- paste(
          "SELECT panel_id, COUNT(panel_id) AS panel_id_count FROM payments WHERE approval_store IN (\"",
          paste(approval_stores, collapse = '", "'),
          "\") GROUP BY panel_id HAVING COUNT(panel_id) > 50 AND COUNT(panel_id) < 350"
        )
        bindParameters <- list()
      }
      else {
        query <- paste(
          "SELECT panel_id, COUNT(panel_id) AS panel_id_count FROM payments WHERE gender = ? AND approval_store IN (\"",
          paste(approval_stores, collapse = '", "'),
          "\") GROUP BY panel_id HAVING COUNT(panel_id) > 50 AND COUNT(panel_id) < 350"
        )
        bindParameters <- list(input$gender)
      }
    }
    else {
      if (input$gender == 0) {
        query <- "SELECT panel_id, COUNT(panel_id) AS panel_id_count FROM payments WHERE approval_store = ? GROUP BY panel_id"
        bindParameters <- list(input$approval_store)
      }
      else {
        query <- "SELECT panel_id, COUNT(panel_id) AS panel_id_count FROM payments WHERE gender = ? AND approval_store = ? GROUP BY panel_id"
        bindParameters <- list(input$gender, input$approval_store)
      }
    }
    prepare <- dbSendQuery(connection, query)
    if (length(bindParameters) != 0) dbBind(prepare, bindParameters)
    result <- dbFetch(prepare)
    dbClearResult(prepare)

    # Sort by count
    result$panel_id <- factor(result$panel_id, levels = result$panel_id[order(as.integer(-result$panel_id_count))])
    multiplot(
      ggplot(result, aes(panel_id, as.integer(panel_id_count))) +
        geom_bar(stat = "identity") +
        labs(title = "", x = "panel_id", y = "빈도"),
      ggplot(result, aes(as.integer(panel_id_count))) +
        geom_bar(stat = "count") +
        labs(title = "", x = "freq", y = "count")
    )
  })
}

shinyApp(ui = ui, server = server, options = list(port = 8300))
