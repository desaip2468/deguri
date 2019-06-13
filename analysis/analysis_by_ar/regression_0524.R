library(tidyverse)


#간편 결제 이용액을 타겟 변수로 한 회귀 분석(user 대상)

data<-read.csv("C:/Users/user/Desktop/2019-1/DATA/EMBRAIN/data_for_modeling5_utf8.csv", encoding="UTF-8")
user<-data%>%filter(price_sum_by_by_approval_type_LT01>0) #user만 추출

#outlier 제거 (간편결제 이용액 기준 상위 3개 행 제거)

sorted <- user[c(order(user$price_sum_by_by_approval_type_LT01, decreasing = TRUE)),] 

user<- sorted[-c(1,2,3), ] #상위 3개 아웃라이어 제거 

#x 변수에 0이 많으므로 log(x+1)을 취해줌. 

category<-user%>%dplyr::select(starts_with("category"))
category<-log(category+1)
company<-user%>%dplyr::select(starts_with("company"))
company<-log(company+1)
usagetime<-user%>%dplyr::select(ends_with("usagetime"))
usagetime<-log(usagetime+1)
price_sum<-user%>%dplyr::select(starts_with("price_sum"))

transformed_data<-data.frame(user$age, category, company, usagetime,  price_sum)


#forward selection 방법으로 변수 선택

lm.null<-lm(price_sum_by_by_approval_type_LT01~1, data=transformed_data)
lm.full<-lm(price_sum_by_by_approval_type_LT01~., data=transformed_data)
#로딩속도를 위해 코드만 적어놓겠습니다
#forward.selection<- step(lm.null, direction = "forward", scope=list(lower=lm.null, upper=lm.full))

#최종모델 한번더 입력해주겠습니다 (로딩속도를 위해....)

lm.forward<-lm(formula = price_sum_by_by_approval_type_LT01 ~ company_code_PA00004_count + 
                 company_code_PA00011_count + price_sum_by_by_approval_type_LA + 
                 X.U.C2E0..U.C6A9..U.CE74..U.B4DC._usagetime + company_code_PA00010_count + 
                 user.age + price_sum_by_by_approval_type_FA + price_sum_by_by_approval_type_LT02 + 
                 X.U.CE74..U.D480._usagetime + X.U.AE30..U.C5C5...U.D559..U.D68C._usagetime + 
                 X.U.B300..U.B9AC..U.C6B4..U.C804._usagetime + price_sum_by_by_approval_type_LW + 
                 price_sum_by_by_approval_type_LC + X.U.ACF5..U.C778..U.C778..U.C99D..U.C11C._usagetime + 
                 category_code_6_count + X.U.C2DD..U.D488...U.C815..U.BCF4._usagetime + 
                 X.U.B300..U.D559..U.AD50._usagetime + X.U.AC74..U.AC15...U.C6B4..U.B3D9._usagetime + 
                 category_code_14_count + X.U.BC45..U.D0B9...U.C54C..U.B9BC._usagetime + 
                 X.U.AD6C..U.C778..U.AD6C..U.C9C1._usagetime + X.U.C2A4..U.B9C8..U.D2B8..U.D3F0...U.C0AC..U.C6A9..U.AD00..U.B9AC._usagetime + 
                 X.U.C8FC..U.CC28..U.C7A5...U.C815..U.BCF4._usagetime + company_code_PA00005_count + 
                 X.U.D328..U.C158...U.BDF0..U.D2F0._usagetime + X.U.BC31..U.D654..U.C810._usagetime + 
                 X.U.BA74..U.C138..U.C810._usagetime + X.U.ACF5..U.B9E4...U.C785..U.CC30._usagetime + 
                 X.U.B2EC..U.B825...U.C77C..U.C815..U.AD00..U.B9AC._usagetime + 
                 X.U.C8FC..U.C2DD...U.C99D..U.AD8C...U.AE08..U.C735._usagetime + 
                 X.U.B3D9..U.C601..U.C0C1...U.C2A4..U.D2B8..U.B9AC..U.BC0D._usagetime + 
                 X.U.BC30..U.B2EC._usagetime + X.U.C678..U.AD6D..U.C5B4..U.D559..U.C2B5._usagetime + 
                 X.U.D034..U.C988..U.C1FC._usagetime + X.U.AC04..U.D3B8..U.ACB0..U.C81C._usagetime + 
                 X.U.C0C1..U.D488..U.AD8C...U.AE30..U.D504..U.D2F0..U.CF58._usagetime + 
                 price_sum_by_by_approval_type_FC + X.U.BC94..U.C8C4...U.C2E0..U.ACE0._usagetime + 
                 X.U.B3D9..U.D638..U.D68C...U.C18C..U.BAA8..U.C784._usagetime + 
                 X.U.C8FC..U.C720..U.C18C._usagetime + CCTV.U.BDF0..U.C5B4._usagetime + 
                 X.U.C7AC..U.B09C..U.C548..U.C804._usagetime + X.U.C1FC..U.D551._usagetime + 
                 X.U.C54C..U.B9BC..U.C7A5._usagetime + X.U.D0DD..U.C2DC...U.D638..U.CD9C._usagetime + 
                 category_code_3_count + X.U.C911..U.ACE0..U.CC28._usagetime + 
                 company_code_PA00012_count + X.U.AC00..U.C0C1..U.D654..U.D3D0._usagetime + 
                 P2P.U.D380..U.B529._usagetime + X.U.C74C..U.C131...U.C601..U.C0C1..U.D1B5..U.D654._usagetime + 
                 X.U.BCF4..U.D5D8._usagetime + X.U.C790..U.C0B0..U.D1B5..U.D569..U.AD00..U.B9AC._usagetime + 
                 X.U.C911..U.ACE0..U.AC70..U.B798._usagetime + X.U.CE74..U.C170..U.C5B4..U.B9C1._usagetime + 
                 X.U.C2E0..U.C6A9..U.C870..U.D68C._usagetime + QR.U.C2A4..U.CE90..U.B108._usagetime + 
                 X.U.ADFC..U.BB34..U.C77C..U.C9C0._usagetime + X.U.BA54..U.BAA8._usagetime + 
                 X.U.B179..U.C74C..U.AE30._usagetime + X.U.BCD1..U.C6D0...U.C57D..U.AD6D._usagetime + 
                 X.U.D0DD..U.BC30._usagetime + X.U.D648..U.C6D0..U.ACA9..U.AD00..U.B9AC._usagetime + 
                 X.U.B808..U.C2DC..U.D53C._usagetime + X.U.AD50..U.D1B5...U.C815..U.BCF4._usagetime + 
                 X.U.C694..U.AE08...U.C870..U.D68C...U.B0A9..U.BD80._usagetime + 
                 X.U.BAA8..U.BC14..U.C77C...U.BC45..U.D0B9._usagetime + X.U.ACE0..U.C6A9..U.BCF4..U.D5D8._usagetime + 
                 category_code_9_count + X.U.D5CC..U.D608._usagetime + X.U.B3D9..U.C601..U.C0C1...U.B2E4..U.C6B4..U.B85C..U.B354._usagetime + 
                 X.U.D56D..U.ACF5...U.D638..U.D154...U.C5EC..U.D589._usagetime + 
                 X.U.C804..U.C790..U.CC45...U.B3C5..U.C11C._usagetime + X.U.C18C..U.C15C...U.C5F0..U.ACC4._usagetime + 
                 category_code_10_count + X.U.C2A4..U.D338..U.CC28..U.B2E8._usagetime, 
               data = transformed_data)



#r-squred 값이 0.3으로 낮음.

summary(lm.forward)

# 검정 결과 변환이 필요해보입니다 

plot(lm.forward)




#forward 방법을 써서 채택된 모델에 대해 boxcox transformation

library(MASS)
bc_norm <- MASS::boxcox(lm.forward)
lambda <- bc_norm$x[which.max(bc_norm$y)]
lm.boxcox<-lm(formula = price_sum_by_by_approval_type_LT01^lambda ~ company_code_PA00004_count + 
             company_code_PA00011_count + price_sum_by_by_approval_type_LA + 
             X.U.C2E0..U.C6A9..U.CE74..U.B4DC._usagetime + company_code_PA00010_count + 
             user.age + price_sum_by_by_approval_type_FA + price_sum_by_by_approval_type_LT02 + 
             X.U.CE74..U.D480._usagetime + X.U.AE30..U.C5C5...U.D559..U.D68C._usagetime + 
             X.U.B300..U.B9AC..U.C6B4..U.C804._usagetime + price_sum_by_by_approval_type_LW + 
             price_sum_by_by_approval_type_LC + X.U.ACF5..U.C778..U.C778..U.C99D..U.C11C._usagetime + 
             category_code_6_count + X.U.C2DD..U.D488...U.C815..U.BCF4._usagetime + 
             X.U.B300..U.D559..U.AD50._usagetime + X.U.AC74..U.AC15...U.C6B4..U.B3D9._usagetime + 
             category_code_14_count + X.U.BC45..U.D0B9...U.C54C..U.B9BC._usagetime + 
             X.U.AD6C..U.C778..U.AD6C..U.C9C1._usagetime + X.U.C2A4..U.B9C8..U.D2B8..U.D3F0...U.C0AC..U.C6A9..U.AD00..U.B9AC._usagetime + 
             X.U.C8FC..U.CC28..U.C7A5...U.C815..U.BCF4._usagetime + company_code_PA00005_count + 
             X.U.D328..U.C158...U.BDF0..U.D2F0._usagetime + X.U.BC31..U.D654..U.C810._usagetime + 
             X.U.BA74..U.C138..U.C810._usagetime + X.U.ACF5..U.B9E4...U.C785..U.CC30._usagetime + 
             X.U.B2EC..U.B825...U.C77C..U.C815..U.AD00..U.B9AC._usagetime + 
             X.U.C8FC..U.C2DD...U.C99D..U.AD8C...U.AE08..U.C735._usagetime + 
             X.U.B3D9..U.C601..U.C0C1...U.C2A4..U.D2B8..U.B9AC..U.BC0D._usagetime + 
             X.U.BC30..U.B2EC._usagetime + X.U.C678..U.AD6D..U.C5B4..U.D559..U.C2B5._usagetime + 
             X.U.D034..U.C988..U.C1FC._usagetime + X.U.AC04..U.D3B8..U.ACB0..U.C81C._usagetime + 
             X.U.C0C1..U.D488..U.AD8C...U.AE30..U.D504..U.D2F0..U.CF58._usagetime + 
             price_sum_by_by_approval_type_FC + X.U.BC94..U.C8C4...U.C2E0..U.ACE0._usagetime + 
             X.U.B3D9..U.D638..U.D68C...U.C18C..U.BAA8..U.C784._usagetime + 
             X.U.C8FC..U.C720..U.C18C._usagetime + CCTV.U.BDF0..U.C5B4._usagetime + 
             X.U.C7AC..U.B09C..U.C548..U.C804._usagetime + X.U.C1FC..U.D551._usagetime + 
             X.U.C54C..U.B9BC..U.C7A5._usagetime + X.U.D0DD..U.C2DC...U.D638..U.CD9C._usagetime + 
             category_code_3_count + X.U.C911..U.ACE0..U.CC28._usagetime + 
             company_code_PA00012_count + X.U.AC00..U.C0C1..U.D654..U.D3D0._usagetime + 
             P2P.U.D380..U.B529._usagetime + X.U.C74C..U.C131...U.C601..U.C0C1..U.D1B5..U.D654._usagetime + 
             X.U.BCF4..U.D5D8._usagetime + X.U.C790..U.C0B0..U.D1B5..U.D569..U.AD00..U.B9AC._usagetime + 
             X.U.C911..U.ACE0..U.AC70..U.B798._usagetime + X.U.CE74..U.C170..U.C5B4..U.B9C1._usagetime + 
             X.U.C2E0..U.C6A9..U.C870..U.D68C._usagetime + QR.U.C2A4..U.CE90..U.B108._usagetime + 
             X.U.ADFC..U.BB34..U.C77C..U.C9C0._usagetime + X.U.BA54..U.BAA8._usagetime + 
             X.U.B179..U.C74C..U.AE30._usagetime + X.U.BCD1..U.C6D0...U.C57D..U.AD6D._usagetime + 
             X.U.D0DD..U.BC30._usagetime + X.U.D648..U.C6D0..U.ACA9..U.AD00..U.B9AC._usagetime + 
             X.U.B808..U.C2DC..U.D53C._usagetime + X.U.AD50..U.D1B5...U.C815..U.BCF4._usagetime + 
             X.U.C694..U.AE08...U.C870..U.D68C...U.B0A9..U.BD80._usagetime + 
             X.U.BAA8..U.BC14..U.C77C...U.BC45..U.D0B9._usagetime + X.U.ACE0..U.C6A9..U.BCF4..U.D5D8._usagetime + 
             category_code_9_count + X.U.D5CC..U.D608._usagetime + X.U.B3D9..U.C601..U.C0C1...U.B2E4..U.C6B4..U.B85C..U.B354._usagetime + 
             X.U.D56D..U.ACF5...U.D638..U.D154...U.C5EC..U.D589._usagetime + 
             X.U.C804..U.C790..U.CC45...U.B3C5..U.C11C._usagetime + X.U.C18C..U.C15C...U.C5F0..U.ACC4._usagetime + 
             category_code_10_count + X.U.C2A4..U.D338..U.CC28..U.B2E8._usagetime, 
           data = transformed_data)


# r스퀘어값과 가정 적합 여부가 많이 개선됨 

summary(lm.boxcox)
plot(lm.boxcox)


#lm.boxcox 모델에서 p값이 0.05 이하인 변수만 추려보자

attach(transformed_data)

user_sig<-data.frame(price_sum_by_by_approval_type_LT01, company_code_PA00004_count,                                  
                     company_code_PA00011_count, price_sum_by_by_approval_type_LA, price_sum_by_by_approval_type_FA, user$age ,
                     company_code_PA00010_count,   X.U.C2E0..U.C6A9..U.CE74..U.B4DC._usagetime,  X.U.B300..U.B9AC..U.C6B4..U.C804._usagetime,
                     X.U.BC31..U.D654..U.C810._usagetime, company_code_PA00005_count, X.U.AE30..U.C5C5...U.D559..U.D68C._usagetime, 
                     price_sum_by_by_approval_type_LT02,  X.U.AC74..U.AC15...U.C6B4..U.B3D9._usagetime,
                     category_code_6_count,   X.U.AD6C..U.C778..U.AD6C..U.C9C1._usagetime, 
                     X.U.BC45..U.D0B9...U.C54C..U.B9BC._usagetime, X.U.B300..U.D559..U.AD50._usagetime, 
                     X.U.D328..U.C158...U.BDF0..U.D2F0._usagetime, price_sum_by_by_approval_type_LC,
                     X.U.CE74..U.C170..U.C5B4..U.B9C1._usagetime, X.U.C0C1..U.D488..U.AD8C...U.AE30..U.D504..U.D2F0..U.CF58._usagetime, 
                     X.U.AC04..U.D3B8..U.ACB0..U.C81C._usagetime, X.U.ACF5..U.C778..U.C778..U.C99D..U.C11C._usagetime,
                     X.U.D0DD..U.C2DC...U.D638..U.CD9C._usagetime,  X.U.BA54..U.BAA8._usagetime,
                     X.U.B3D9..U.C601..U.C0C1...U.C2A4..U.D2B8..U.B9AC..U.BC0D._usagetime,  X.U.D578..U.B4DC..U.D3F0...U.BCF4..U.D5D8._usagetime,
                     X.U.BC30..U.B2EC._usagetime ,  category_code_3_count ,
                     P2P.U.D380..U.B529._usagetime ,  X.U.D504..U.B9B0..U.D130...U.D329..U.C2A4._usagetime,
                     X.U.AC8C..U.C784...U.CEE4..U.BBA4..U.B2C8..U.D2F0._usagetime,  X.U.BC94..U.C8C4...U.C2E0..U.ACE0._usagetime )


#다시 피팅

lm_again<-lm(price_sum_by_by_approval_type_LT01~., data=user_sig)
summary(lm_again)

#boxcox
bc_norm <- MASS::boxcox(lm_again)
lambda <- bc_norm$x[which.max(bc_norm$y)]
summary(lm(price_sum_by_by_approval_type_LT01^lambda~., data=user_sig))

# 잔차 그림 그렸을 때 이전 모형이 더 적합한 것으로 나타남 
plot(lm_again)


par(mfrow=c(2,2))

plot(lm.boxcox)
plot(lm_again)

