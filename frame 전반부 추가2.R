#Sys.setlocale("LC_CTYPE","ko_KR.UTF-8")

#install.packages("shinydashboard")

library(shiny)
library(shinydashboard)
library(tidyverse)

options(shiny.launch.browser = F, shiny.minified = F, shiny.port = 8300)
data<-read.csv('C:/Users/user/Desktop/2019-1/DATA/EMBRAIN/payments_ppdb_app_category_code_aggregated_x_cp949.csv')








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
               menuSubItem("타겟 변수와 설명 변수 선택", "presentation_tab_2_2"),
               menuSubItem("대략적인 소비패턴 파악", "presentation_tab_2_3"),
               menuSubItem("설명변수 전처리", "presentation_tab_2_4")
      ),
      menuItem("3. 분석 방법 선택",
               menuSubItem("K-medoids Clustering", "presentation_tab_3_1"),
               menuSubItem("Logistic Regression", "presentation_tab_3_2")
      ),
      menuItem("4. 분석 결과 및 전략",
               menuSubItem("1. Closed Sweepstakes Strategy", "presentation_tab_4_1"),
               menuSubItem("2. Experience Marketing", "presentation_tab_4_2"),
               menuSubItem("3. Buyer & User Strategy", "presentation_tab_4_3")
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
        #imageOutput("image_1", width = "100%", height = "400px", inline = FALSE),
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
        h2("2. 데이터 탐색/전처리"),
        h3("다루기 쉬운 데이터로 만들기"),
        plotOutput("presentation_tab_2_2_plot"),
        br(), # Line break
        h4("✓ 우리의 목적은 5060 세대의 간편결제 이용을 촉진하는 것이므로, 간편결제 이용액을 타겟변수로 설정함"),
        h4("✓ 패널 별 간편결제 이용 승인 금액을 나타내는 컬럼을 만들어 타겟변수로 사용함"),
        h4("✓ 그 결과, 행의 수가 약 3만3천여 개로 줄어들었고, 각 패널들의 소비 행태를 분석하기 좋은 형태로 변하였음")
      ),
      tabItem(
        tabName = "presentation_tab_2_3",
        h2("2. 데이터 탐색/전처리"),
        h3("대략적인 소비패턴 파악"),
        plotOutput("presentation_tab_2_3_plot"),
        br(), # Line break
        h4("✓ 5060 세대의 간편 결제 이용률이 낮고 , 현금이나 신용카드 이용률이 압도적으로 높음"),
        h4("✓ 간편 결제 이용자의 경우 일부의 Heavy User 와 다수의 Light User 로 구성되어 있는 것으로 보임"),
        br(),
        tableOutput("presentation_tab_2_3_table"),
        br(), # Line break
        h4("✓ 5060 세대의 간편 결제 이용자가 절반에도 미치지 못하였기 때문에 , 간편 결제 이용액이라는 타겟 변수는
간편결제 이용자보다 미이용자가 훨씬 더 많은 비대칭 분포를 이루고 있었음"),
        h4("✓ 간편 결제 이용자의 비율이 적으므로 해당 Class 의 민감도가 급격히 낮아지는 문제가 발생할 수 있음"),
        h4("✓ 따라서 SMOTE 방법을 이용해 간편 결제 이용자의 비율을 미이용자와 비슷하게 만듦")
              ),
      tabItem(
        tabName = "presentation_tab_2_4",
        h2("2. 데이터 탐색/전처리"),
        h3("설명변수 전처리"),
        #plotOutput("presentation_tab_2_4_plot"),
        br(), # Line break
        h4("✓ 설정한 설명변수 컬럼에 0이 매우 많았고, 비슷한 의미를 가지는 컬럼들이 다수 존재하였음"),
        h4("✓ 따라서 비슷한 의미를 지니는 컬럼들을 하나의 컬럼으로 합쳐서 0의 개수를 줄이고 다중공선성 문제를 해결함")
      ),
      tabItem(
        tabName = "presentation_tab_3_1",
        h2("3. 분석 방법 선택"),
        h3("K-medoids clustering"),
        plotOutput("presentation_tab_3_1_plot"),
        br(), # Line break
        h4("✓ 2018년 11월부터 2019년 2월까지의 간편결제이용승인금액합을기준으로 5060 세대패널을분류하고자 함"),
        h4("✓ 간편결제이용승인금액분포를보았을때이상치가 다수존재했기 때문에, 중앙값을 대표값으로 하고절대오차를기준으로
분석하는 K-medoids clustering 기법을이용함"),
        
        br(),
        # tableOutput("presentation_tab_3_1_table"),
        # tableOutput("presentation_tab_3_1_table_2"),
        #plotOutput("presentation_tab_3_1_plot_2")
        br(), # Line break
        h4("✓ 2먼저 간편 결제 이용 승인 금액이 0 인 패널을 미이용자 로 분류하고 , 이용자들을 대상으로 군집 분석을 실시한 결과 2 개의 군집
(Light User / Heavy 으로 분류됨"),
        h4("✓ 이는 앞선 EDA 결과와도 일치함"),
        h4("✓ 이렇게 분류된 군집을 바탕으로 각 군집별 특성을 파악하고 , 그 차이가 유의한지 다양한 방법을 이용하여 검정함")
            ),
      tabItem(
        tabName = "presentation_tab_3_2",
        h2("3. 분석 방법 선택"),
        h3("Logistic Regression"),
        # plotOutput("presentation_tab_2_1_plot"),
        br(), # Line break
        h4("✓ 가맹점 카테고리 코드를 백의 자리 기준으로 합친 새로운 컬럼들을 설명 변수로 놓고 , 간편 결제 이용 여부를 타겟 변수로 하는 로
지스틱 회귀 분석을 수행함"),
        h4("✓ 전체 가맹점 카테고리 중 일부가 간편 결제 사용 금액에 유의미한 영향을 미쳤으며 , Accuracy 가 0.72, 민감도가 0.94, 특이도가
0.75 로 준수한 수준이었음"),
        
        br(), # Line break
        # plotOutput("presentation_tab_2_1_plot"),
        br(), # Line break
        h4("✓ 구글 카테고리를 기준으로 하여 각 카테고리 별로 앱 사용 시간을 설명 변수로 하고 간편 결제 이용 여부를 타겟 변수로 하는
로지스틱 회귀 분석을 수행함"),
        h4("✓ 전체 가맹점 카테고리 중 일부가 간편 결제 사용 금액에 유의미한 영향을 미쳤으며 , Accuracy 가 0.72, 민감도가 0.80, 특이도가
0.43 으로 특이도를 제외한 결과 값은 준수한 수준이었음")
      ),
      tabItem(
        tabName = "presentation_tab_4_1",
        h2("4. 분석 결과 및 전략"),
        h3("1. Closed Sweepstakes Strategy"),
        plotOutput("presentation_tab_4_1_plot"),
        br(),
        h4("✓ 스마트폰을 많이 이용할수록 간편 결제를 많이 이용하는 경향을 보임(주말 기준도 동일한 결과)"),
        h4("활용전략: 5060 간편결제 미이용자들을 스마트폰 중독자로 making하여 모바일 및 디지털 학습능력을 증가시키고 미이용자들의 간편결제 구매 채널을 확보하자!"),       
        br(),
        h3("HOW?"),
        h3("Closed Sweepstakes Strategy(소비자현상)"),
        h4("일명 '스마트폰 5060' 마케팅 : 통신사와 제휴를 맺은 후, 열흘 동안 스마트폰을 50시간 이상 이용한 고객들을 대상으로 random 추첨을 통해 1등 고객에 당첨되면 간편결제시 경품을 받는 프로모션 실시")
      ),
      
      tabItem(
        tabName = "presentation_tab_4_2",
        h2("4. 분석 결과 및 전략"),
        h3("2. Experience Marketing"),
        plotOutput("presentation_tab_4_2_plot"), #2개
        br(),
        h4("✓ [온라인 쇼핑몰, 식비/외식, 대형마트, 편의점]은 간편결제금액 상위 가맹점 카테고리에 해당" ),
        h4("✓ 군집분석 결과, 간편결제 이용률이 증가할수록 위 가맹점들의 평균 결제 빈도가 증가한다."),
        h4("✓ 로지스틱분석 결과, [온라인 쇼핑몰, 편의점, 문화] 가맹점 카테고리가 간편결제 이용여부에 유의한 영향을 미침"), 
        br(),
        #plotOutput("presentation_tab_4_2_plot"),
        br(),
        h4("✓ [쇼핑, 음악/오디오, 만화, 스포츠, 캐주얼게임, 롤플레잉] 앱을 더 많이 이용할수록, 즉 레저활동에 관심이 많을수록 간편결제를 더 많이 이용한다."),
        br(),
        #plotOutput("presentation_tab_4_2_plot"),
        br(),
        h4("✓ Heavy User의 경우 , Light User 나 미이용자에 비해 해외 여행을 자주 다니며 해외 직구를 많이 이용하는 모습을 보임"),
        br(),
        #plotOutput("presentation_tab_4_2_plot"),
        br(),
        h4("✓ 또한 Heavy User 는 미이용자나 Light User 에 비해 여행,스포츠,문화/취미 등의 여가 생활에 많은 투자를 하고 있음"),
        #이 부분 순서 수정 필요해 보임
        br(),
        h3("결론"),
        h3("Heavy User는 'Active Senior'이다."),
        h4("-> 시간과 경제적 여유를 바탕으로 적극적이고 능동적으로 사회활동을 즐기는 5060 세대를 일컫는 말. 
           이들은 젊은 생활 방식을 추구하며, 문화와 여가 생활에 아낌 없는 투자를 함"),
        br(),
        h3("활용전략"), 
        h3("5060소비자의 기억 속에 레저 전문 간편결제사 이미지를 선점하자!"),
        h4("(즉, '편리함'이 아니라 '즐거움'을 파는 간편결제 회사 이미지로 Positioning)"),
        h3("How?"), 
        h4("✓ 현 액티브 시니어대상 결제시장 선점"),
        h4(": 실버전용결제 Subbrand Create 'Active Pay'출시 및 Activity Score에 따른 실버 등급제 실시"),
        h4("-> 쇼핑, 음악, 만화, 스포츠, 게임에 대한 포인트 및 마일리지 보상과 같은 ‘시니어 요금제’를 차등하여 제공"),
        h4("✓ Experience marketing을 통한 Nonuser 포섭"),
        h4(": 레저활동을 하지 않는 5060이 “Active Pay”를 처음 이용하여 레저를 즐길 경우, 1일 무료 체험마케팅 실시"),  
        h4("-> 간편결제 미이용자는 한번 사용하면 계속 사용할 확률↑ (체험 마케팅은 해당 레저 시장을 확장해주는 효과가 있기 때문에 가맹점을 쉽게 설득하여 제휴 가능할 것으로 보임)"),
        h4("✓ 이밖에도 액티브 시니어들이 즐기는 ‘종합편성채널’ 또는 신문 광고를 통한 프로모션 진행, UI디자인 개편, 시니어 모델 기용, 시니어들이 자주 이용하는 5060 맞춤형 상품 제공 -> '카톡주문'등의 방
  법)") 
        
      ),
      
      tabItem(
        tabName = "presentation_tab_4_3",
        h2("4. 분석 결과 및 전략"),
        h3("3. Buyer & User Strategy"),
        plotOutput("presentation_tab_4_3_plot"),
        br(),
        h4("✓ 2 군집의 경우 1 군집에 비해 평균 가족 구성원 수가 많고 자녀와 함께 거주하는 비율이 높음"),
        h4("✓ 이를 바탕으로 5060 세대가 간편 결제를 지속적으로 이용하는 데 있어서 상대적으로 간편 결제에 익숙한 자녀들의 역할이
           중요함을 알 수 있음"),
        h4("활용전략: 간편결제 이용 장벽 해소"),       
        br(),
        h3(HTML("HOW? <br/> 
                Buyer와 User를 나누어서 마케팅 진행 (User: 자녀, Buyer: 시니어)")),
        h4("-> 자녀의 결혼 선물을 5060 부모들이 간편결제로 결제하면, 포인트 10배로 적립"),
        h4("-> 자연스럽게 가족 간 간편결제를 주제로 한 대화 분위기 조성"), 
        h4("-> 간편결제가 있는지도 몰랐던 5060의 간편결제 인지, 학습, 이용 증대")
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
  output$presentation_tab_2_3_plot <- renderPlot({
    old<-data%>%filter(data$age>=50)
    old.order<-data.frame(old$panel_id, old$approval_real_price_sum_by_by_approval_type_LT01)
    old.order<-old.order[c(order(old.order$old.approval_real_price_sum_by_by_approval_type_LT01, decreasing=TRUE)),] 
    colnames(old.order)<-c("panel_id", "price")
    ggplot(data=old.order) +
      geom_bar(mapping=aes(x=reorder(panel_id, -price), y=price), stat='identity')
  })
  output$presentation_tab_2_3_table <-renderTable({
    usagefactor<- ifelse(old$approval_real_price_sum_by_by_approval_type_LT01>0, 1, 0)
    usagefactor<-as.factor(usagefactor)
    agefactor <- ifelse(old$age>=50 & old$age<60, 0, 1)
    agefactor<-as.factor(agefactor)
    
    usagetable<-table(usagefactor, agefactor)
    usagetable <- round(prop.table(table(usagefactor,agefactor),2)*100)
    colnames(usagetable)<-cbind("Fifty", "Over Sixty")
    rownames(usagetable)<-rbind("USER", "NON-USER")
    
    usagetable
  })
  
  output$presentation_tab_3_1_plot <- renderPlot({
    old<-data%>%filter(data$age>=50)
    old.order<-data.frame(old$panel_id, old$approval_real_price_sum_by_by_approval_type_LT01)
    old.order<-old.order[c(order(old.order$old.approval_real_price_sum_by_by_approval_type_LT01, decreasing=TRUE)),] 
    colnames(old.order)<-c("panel_id", "price")
    ggplot ( old, aes(x=1, y=old$approval_real_price_sum_by_by_approval_type_LT01 )) +
      geom_boxplot ( )+coord_flip()
  })
  
 
  
}

shinyApp(ui, server)