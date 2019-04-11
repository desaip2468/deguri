library(shiny)
library(shinydashboard)
library(DBI)
library(DT)
library(ggplot2)

connection <- dbConnect(RMariaDB::MariaDB(), group = "desaip")
payment_approval_types <- as.vector(
  t(
    dbGetQuery(
      connection,
      "SELECT DISTINCT payment_approval_type FROM payments"
    )
  )
)
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
      menuItem("Demo", tabName = "Demo"),
      menuItem("가맹점별 간편결제 빈도", tabName = "freq_by_approval_store"),
      menuItem("성별별 간편결제 빈도", tabName = "freq_by_gender")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "Demo",
        fluidRow(
          box(
            selectInput(
              "payment_approval_type",
              "간편결제 승인 타입",
              choices = payment_approval_types
            )
          ),
          box(DT::dataTableOutput("dbOutput"))
        )
      ),
      tabItem(
        tabName = "freq_by_approval_store",
        box(
          selectInput(
            "approval_store",
            "가맹점 선택 (100개 이상의 결제건)",
            choices = c('전체', approval_stores)
          )
        ),
        plotOutput(outputId = "approvalStorePlot")
      ),
      tabItem(
        tabName = "freq_by_gender",
        box(
          radioButtons(
            "gender",
            "성별을 선택하셔용",
            choiceNames = c("남성", "여성"),
            choiceValues = c(1, 2)
          )
        ),
        plotOutput(outputId = "genderPlot")
      )
    )
  )
)

server <- function(input, output) {
  output$dbOutput <- renderDataTable({
    prepare <- dbSendQuery(
      connection,
      "SELECT panel_id, gender, age FROM payments WHERE payment_approval_type = ? LIMIT 100"
    )
    dbBind(prepare, input$payment_approval_type)
    result <- dbFetch(prepare)
    dbClearResult(prepare)
    datatable(result, options = list(orderClasses = TRUE, lengthMenu = c(5, 10, 30), pageLength = 5))
  })

  output$approvalStorePlot <- renderPlot({
    if (input$approval_store == '전체') {
      result <- dbGetQuery(
        connection,
        paste(
          "SELECT panel_id, COUNT(panel_id) AS panel_id_count FROM payments WHERE approval_store IN (\"",
          paste(approval_stores, collapse = '", "'),
          "\") GROUP BY panel_id HAVING COUNT(panel_id) > 50 AND COUNT(panel_id) < 350"
        )
      )

      # Sort by count
      result$panel_id <- factor(result$panel_id, levels = result$panel_id[order(as.integer(-result$panel_id_count))])
      ggplot(result, aes(panel_id, as.integer(panel_id_count))) +
        geom_bar(stat = "identity") +
        labs(title = "결제건수 100개 이상 가맹점의 패널 분포", x = "panel_id", y = "빈도")
    }
    else {
      prepare <- dbSendQuery(
        connection,
        "SELECT panel_id, COUNT(panel_id) AS panel_id_count FROM payments WHERE approval_store = ? GROUP BY panel_id"
      )
      dbBind(prepare, input$approval_store)
      result <- dbFetch(prepare)
      dbClearResult(prepare)

      result$panel_id <- factor(result$panel_id, levels = result$panel_id[order(as.integer(-result$panel_id_count))])
      ggplot(result, aes(panel_id, as.integer(panel_id_count))) +
        geom_bar(stat = "identity") +
        labs(title = paste("가맹점 ", input$approval_store, "의 패널 분포"), x = "panel_id", y = "빈도")
    }
  })

  output$genderPlot <- renderPlot({
    prepare <- dbSendQuery(
      connection,
      paste(
        "SELECT panel_id, COUNT(panel_id) AS panel_id_count FROM payments WHERE gender = ? AND approval_store IN (\"",
        paste(approval_stores, collapse = '", "'),
        "\") GROUP BY panel_id HAVING COUNT(panel_id) > 50 AND COUNT(panel_id) < 350"
      )
    )
    dbBind(prepare, input$gender)
    result <- dbFetch(prepare)
    dbClearResult(prepare)

    genderName <- if (input$gender == '1') "남성" else "여성"

    # Sort by count
    result$panel_id <- factor(result$panel_id, levels = result$panel_id[order(as.integer(-result$panel_id_count))])
    ggplot(result, aes(panel_id, as.integer(panel_id_count))) +
      geom_bar(stat = "identity") +
      labs(title = paste(genderName, "의 패널 분포"), x = "panel_id", y = "빈도")
  })
}

shinyApp(ui = ui, server = server, options = list(port = 8300))
