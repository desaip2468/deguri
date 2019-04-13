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
      "SELECT approval_store FROM simple_payments WHERE approval_store IS NOT NULL GROUP BY approval_store HAVING COUNT(panel_id) > 100"
    )
  )
)
simplePaymentsFieldDescription <- dbGetQuery(connection, 'DESCRIBE simple_payments')
integerFields <- simplePaymentsFieldDescription[grepl('int', simplePaymentsFieldDescription$Type),]$Field
allFieldsWithAgg <- c(paste(simplePaymentsFieldDescription$Field, '- count'), paste(integerFields, '- sum'))

ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(
    sidebarMenu(
      menuItem("가맹점별 간편결제 빈도", tabName = "freq_by_approval_store"),
      menuItem("Compare arbitrary X, Y", tabName = "plot_by_arbitrary_values")
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
      ),
      tabItem(
        tabName = "plot_by_arbitrary_values",
        box(
          selectInput(
            "approval_store2",
            "가맹점 선택 (100개 이상의 결제건)",
            choices = c('전체', approval_stores)
          ),
          selectInput("field_x", "X축 컬럼 (그룹화 기준)", choices = simplePaymentsFieldDescription$Field),
          selectInput("field_y", "Y축 컬럼 (그룹화 대상 + 그룹화 함수)", choices = allFieldsWithAgg)
        ),
        plotOutput(outputId = "xVersusYPlot")
      )
    )
  )
)

server <- function(input, output) {
  output$approvalStorePlot <- renderPlot({
    if (input$approval_store == '전체') {
      if (input$gender == 0) {
        query <- paste(
          "SELECT panel_id, COUNT(panel_id) AS panel_id_count FROM simple_payments WHERE approval_store IN (\"",
          paste(approval_stores, collapse = '", "'),
          "\") GROUP BY panel_id HAVING COUNT(panel_id) > 50 AND COUNT(panel_id) < 350"
        )
        bindParameters <- list()
      }
      else {
        query <- paste(
          "SELECT panel_id, COUNT(panel_id) AS panel_id_count FROM simple_payments WHERE gender = ? AND approval_store IN (\"",
          paste(approval_stores, collapse = '", "'),
          "\") GROUP BY panel_id HAVING COUNT(panel_id) > 50 AND COUNT(panel_id) < 350"
        )
        bindParameters <- list(input$gender)
      }
    }
    else {
      if (input$gender == 0) {
        query <- "SELECT panel_id, COUNT(panel_id) AS panel_id_count FROM simple_payments WHERE approval_store = ? GROUP BY panel_id"
        bindParameters <- list(input$approval_store)
      }
      else {
        query <- "SELECT panel_id, COUNT(panel_id) AS panel_id_count FROM simple_payments WHERE gender = ? AND approval_store = ? GROUP BY panel_id"
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

  output$xVersusYPlot <- renderPlot({
    fieldYWithAggF <- strsplit(input$field_y, " - ")[[1]]
    fieldY <- fieldYWithAggF[1]
    aggF <- fieldYWithAggF[2]

    if (input$approval_store2 == '전체') {
      if (aggF == 'count') {
        query <- paste(
          "SELECT ",
          input$field_x,
          ", COUNT(DISTINCT ",
          fieldY,
          ") AS count FROM simple_payments WHERE approval_store IN (\"",
          paste(approval_stores, collapse = '", "'),
          "\") GROUP BY ",
          input$field_x,
          " ORDER BY count DESC LIMIT 50"
        )
        bindParameters <- list()
      }
      else if (aggF == 'sum') {
        query <- paste(
          "SELECT ",
          input$field_x,
          ", SUM(",
          fieldY,
          ") AS sum FROM simple_payments WHERE approval_store IN (\"",
          paste(approval_stores, collapse = '", "'),
          "\") GROUP BY ",
          input$field_x,
          " ORDER BY sum DESC LIMIT 50"
        )
        bindParameters <- list()
      }
    }
    else {
      if (aggF == 'count') {
        query <- paste(
          "SELECT ",
          input$field_x,
          ", COUNT(DISTINCT ",
          fieldY,
          ") AS count FROM simple_payments WHERE approval_store = ? GROUP BY ",
          input$field_x,
          " ORDER BY count DESC LIMIT 50"
        )
        bindParameters <- list(input$approval_store2)
      }
      else if (aggF == 'sum') {
        query <- paste(
          "SELECT ",
          input$field_x,
          ", SUM(",
          fieldY,
          ") AS sum FROM simple_payments WHERE approval_store = ? GROUP BY ",
          input$field_x,
          " ORDER BY sum DESC LIMIT 50"
        )
        bindParameters <- list(input$approval_store2)
      }
    }
    prepare <- dbSendQuery(connection, query)
    if (length(bindParameters) != 0) dbBind(prepare, bindParameters)
    result <- dbFetch(prepare)
    dbClearResult(prepare)

    # Integer conversion, sorting
    if (aggF == 'count') {
      result$count <- as.integer(result$count)
    }
    else if (aggF == 'sum') {
      result$sum <- as.integer(result$sum)
    }

    ggplot(result, aes_string(input$field_x, aggF)) +
      geom_bar(stat = "identity") +
      labs(title = paste(input$approval_store2, input$field_x, " vs ", input$field_y), x = input$field_x, y = input$field_y) +
      theme(axis.text.x = element_text(angle = 90, hjust = 1), text=element_text(size = 14, family = "NanumGothic"))
  })
}

shinyApp(ui = ui, server = server, options = list(port = 8300))
