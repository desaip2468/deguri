#간편 결제 여부를 타겟변수로 한 로지스틱 회귀분석

data<-read.csv("C:/Users/user/Desktop/2019-1/DATA/EMBRAIN/data_for_modeling5_utf8.csv", encoding="UTF-8")

colnames(data)[36:232]<-c("리모트 컨트롤러_usagetime",	"메신저_usagetime",
                          "N_usagetime",	"사진 편집_usagetime",	"돈버는 리워드_usagetime",
                          "모바일 뱅킹_usagetime",	"웹툰/웹소설_usagetime",	"간편결제_usagetime",	"검색포털_usagetime",
                          "멤버십/할인쿠폰_usagetime",	"벨소리/컬러링_usagetime",	"출결/학습관리_usagetime",	"동영상 스트리밍_usagetime",
                          "쇼핑_usagetime",	"고객센터_usagetime",	"게임_usagetime",	"커뮤니티_usagetime",	"음악 스트리밍_usagetime",
                          "지도/네비게이션_usagetime",	"필터 카메라_usagetime",	"항공/호텔/여행_usagetime",	"택시 호출_usagetime",
                          "스포츠_usagetime",	",도구_usagetime",	"계정관리_usagetime",	"보안/백신_usagetime",	"사진/동영상 갤러리_usagetime",
                          "신용카드_usagetime",	"브라우저_usagetime",	"건강/운동_usagetime",
                          "알림장_usagetime",	"뉴스/잡지_usagetime",	"계산기_usagetime",	"배달_usagetime",	"메모_usagetime",	"달력/일정관리_usagetime",
                          "개인 인증_usagetime",	"무음카메라_usagetime",	"부동산_usagetime",	"핸드폰꾸미기_usagetime",	"사전/번역_usagetime",	
                          "설문조사_usagetime",	"보험_usagetime",	"동영상 플레이어_usagetime",	"공인인증서_usagetime",	"상품권/기프티콘_usagetime",	
                          "택배_usagetime",	"콘텐츠_usagetime",	"문서_usagetime",	"비즈니스_usagetime",	"파일 다운로더_usagetime",	"메일_usagetime",
                          "소셜_usagetime",	"구인구직_usagetime",	"기타_usagetime",	"영화_usagetime",	"날씨_usagetime",	"홈원격관리_usagetime",	
                          "이벤트_usagetime",	"외국어학습_usagetime",	"기업/학회_usagetime",	"클라우드_usagetime",	"커피/디저트_usagetime",
                          "휴대폰 인증_usagetime",	"뱅킹 알림_usagetime",	"재태크/투자 정보_usagetime",	"의류 쇼핑몰_usagetime",	"중고거래_usagetime",
                          "대중교통정보_usagetime",	"퀴즈쇼_usagetime",	"스팸차단_usagetime",	"출산/육아 쇼핑몰_usagetime",	"녹음기_usagetime",	
                          "인터넷서점_usagetime",	"승차권 예매_usagetime",	"자녀 안심_usagetime",	"교육_usagetime",	"동영상 편집기_usagetime",	
                          "식음료 쇼핑_usagetime",	"카셰어링_usagetime",	"요금 조회/납부_usagetime",	"공동구매_usagetime",	"티켓 예매_usagetime",	
                          "가계부_usagetime",	"가격 비교_usagetime",	"게임 커뮤니티_usagetime",	"생리달력_usagetime",	"노래방_usagetime",	
                          "통신사 요금_usagetime",	"숙박_usagetime",	"출산/육아_usagetime",	"파일관리_usagetime",	"연락처관리_usagetime",	
                          "교통카드_usagetime",	"헌혈_usagetime",	"도서관_usagetime",	"대학교_usagetime",	"유아 음악/동영상_usagetime",	
                          "면세점_usagetime",	"클리너/배터리절약_usagetime",	"카풀_usagetime",	"화장품 쇼핑_usagetime",	
                          "전문지식_usagetime",	"게임 정보_usagetime",	"주식/증권/금융_usagetime",	"가구/인테리어 쇼핑몰_usagetime",	
                          "스마트폰 사용관리_usagetime",	"레시피_usagetime",	"전자책/독서_usagetime",	"자산통합관리_usagetime",	
                          "동호회/소모임_usagetime",	"렌즈_usagetime",	"연애 관련_usagetime",	"CCTV뷰어_usagetime",	"종교_usagetime",	
                          "기념일관리_usagetime",	"일기장_usagetime",	"IP우회_usagetime",	"패션/뷰티_usagetime",	"백화점 온라인몰_usagetime",	
                          "자녀 교육_usagetime",	"군대관련_usagetime",	"가상화폐_usagetime",	"교통 정보_usagetime",	"QR스캐너_usagetime",	
                          "성형정보_usagetime",	"손전등_usagetime",	"동영상 다운로더_usagetime",	"라디오/팟캐스트_usagetime",	
                          "차량 관리_usagetime",	"성인앱_usagetime",	"자전거/등산/캠핑_usagetime",	"알람시계_usagetime",	"급식정보_usagetime",	
                          "채팅/이성만남_usagetime",	"고용보험_usagetime",	"게임 거래_usagetime",	"복권_usagetime",	"공지_usagetime",	
                          "프린터/팩스_usagetime",	"수면_usagetime",	"아이돌_usagetime",	"운세/타로/사주_usagetime",	"여행 정보_usagetime",	
                          "음성/영상통화_usagetime",	"채널 관리자_usagetime",	"눈피로방지_usagetime",	"외국쇼핑몰_usagetime",	
                          "민원/정책정보_usagetime",	"주유소_usagetime","병원/약국_usagetime",	"반려동물_usagetime","근무일지_usagetime"	,
                          "백화점_usagetime",	"운전면허_usagetime",	"앱설치프로그램_usagetime",	"공연/전시회_usagetime", "맛집정보_usagetime",	
                          "자격증_usagetime",	"범죄/신고_usagetime",	"결혼준비_usagetime",	"놀이공원_usagetime",	"글쓰기_usagetime",	
                          "음악 다운로더_usagetime",	"음악 플레이어_usagetime",	"인공지능_usagetime",	"광고차단_usagetime",	"파일변환_usagetime",	
                          "카메라 컨트롤러_usagetime",	"그림그리기_usagetime",	"법원_usagetime",	"대출_usagetime",	"음악 (기타)_usagetime",	
                          "소셜연계_usagetime",	"공시정보_usagetime",	"재난안전_usagetime",	"환율/환전_usagetime",	"대리운전_usagetime",	
                          "공무원시험_usagetime",	"임상시험지원_usagetime",	"공매/입찰_usagetime",	"신용조회_usagetime",	"중고차_usagetime",	
                          "렌터카_usagetime",	"AR/VR_usagetime",	"마사지_usagetime",	"주차장 정보_usagetime",	"식품 정보_usagetime",	
                          "사진 인화_usagetime",	"만화책/애니메이션_usagetime",	"봉사_usagetime",	"P2P펀딩_usagetime",	"핸드폰 보험_usagetime",	
                          "렌탈서비스_usagetime",	"아이핀_usagetime",	"가구/인테리어_usagetime",	"AR/vR_usagetime.1")



data<-data[,-1] #필요없는 컬럼 삭제 

logity<-data$price_sum_by_by_approval_type_LT01
logity<-ifelse(logity > 0, 1, 0) #이용여부를 나타내는 변수로 만들기

logitdata<-data.frame(logity,data[,-1]) #기존 데이터와 합체 (without panel_id)

#stepwise logistic regression
#converge하지 않아서 warning만 뜸. 
#사용한 코드는 아래에

#fit.logit <- step(glm(logity ~ ., data = logitdata,family = binomial, control = list(maxit = 50)))



# 일반 로짓 분석
# 다 유의미하게 뜨네요..

table(logity) #check biasedness

summary(glm(logity~., data=logitdata, family="binomial"))


#간편 결제 이용액을 타겟 변수로 한 회귀 분석(user 대상)
library(tidyverse)
user<-data%>%filter(price_sum_by_by_approval_type_LT01>0) #user만 추출


#data transformation

category<-user%>%select(starts_with("category"))
category<-log(category+1)
company<-user%>%select(starts_with("company"))
company<-log(company+1)
usagetime<-user%>%select(ends_with("usagetime"))
usagetime<-log(usagetime+1)
price_sum<-user%>%select(starts_with("price_sum"))

transformed_data<-data.frame(user$age, category, company, usagetime,  price_sum)


#forward selection 방법으로 변수 선택

lm.null<-lm(price_sum_by_by_approval_type_LT01~1, data=transformed_data)
lm.full<-lm(price_sum_by_by_approval_type_LT01~., data=transformed_data)
forward.selection<- step(lm.null, direction = "forward", scope=list(lower=lm.null, upper=lm.full))

summary(forward.selection)

# 검정
plot(forward.selection)

library(Car)
car::vif(forward.selection)

#box-cox transformation

lm.forward<-lm(formula = price_sum_by_by_approval_type_LT01 ~ company_code_PA00004_count + 
                 company_code_PA00011_count + price_sum_by_by_approval_type_LA + 
                 price_sum_by_by_approval_type_FA + user.age + company_code_PA00010_count + 
                 X.U.C2E0..U.C6A9..U.CE74..U.B4DC._usagetime + X.U.B300..U.B9AC..U.C6B4..U.C804._usagetime + 
                 X.U.BC31..U.D654..U.C810._usagetime + company_code_PA00005_count + 
                 X.U.AE30..U.C5C5...U.D559..U.D68C._usagetime + X.U.C8FC..U.C720..U.C18C._usagetime + 
                 X.U.BCD1..U.C6D0...U.C57D..U.AD6D._usagetime + price_sum_by_by_approval_type_LT02 + 
                 category_code_7_count + price_sum_by_by_approval_type_LW + 
                 X.U.AC74..U.AC15...U.C6B4..U.B3D9._usagetime + X.U.C2A4..U.B9C8..U.D2B8..U.D3F0...U.C0AC..U.C6A9..U.AD00..U.B9AC._usagetime + 
                 category_code_14_count + category_code_6_count + X.U.AD6C..U.C778..U.AD6C..U.C9C1._usagetime + 
                 X.U.B274..U.C2A4...U.C7A1..U.C9C0._usagetime + X.U.BC45..U.D0B9...U.C54C..U.B9BC._usagetime + 
                 X.U.B300..U.D559..U.AD50._usagetime + X.U.C2DD..U.D488...U.C815..U.BCF4._usagetime + 
                 X.U.D328..U.C158...U.BDF0..U.D2F0._usagetime + X.U.AC00..U.ACC4..U.BD80._usagetime + 
                 X.U.C790..U.B140...U.C548..U.C2EC._usagetime + price_sum_by_by_approval_type_LC + 
                 X.U.CE74..U.C170..U.C5B4..U.B9C1._usagetime + X.U.C1FC..U.D551._usagetime + 
                 X.U.C8FC..U.C2DD...U.C99D..U.AD8C...U.AE08..U.C735._usagetime + 
                 X.U.B9AC..U.BAA8..U.D2B8...U.CEE8..U.D2B8..U.B864..U.B7EC._usagetime + 
                 X.U.BBFC..U.C6D0...U.C815..U.CC45..U.C815..U.BCF4._usagetime + 
                 X.U.C0C1..U.D488..U.AD8C...U.AE30..U.D504..U.D2F0..U.CF58._usagetime + 
                 X.U.AC04..U.D3B8..U.ACB0..U.C81C._usagetime + X.U.BAA8..U.BC14..U.C77C...U.BC45..U.D0B9._usagetime + 
                 X.U.ACF5..U.C778..U.C778..U.C99D..U.C11C._usagetime + X.U.C694..U.AE08...U.C870..U.D68C...U.B0A9..U.BD80._usagetime + 
                 X.U.D0DD..U.C2DC...U.D638..U.CD9C._usagetime + X.U.BA54..U.BAA8._usagetime + 
                 X.U.B3D9..U.C601..U.C0C1...U.C2A4..U.D2B8..U.B9AC..U.BC0D._usagetime + 
                 X.U.D30C..U.C77C..U.AD00..U.B9AC._usagetime + X.U.B3D9..U.D638..U.D68C...U.C18C..U.BAA8..U.C784._usagetime + 
                 X.U.ACF5..U.B9E4...U.C785..U.CC30._usagetime + X.U.C8FC..U.CC28..U.C7A5...U.C815..U.BCF4._usagetime + 
                 X.U.ACF5..U.B3D9..U.AD6C..U.B9E4._usagetime + X.U.D578..U.B4DC..U.D3F0...U.BCF4..U.D5D8._usagetime + 
                 X.U.BC30..U.B2EC._usagetime + X.U.C758..U.B958...U.C1FC..U.D551..U.BAB0._usagetime + 
                 X.U.BA54..U.C2E0..U.C800._usagetime + X.U.B808..U.C2DC..U.D53C._usagetime + 
                 category_code_3_count + X.U.C678..U.AD6D..U.C5B4..U.D559..U.C2B5._usagetime + 
                 X.U.CE74..U.D480._usagetime + P2P.U.D380..U.B529._usagetime + 
                 X.U.C74C..U.C545...U.D50C..U.B808..U.C774..U.C5B4._usagetime + 
                 X.U.C7AC..U.B09C..U.C548..U.C804._usagetime + X.U.ACE0..U.C6A9..U.BCF4..U.D5D8._usagetime + 
                 X.U.C74C..U.C545....U.AE30..U.D0C0.._usagetime + X.U.D504..U.B9B0..U.D130...U.D329..U.C2A4._usagetime + 
                 X.U.B3D9..U.C601..U.C0C1...U.D50C..U.B808..U.C774..U.C5B4._usagetime + 
                 X.U.C18C..U.C15C..U.C5F0..U.ACC4._usagetime + X.U.C678..U.AD6D..U.C1FC..U.D551..U.BAB0._usagetime + 
                 X.U.AC8C..U.C784...U.CEE4..U.BBA4..U.B2C8..U.D2F0._usagetime + 
                 X.U.BC94..U.C8C4...U.C2E0..U.ACE0._usagetime + X.U.C774..U.BCA4..U.D2B8._usagetime + 
                 category_code_9_count, data = transformed_data)


library(MASS)
bc_norm <- MASS::boxcox(lm.forward)
lambda <- bc_norm$x[which.max(bc_norm$y)]
summary(lm(formula = price_sum_by_by_approval_type_LT01^lambda ~ company_code_PA00004_count + 
             company_code_PA00011_count + price_sum_by_by_approval_type_LA + 
             price_sum_by_by_approval_type_FA + user.age + company_code_PA00010_count + 
             X.U.C2E0..U.C6A9..U.CE74..U.B4DC._usagetime + X.U.B300..U.B9AC..U.C6B4..U.C804._usagetime + 
             X.U.BC31..U.D654..U.C810._usagetime + company_code_PA00005_count + 
             X.U.AE30..U.C5C5...U.D559..U.D68C._usagetime + X.U.C8FC..U.C720..U.C18C._usagetime + 
             X.U.BCD1..U.C6D0...U.C57D..U.AD6D._usagetime + price_sum_by_by_approval_type_LT02 + 
             category_code_7_count + price_sum_by_by_approval_type_LW + 
             X.U.AC74..U.AC15...U.C6B4..U.B3D9._usagetime + X.U.C2A4..U.B9C8..U.D2B8..U.D3F0...U.C0AC..U.C6A9..U.AD00..U.B9AC._usagetime + 
             category_code_14_count + category_code_6_count + X.U.AD6C..U.C778..U.AD6C..U.C9C1._usagetime + 
             X.U.B274..U.C2A4...U.C7A1..U.C9C0._usagetime + X.U.BC45..U.D0B9...U.C54C..U.B9BC._usagetime + 
             X.U.B300..U.D559..U.AD50._usagetime + X.U.C2DD..U.D488...U.C815..U.BCF4._usagetime + 
             X.U.D328..U.C158...U.BDF0..U.D2F0._usagetime + X.U.AC00..U.ACC4..U.BD80._usagetime + 
             X.U.C790..U.B140...U.C548..U.C2EC._usagetime + price_sum_by_by_approval_type_LC + 
             X.U.CE74..U.C170..U.C5B4..U.B9C1._usagetime + X.U.C1FC..U.D551._usagetime + 
             X.U.C8FC..U.C2DD...U.C99D..U.AD8C...U.AE08..U.C735._usagetime + 
             X.U.B9AC..U.BAA8..U.D2B8...U.CEE8..U.D2B8..U.B864..U.B7EC._usagetime + 
             X.U.BBFC..U.C6D0...U.C815..U.CC45..U.C815..U.BCF4._usagetime + 
             X.U.C0C1..U.D488..U.AD8C...U.AE30..U.D504..U.D2F0..U.CF58._usagetime + 
             X.U.AC04..U.D3B8..U.ACB0..U.C81C._usagetime + X.U.BAA8..U.BC14..U.C77C...U.BC45..U.D0B9._usagetime + 
             X.U.ACF5..U.C778..U.C778..U.C99D..U.C11C._usagetime + X.U.C694..U.AE08...U.C870..U.D68C...U.B0A9..U.BD80._usagetime + 
             X.U.D0DD..U.C2DC...U.D638..U.CD9C._usagetime + X.U.BA54..U.BAA8._usagetime + 
             X.U.B3D9..U.C601..U.C0C1...U.C2A4..U.D2B8..U.B9AC..U.BC0D._usagetime + 
             X.U.D30C..U.C77C..U.AD00..U.B9AC._usagetime + X.U.B3D9..U.D638..U.D68C...U.C18C..U.BAA8..U.C784._usagetime + 
             X.U.ACF5..U.B9E4...U.C785..U.CC30._usagetime + X.U.C8FC..U.CC28..U.C7A5...U.C815..U.BCF4._usagetime + 
             X.U.ACF5..U.B3D9..U.AD6C..U.B9E4._usagetime + X.U.D578..U.B4DC..U.D3F0...U.BCF4..U.D5D8._usagetime + 
             X.U.BC30..U.B2EC._usagetime + X.U.C758..U.B958...U.C1FC..U.D551..U.BAB0._usagetime + 
             X.U.BA54..U.C2E0..U.C800._usagetime + X.U.B808..U.C2DC..U.D53C._usagetime + 
             category_code_3_count + X.U.C678..U.AD6D..U.C5B4..U.D559..U.C2B5._usagetime + 
             X.U.CE74..U.D480._usagetime + P2P.U.D380..U.B529._usagetime + 
             X.U.C74C..U.C545...U.D50C..U.B808..U.C774..U.C5B4._usagetime + 
             X.U.C7AC..U.B09C..U.C548..U.C804._usagetime + X.U.ACE0..U.C6A9..U.BCF4..U.D5D8._usagetime + 
             X.U.C74C..U.C545....U.AE30..U.D0C0.._usagetime + X.U.D504..U.B9B0..U.D130...U.D329..U.C2A4._usagetime + 
             X.U.B3D9..U.C601..U.C0C1...U.D50C..U.B808..U.C774..U.C5B4._usagetime + 
             X.U.C18C..U.C15C..U.C5F0..U.ACC4._usagetime + X.U.C678..U.AD6D..U.C1FC..U.D551..U.BAB0._usagetime + 
             X.U.AC8C..U.C784...U.CEE4..U.BBA4..U.B2C8..U.D2F0._usagetime + 
             X.U.BC94..U.C8C4...U.C2E0..U.ACE0._usagetime + X.U.C774..U.BCA4..U.D2B8._usagetime + 
             category_code_9_count, data = transformed_data))

lm.boxcox<-lm(formula = price_sum_by_by_approval_type_LT01^lambda ~ company_code_PA00004_count + 
                company_code_PA00011_count + price_sum_by_by_approval_type_LA + 
                price_sum_by_by_approval_type_FA + user.age + company_code_PA00010_count + 
                X.U.C2E0..U.C6A9..U.CE74..U.B4DC._usagetime + X.U.B300..U.B9AC..U.C6B4..U.C804._usagetime + 
                X.U.BC31..U.D654..U.C810._usagetime + company_code_PA00005_count + 
                X.U.AE30..U.C5C5...U.D559..U.D68C._usagetime + X.U.C8FC..U.C720..U.C18C._usagetime + 
                X.U.BCD1..U.C6D0...U.C57D..U.AD6D._usagetime + price_sum_by_by_approval_type_LT02 + 
                category_code_7_count + price_sum_by_by_approval_type_LW + 
                X.U.AC74..U.AC15...U.C6B4..U.B3D9._usagetime + X.U.C2A4..U.B9C8..U.D2B8..U.D3F0...U.C0AC..U.C6A9..U.AD00..U.B9AC._usagetime + 
                category_code_14_count + category_code_6_count + X.U.AD6C..U.C778..U.AD6C..U.C9C1._usagetime + 
                X.U.B274..U.C2A4...U.C7A1..U.C9C0._usagetime + X.U.BC45..U.D0B9...U.C54C..U.B9BC._usagetime + 
                X.U.B300..U.D559..U.AD50._usagetime + X.U.C2DD..U.D488...U.C815..U.BCF4._usagetime + 
                X.U.D328..U.C158...U.BDF0..U.D2F0._usagetime + X.U.AC00..U.ACC4..U.BD80._usagetime + 
                X.U.C790..U.B140...U.C548..U.C2EC._usagetime + price_sum_by_by_approval_type_LC + 
                X.U.CE74..U.C170..U.C5B4..U.B9C1._usagetime + X.U.C1FC..U.D551._usagetime + 
                X.U.C8FC..U.C2DD...U.C99D..U.AD8C...U.AE08..U.C735._usagetime + 
                X.U.B9AC..U.BAA8..U.D2B8...U.CEE8..U.D2B8..U.B864..U.B7EC._usagetime + 
                X.U.BBFC..U.C6D0...U.C815..U.CC45..U.C815..U.BCF4._usagetime + 
                X.U.C0C1..U.D488..U.AD8C...U.AE30..U.D504..U.D2F0..U.CF58._usagetime + 
                X.U.AC04..U.D3B8..U.ACB0..U.C81C._usagetime + X.U.BAA8..U.BC14..U.C77C...U.BC45..U.D0B9._usagetime + 
                X.U.ACF5..U.C778..U.C778..U.C99D..U.C11C._usagetime + X.U.C694..U.AE08...U.C870..U.D68C...U.B0A9..U.BD80._usagetime + 
                X.U.D0DD..U.C2DC...U.D638..U.CD9C._usagetime + X.U.BA54..U.BAA8._usagetime + 
                X.U.B3D9..U.C601..U.C0C1...U.C2A4..U.D2B8..U.B9AC..U.BC0D._usagetime + 
                X.U.D30C..U.C77C..U.AD00..U.B9AC._usagetime + X.U.B3D9..U.D638..U.D68C...U.C18C..U.BAA8..U.C784._usagetime + 
                X.U.ACF5..U.B9E4...U.C785..U.CC30._usagetime + X.U.C8FC..U.CC28..U.C7A5...U.C815..U.BCF4._usagetime + 
                X.U.ACF5..U.B3D9..U.AD6C..U.B9E4._usagetime + X.U.D578..U.B4DC..U.D3F0...U.BCF4..U.D5D8._usagetime + 
                X.U.BC30..U.B2EC._usagetime + X.U.C758..U.B958...U.C1FC..U.D551..U.BAB0._usagetime + 
                X.U.BA54..U.C2E0..U.C800._usagetime + X.U.B808..U.C2DC..U.D53C._usagetime + 
                category_code_3_count + X.U.C678..U.AD6D..U.C5B4..U.D559..U.C2B5._usagetime + 
                X.U.CE74..U.D480._usagetime + P2P.U.D380..U.B529._usagetime + 
                X.U.C74C..U.C545...U.D50C..U.B808..U.C774..U.C5B4._usagetime + 
                X.U.C7AC..U.B09C..U.C548..U.C804._usagetime + X.U.ACE0..U.C6A9..U.BCF4..U.D5D8._usagetime + 
                X.U.C74C..U.C545....U.AE30..U.D0C0.._usagetime + X.U.D504..U.B9B0..U.D130...U.D329..U.C2A4._usagetime + 
                X.U.B3D9..U.C601..U.C0C1...U.D50C..U.B808..U.C774..U.C5B4._usagetime + 
                X.U.C18C..U.C15C..U.C5F0..U.ACC4._usagetime + X.U.C678..U.AD6D..U.C1FC..U.D551..U.BAB0._usagetime + 
                X.U.AC8C..U.C784...U.CEE4..U.BBA4..U.B2C8..U.D2F0._usagetime + 
                X.U.BC94..U.C8C4...U.C2E0..U.ACE0._usagetime + X.U.C774..U.BCA4..U.D2B8._usagetime + 
                category_code_9_count, data = transformed_data)


plot(lm.boxcox)



#전체 결제액 중 간편결제 이용액 비율을 타겟 변수로 한 회귀 분석(user 대상)


