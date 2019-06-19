library(shiny)
library(shinydashboard)

options(shiny.launch.browser = F, shiny.minified = F, shiny.port = 8300)

# data <- read.csv('../analysis/data/payments_ppdb_app_g2_category_code_aggregated.csv')

ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(
    sidebarMenu(
      menuItem("FrontPage", tabName = "presentation_tab_0"),
      menuItem("1. 문제점 도출",
        menuSubItem("5060 세대의 낮은 간편결제 이용률", "presentation_tab_1_1")
      ),
      menuItem("2. 데이터 탐색/전처리",
        menuSubItem("다루기 쉬운 데이터로 만들기", "presentation_tab_2_1"),
        menuSubItem("타겟 변수와 설명 변수 선택", "presentation_tab_2_2")
      ),
      menuItem("3. 분석 방법 선택",
        menuSubItem("조사 방법 선택", "presentation_tab_3_1"),
        menuSubItem("타겟 변수와 설명 변수 선택", "presentation_tab_2_2")
      )
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "presentation_tab_0",
        h3("FrontPage")
      ),
      tabItem(
        tabName = "presentation_tab_1_1",
        h2("1. 문제점 도출"),
        h3("5060 세대의 낮은 간편결제 이용률"),
        plotOutput("presentation_tab_1_1_plot"),
        br(), # Line break
        h4("✓ 네이버페이, 카카오페이등의뚜렷한강자가있는2030 세대와는달리, 5060 세대에서는뚜렷한강세를보이는간편결제
회사가없음"),
        h4("✓ 따라서5060 세대를공략할경우, 이시장에서상당한선점효과를누릴수있을것이라고기대됨")
      ),
      tabItem(
        tabName = "presentation_tab_2_1",
        h2("2. 데이터 탐색/전처리"),
        h3("다루기 쉬운 데이터로 만들기"),
        plotOutput("presentation_tab_2_1_plot"),
        br(), # Line break
        h4("✓ 정보가각결제건마다나열되어있어패널들의 소비행태를한눈에보기가어려웠음"),
        h4("✓ 따라서 ‘panel_id’를 기준으로 데이터를 aggregate 시킴"),
        h4("✓ 그결과행의수가약3만3천여개로줄어들었고, 각패널들의 소비행태를분석하기 좋은형태로변하였음")
      ),
      tabItem(
        tabName = "presentation_tab_2_2",
        h3("2_2")
      ),
      tabItem(
        tabName = "presentation_tab_3_1",
        h2("3. 분석 방법 선택"),
        h3("조사 방법 선택"),
        # plotOutput("presentation_tab_2_1_plot"),
        br(), # Line break
        h4("✓ 2018년 11월부터 2019년 2월까지의 간편결제이용승인금액합을기준으로 5060 세대패널을분류하고자 함"),
        h4("✓ 간편결제이용승인금액분포를보았을때이상치가 다수존재했기 때문에, 중앙값을 대표값으로 하고절대오차를기준으로
분석하는 K-medoids clustering 기법을이용함")
      )
      # tabItem(
      #   tabName = "presentation_tab_2_2",
      #   h3("2_2")
      # ),
      # tabItem(
      #   tabName = "plot_by_arbitrary_values",
      #   box(
      #     selectInput(
      #       "approval_store2",
      #       "가맹점 선택 (100개 이상의 결제건)",
      #       choices = c('전체', approval_stores)
      #     ),
      #     selectInput("field_x", "X축 컬럼 (그룹화 기준)", choices = simplePaymentsFieldDescription$Field),
      #     selectInput("field_y", "Y축 컬럼 (그룹화 대상 + 그룹화 함수)", choices = allFieldsWithAgg)
      #   ),
      #   plotOutput(outputId = "xVersusYPlot")
      # )
    )
  )
)

server <- function(input, output) {
  output$presentation_tab_1_1_plot <- renderPlot({
    plot('mpg ~ cyl' %>% as.formula, data = mtcars)
  })

  output$presentation_tab_1_1_table <- renderTable({
    mtcars
  })
}

shinyApp(ui, server)
