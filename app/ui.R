library(shiny)
library(shinydashboard)

simplePaymentsFieldDescription <- dbGetQuery(connection, 'DESCRIBE simple_payments')
integerFields <- simplePaymentsFieldDescription[grepl('int', simplePaymentsFieldDescription$Type),]$Field
allFieldsWithAgg <- c(
  paste(simplePaymentsFieldDescription$Field, '- count'),
  paste(simplePaymentsFieldDescription$Field, '- distinct_count'),
  paste(integerFields, '- sum')
)

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
