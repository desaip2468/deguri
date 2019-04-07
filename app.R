library(shiny)
library(shinydashboard)
library(DBI)
library(DT)

connection <- dbConnect(RMariaDB::MariaDB(), group = "desaip")
payment_approval_types <- as.vector(
  t(
    dbGetQuery(
      connection,
      "SELECT DISTINCT payment_approval_type FROM payments"
    )
  )
)
ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    tabItem(tabName = "Demo",
      fluidRow(
        box(
          selectInput(
            "payment_approval_type",
            "간편결제 승인 타입",
            choices = payment_approval_types,
            selected = 1
          )
        ),
        box(DT::dataTableOutput("dbOutput"))
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
}

shinyApp(ui = ui, server = server, options = list(port = 8300))
