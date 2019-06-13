library(tidyverse)


#간편 결제 이용액을 타겟 변수로 한 회귀 분석(user 대상)

data<-read.csv("C:/Users/user/Desktop/2019-1/DATA/EMBRAIN/payments_ppdb_app_g_cp949.csv", encoding="CP949")
colnames(data)[1222]

old<-data%>%filter(data$age>=50) #50대 이상만 추출
user<-old%>%filter(price_sum_by_by_approval_type_LT01>0) #user만 추출

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
                 X.U.C0AC..U.C9C4...U.C778..U.D654._usagetime + category_code_6_count + 
                 X.U.D544..U.D130...U.CE74..U.BA54..U.B77C._usagetime + X.U.B0A0..U.C528._usagetime + 
                 X.U.AE30..U.C5C5...U.D559..U.D68C._usagetime + X.U.CE74..U.BA54..U.B77C...U.CEE8..U.D2B8..U.B864..U.B7EC._usagetime + 
                 X.U.AC8C..U.C784...U.CEE4..U.BBA4..U.B2C8..U.D2F0._usagetime + 
                 company_code_PA00010_count + X.U.C911..U.ACE0..U.AC70..U.B798._usagetime + 
                 X.U.C790..U.C0B0..U.D1B5..U.D569..U.AD00..U.B9AC._usagetime + 
                 price_sum_by_by_approval_type_LW + CCTV.U.BDF0..U.C5B4._usagetime + 
                 X.U.D504..U.B9B0..U.D130...U.D329..U.C2A4._usagetime + X.U.B3C8..U.BC84..U.B294...U.B9AC..U.C6CC..U.B4DC._usagetime + 
                 AR.VR_usagetime + X.U.BC31..U.D654..U.C810...U.C628..U.B77C..U.C778..U.BAB0._usagetime + 
                 price_sum_by_by_approval_type_FC + X.U.C131..U.D615..U.C815..U.BCF4._usagetime + 
                 X.U.C219..U.BC15._usagetime + X.U.C74C..U.C131...U.C601..U.C0C1..U.D1B5..U.D654._usagetime + 
                 price_sum_by_by_approval_type_LD + X.U.D2F0..U.CF13...U.C608..U.B9E4._usagetime + 
                 X.U.BB38..U.C11C._usagetime + X.U.C571..U.C124..U.CE58..U.D504..U.B85C..U.ADF8..U.B7A8._usagetime + 
                 X.U.B300..U.D559..U.AD50._usagetime + X.U.D30C..U.C77C...U.B2E4..U.C6B4..U.B85C..U.B354._usagetime + 
                 X.U.D30C..U.C77C..U.AD00..U.B9AC._usagetime + price_sum_by_by_approval_type_FA + 
                 price_sum_by_by_approval_type_LC + QR.U.C2A4..U.CE90..U.B108._usagetime + 
                 X.U.AC80..U.C0C9..U.D3EC..U.D138._usagetime + X.U.C601..U.D654._usagetime + 
                 X.U.B3C4..U.C11C..U.AD00._usagetime + category_code_12_count + 
                 X.U.B300..U.CD9C._usagetime + X.U.AD50..U.D1B5..U.CE74..U.B4DC._usagetime + 
                 X.U.C74C..U.C545...U.C2A4..U.D2B8..U.B9AC..U.BC0D._usagetime + 
                 X.U.B179..U.C74C..U.AE30._usagetime + X.U.BB34..U.C74C..U.CE74..U.BA54..U.B77C._usagetime + 
                 company_code_PA00012_count + X.U.C5EC..U.D589...U.C815..U.BCF4._usagetime + 
                 X.U.C190..U.C804..U.B4F1._usagetime + X.U.C2E0..U.C6A9..U.C870..U.D68C._usagetime + 
                 X.U.C1FC..U.D551._usagetime + X.U.D648..U.C6D0..U.ACA9..U.AD00..U.B9AC._usagetime + 
                 X.U.B2EC..U.B825...U.C77C..U.C815..U.AD00..U.B9AC._usagetime + 
                 X.U.C8FC..U.C720..U.C18C._usagetime + X.U.B3D9..U.D638..U.D68C...U.C18C..U.BAA8..U.C784._usagetime + 
                 X.U.BC18..U.B824..U.B3D9..U.BB3C._usagetime + X.U.C18C..U.C15C...U.C5F0..U.ACC4._usagetime + 
                 X.U.CF58..U.D150..U.CE20._usagetime + X.U.B80C..U.D130..U.CE74._usagetime, 
               data = transformed_data)

#lm.forwad 모델에 대해 다중공선성 체크를 해보겠습니다 

library(car)
which(car::vif(lm.forward)>4) #국내 입금과 출금이 다중 공선성이 있다고 나오네염. 우리는 '소비'에 초점을 맞추었으므로 출금내역만 선택하겠습니다

lm.after.vif<-lm(formula = price_sum_by_by_approval_type_LT01 ~ company_code_PA00004_count + 
                               company_code_PA00011_count + price_sum_by_by_approval_type_LA + 
                               X.U.C0AC..U.C9C4...U.C778..U.D654._usagetime + category_code_6_count + 
                               X.U.D544..U.D130...U.CE74..U.BA54..U.B77C._usagetime + X.U.B0A0..U.C528._usagetime + 
                               X.U.AE30..U.C5C5...U.D559..U.D68C._usagetime + X.U.CE74..U.BA54..U.B77C...U.CEE8..U.D2B8..U.B864..U.B7EC._usagetime + 
                               X.U.AC8C..U.C784...U.CEE4..U.BBA4..U.B2C8..U.D2F0._usagetime + 
                               company_code_PA00010_count + X.U.C911..U.ACE0..U.AC70..U.B798._usagetime + 
                               X.U.C790..U.C0B0..U.D1B5..U.D569..U.AD00..U.B9AC._usagetime + 
                               price_sum_by_by_approval_type_LW + CCTV.U.BDF0..U.C5B4._usagetime + 
                               X.U.D504..U.B9B0..U.D130...U.D329..U.C2A4._usagetime + X.U.B3C8..U.BC84..U.B294...U.B9AC..U.C6CC..U.B4DC._usagetime + 
                               AR.VR_usagetime + X.U.BC31..U.D654..U.C810...U.C628..U.B77C..U.C778..U.BAB0._usagetime + 
                               price_sum_by_by_approval_type_FC + X.U.C131..U.D615..U.C815..U.BCF4._usagetime + 
                               X.U.C219..U.BC15._usagetime + X.U.C74C..U.C131...U.C601..U.C0C1..U.D1B5..U.D654._usagetime + 
                               X.U.D2F0..U.CF13...U.C608..U.B9E4._usagetime + 
                               X.U.BB38..U.C11C._usagetime + X.U.C571..U.C124..U.CE58..U.D504..U.B85C..U.ADF8..U.B7A8._usagetime + 
                               X.U.B300..U.D559..U.AD50._usagetime + X.U.D30C..U.C77C...U.B2E4..U.C6B4..U.B85C..U.B354._usagetime + 
                               X.U.D30C..U.C77C..U.AD00..U.B9AC._usagetime + price_sum_by_by_approval_type_FA + 
                               price_sum_by_by_approval_type_LC + QR.U.C2A4..U.CE90..U.B108._usagetime + 
                               X.U.AC80..U.C0C9..U.D3EC..U.D138._usagetime + X.U.C601..U.D654._usagetime + 
                               X.U.B3C4..U.C11C..U.AD00._usagetime + category_code_12_count + 
                               X.U.B300..U.CD9C._usagetime + X.U.AD50..U.D1B5..U.CE74..U.B4DC._usagetime + 
                               X.U.C74C..U.C545...U.C2A4..U.D2B8..U.B9AC..U.BC0D._usagetime + 
                               X.U.B179..U.C74C..U.AE30._usagetime + X.U.BB34..U.C74C..U.CE74..U.BA54..U.B77C._usagetime + 
                               company_code_PA00012_count + X.U.C5EC..U.D589...U.C815..U.BCF4._usagetime + 
                               X.U.C190..U.C804..U.B4F1._usagetime + X.U.C2E0..U.C6A9..U.C870..U.D68C._usagetime + 
                               X.U.C1FC..U.D551._usagetime + X.U.D648..U.C6D0..U.ACA9..U.AD00..U.B9AC._usagetime + 
                               X.U.B2EC..U.B825...U.C77C..U.C815..U.AD00..U.B9AC._usagetime + 
                               X.U.C8FC..U.C720..U.C18C._usagetime + X.U.B3D9..U.D638..U.D68C...U.C18C..U.BAA8..U.C784._usagetime + 
                               X.U.BC18..U.B824..U.B3D9..U.BB3C._usagetime + X.U.C18C..U.C15C...U.C5F0..U.ACC4._usagetime + 
                               X.U.CF58..U.D150..U.CE20._usagetime + X.U.B80C..U.D130..U.CE74._usagetime, 
                             data = transformed_data)


#r-squred 값이 꽤 높네요 (0.6)

summary(lm.after.vif)

# 검정 결과 변환이 필요해보입니다 

plot(lm.after.vif)


#boxcox transformation

library(MASS)
bc_norm <- MASS::boxcox(lm.after.vif)
lambda <- bc_norm$x[which.max(bc_norm$y)]
lm.boxcox<-lm(formula = price_sum_by_by_approval_type_LT01^lambda ~ company_code_PA00004_count + 
                company_code_PA00011_count + price_sum_by_by_approval_type_LA + 
                X.U.C0AC..U.C9C4...U.C778..U.D654._usagetime + category_code_6_count + 
                X.U.D544..U.D130...U.CE74..U.BA54..U.B77C._usagetime + X.U.B0A0..U.C528._usagetime + 
                X.U.AE30..U.C5C5...U.D559..U.D68C._usagetime + X.U.CE74..U.BA54..U.B77C...U.CEE8..U.D2B8..U.B864..U.B7EC._usagetime + 
                X.U.AC8C..U.C784...U.CEE4..U.BBA4..U.B2C8..U.D2F0._usagetime + 
                company_code_PA00010_count + X.U.C911..U.ACE0..U.AC70..U.B798._usagetime + 
                X.U.C790..U.C0B0..U.D1B5..U.D569..U.AD00..U.B9AC._usagetime + 
                price_sum_by_by_approval_type_LW + CCTV.U.BDF0..U.C5B4._usagetime + 
                X.U.D504..U.B9B0..U.D130...U.D329..U.C2A4._usagetime + X.U.B3C8..U.BC84..U.B294...U.B9AC..U.C6CC..U.B4DC._usagetime + 
                AR.VR_usagetime + X.U.BC31..U.D654..U.C810...U.C628..U.B77C..U.C778..U.BAB0._usagetime + 
                price_sum_by_by_approval_type_FC + X.U.C131..U.D615..U.C815..U.BCF4._usagetime + 
                X.U.C219..U.BC15._usagetime + X.U.C74C..U.C131...U.C601..U.C0C1..U.D1B5..U.D654._usagetime + 
                X.U.D2F0..U.CF13...U.C608..U.B9E4._usagetime + 
                X.U.BB38..U.C11C._usagetime + X.U.C571..U.C124..U.CE58..U.D504..U.B85C..U.ADF8..U.B7A8._usagetime + 
                X.U.B300..U.D559..U.AD50._usagetime + X.U.D30C..U.C77C...U.B2E4..U.C6B4..U.B85C..U.B354._usagetime + 
                X.U.D30C..U.C77C..U.AD00..U.B9AC._usagetime + price_sum_by_by_approval_type_FA + 
                price_sum_by_by_approval_type_LC + QR.U.C2A4..U.CE90..U.B108._usagetime + 
                X.U.AC80..U.C0C9..U.D3EC..U.D138._usagetime + X.U.C601..U.D654._usagetime + 
                X.U.B3C4..U.C11C..U.AD00._usagetime + category_code_12_count + 
                X.U.B300..U.CD9C._usagetime + X.U.AD50..U.D1B5..U.CE74..U.B4DC._usagetime + 
                X.U.C74C..U.C545...U.C2A4..U.D2B8..U.B9AC..U.BC0D._usagetime + 
                X.U.B179..U.C74C..U.AE30._usagetime + X.U.BB34..U.C74C..U.CE74..U.BA54..U.B77C._usagetime + 
                company_code_PA00012_count + X.U.C5EC..U.D589...U.C815..U.BCF4._usagetime + 
                X.U.C190..U.C804..U.B4F1._usagetime + X.U.C2E0..U.C6A9..U.C870..U.D68C._usagetime + 
                X.U.C1FC..U.D551._usagetime + X.U.D648..U.C6D0..U.ACA9..U.AD00..U.B9AC._usagetime + 
                X.U.B2EC..U.B825...U.C77C..U.C815..U.AD00..U.B9AC._usagetime + 
                X.U.C8FC..U.C720..U.C18C._usagetime + X.U.B3D9..U.D638..U.D68C...U.C18C..U.BAA8..U.C784._usagetime + 
                X.U.BC18..U.B824..U.B3D9..U.BB3C._usagetime + X.U.C18C..U.C15C...U.C5F0..U.ACC4._usagetime + 
                X.U.CF58..U.D150..U.CE20._usagetime + X.U.B80C..U.D130..U.CE74._usagetime, 
              data = transformed_data)


# 잔차그림은 많이 좋아졌으나 결정계수가 왜 뚝 떨어졌을까여.. 흑흑

summary(lm.boxcox)
plot(lm.boxcox)


#입금 내역을 다시 넣고 boxcox 해볼게여.. 


bc_norm <- MASS::boxcox(lm.after.vif)
lambda <- bc_norm$x[which.max(bc_norm$y)]
lm.boxcox_1<-lm(formula = price_sum_by_by_approval_type_LT01^lambda ~ company_code_PA00004_count + 
                  company_code_PA00011_count + price_sum_by_by_approval_type_LA + 
                  X.U.C0AC..U.C9C4...U.C778..U.D654._usagetime + category_code_6_count + 
                  X.U.D544..U.D130...U.CE74..U.BA54..U.B77C._usagetime + X.U.B0A0..U.C528._usagetime + 
                  X.U.AE30..U.C5C5...U.D559..U.D68C._usagetime + X.U.CE74..U.BA54..U.B77C...U.CEE8..U.D2B8..U.B864..U.B7EC._usagetime + 
                  X.U.AC8C..U.C784...U.CEE4..U.BBA4..U.B2C8..U.D2F0._usagetime + 
                  company_code_PA00010_count + X.U.C911..U.ACE0..U.AC70..U.B798._usagetime + 
                  X.U.C790..U.C0B0..U.D1B5..U.D569..U.AD00..U.B9AC._usagetime + 
                  price_sum_by_by_approval_type_LW + CCTV.U.BDF0..U.C5B4._usagetime + 
                  X.U.D504..U.B9B0..U.D130...U.D329..U.C2A4._usagetime + X.U.B3C8..U.BC84..U.B294...U.B9AC..U.C6CC..U.B4DC._usagetime + 
                  AR.VR_usagetime + X.U.BC31..U.D654..U.C810...U.C628..U.B77C..U.C778..U.BAB0._usagetime + 
                  price_sum_by_by_approval_type_FC + X.U.C131..U.D615..U.C815..U.BCF4._usagetime + 
                  X.U.C219..U.BC15._usagetime + X.U.C74C..U.C131...U.C601..U.C0C1..U.D1B5..U.D654._usagetime + 
                  price_sum_by_by_approval_type_LD + X.U.D2F0..U.CF13...U.C608..U.B9E4._usagetime + 
                  X.U.BB38..U.C11C._usagetime + X.U.C571..U.C124..U.CE58..U.D504..U.B85C..U.ADF8..U.B7A8._usagetime + 
                  X.U.B300..U.D559..U.AD50._usagetime + X.U.D30C..U.C77C...U.B2E4..U.C6B4..U.B85C..U.B354._usagetime + 
                  X.U.D30C..U.C77C..U.AD00..U.B9AC._usagetime + price_sum_by_by_approval_type_FA + 
                  price_sum_by_by_approval_type_LC + QR.U.C2A4..U.CE90..U.B108._usagetime + 
                  X.U.AC80..U.C0C9..U.D3EC..U.D138._usagetime + X.U.C601..U.D654._usagetime + 
                  X.U.B3C4..U.C11C..U.AD00._usagetime + category_code_12_count + 
                  X.U.B300..U.CD9C._usagetime + X.U.AD50..U.D1B5..U.CE74..U.B4DC._usagetime + 
                  X.U.C74C..U.C545...U.C2A4..U.D2B8..U.B9AC..U.BC0D._usagetime + 
                  X.U.B179..U.C74C..U.AE30._usagetime + X.U.BB34..U.C74C..U.CE74..U.BA54..U.B77C._usagetime + 
                  company_code_PA00012_count + X.U.C5EC..U.D589...U.C815..U.BCF4._usagetime + 
                  X.U.C190..U.C804..U.B4F1._usagetime + X.U.C2E0..U.C6A9..U.C870..U.D68C._usagetime + 
                  X.U.C1FC..U.D551._usagetime + X.U.D648..U.C6D0..U.ACA9..U.AD00..U.B9AC._usagetime + 
                  X.U.B2EC..U.B825...U.C77C..U.C815..U.AD00..U.B9AC._usagetime + 
                  X.U.C8FC..U.C720..U.C18C._usagetime + X.U.B3D9..U.D638..U.D68C...U.C18C..U.BAA8..U.C784._usagetime + 
                  X.U.BC18..U.B824..U.B3D9..U.BB3C._usagetime + X.U.C18C..U.C15C...U.C5F0..U.ACC4._usagetime + 
                  X.U.CF58..U.D150..U.CE20._usagetime + X.U.B80C..U.D130..U.CE74._usagetime, 
                data = transformed_data)

summary(lm.boxcox_1)
plot(lm.boxcox_1)

#boxcox를 하면 결정계수가 떨어지네용..

#입금 말고 출금을 빼볼게요 ^^

lm_again<-lm(formula = price_sum_by_by_approval_type_LT01 ~ company_code_PA00004_count + 
     company_code_PA00011_count + price_sum_by_by_approval_type_LA + 
     X.U.C0AC..U.C9C4...U.C778..U.D654._usagetime + category_code_6_count + 
     X.U.D544..U.D130...U.CE74..U.BA54..U.B77C._usagetime + X.U.B0A0..U.C528._usagetime + 
     X.U.AE30..U.C5C5...U.D559..U.D68C._usagetime + X.U.CE74..U.BA54..U.B77C...U.CEE8..U.D2B8..U.B864..U.B7EC._usagetime + 
     X.U.AC8C..U.C784...U.CEE4..U.BBA4..U.B2C8..U.D2F0._usagetime + 
     company_code_PA00010_count + X.U.C911..U.ACE0..U.AC70..U.B798._usagetime + 
     X.U.C790..U.C0B0..U.D1B5..U.D569..U.AD00..U.B9AC._usagetime + 
     CCTV.U.BDF0..U.C5B4._usagetime + 
     X.U.D504..U.B9B0..U.D130...U.D329..U.C2A4._usagetime + X.U.B3C8..U.BC84..U.B294...U.B9AC..U.C6CC..U.B4DC._usagetime + 
     AR.VR_usagetime + X.U.BC31..U.D654..U.C810...U.C628..U.B77C..U.C778..U.BAB0._usagetime + 
     price_sum_by_by_approval_type_FC + X.U.C131..U.D615..U.C815..U.BCF4._usagetime + 
     X.U.C219..U.BC15._usagetime + X.U.C74C..U.C131...U.C601..U.C0C1..U.D1B5..U.D654._usagetime + 
     price_sum_by_by_approval_type_LD + X.U.D2F0..U.CF13...U.C608..U.B9E4._usagetime + 
     X.U.BB38..U.C11C._usagetime + X.U.C571..U.C124..U.CE58..U.D504..U.B85C..U.ADF8..U.B7A8._usagetime + 
     X.U.B300..U.D559..U.AD50._usagetime + X.U.D30C..U.C77C...U.B2E4..U.C6B4..U.B85C..U.B354._usagetime + 
     X.U.D30C..U.C77C..U.AD00..U.B9AC._usagetime + price_sum_by_by_approval_type_FA + 
     price_sum_by_by_approval_type_LC + QR.U.C2A4..U.CE90..U.B108._usagetime + 
     X.U.AC80..U.C0C9..U.D3EC..U.D138._usagetime + X.U.C601..U.D654._usagetime + 
     X.U.B3C4..U.C11C..U.AD00._usagetime + category_code_12_count + 
     X.U.B300..U.CD9C._usagetime + X.U.AD50..U.D1B5..U.CE74..U.B4DC._usagetime + 
     X.U.C74C..U.C545...U.C2A4..U.D2B8..U.B9AC..U.BC0D._usagetime + 
     X.U.B179..U.C74C..U.AE30._usagetime + X.U.BB34..U.C74C..U.CE74..U.BA54..U.B77C._usagetime + 
     company_code_PA00012_count + X.U.C5EC..U.D589...U.C815..U.BCF4._usagetime + 
     X.U.C190..U.C804..U.B4F1._usagetime + X.U.C2E0..U.C6A9..U.C870..U.D68C._usagetime + 
     X.U.C1FC..U.D551._usagetime + X.U.D648..U.C6D0..U.ACA9..U.AD00..U.B9AC._usagetime + 
     X.U.B2EC..U.B825...U.C77C..U.C815..U.AD00..U.B9AC._usagetime + 
     X.U.C8FC..U.C720..U.C18C._usagetime + X.U.B3D9..U.D638..U.D68C...U.C18C..U.BAA8..U.C784._usagetime + 
     X.U.BC18..U.B824..U.B3D9..U.BB3C._usagetime + X.U.C18C..U.C15C...U.C5F0..U.ACC4._usagetime + 
     X.U.CF58..U.D150..U.CE20._usagetime + X.U.B80C..U.D130..U.CE74._usagetime, 
   data = transformed_data)

summary(lm_again)
plot(lm_again)

#비선형 모델을 해야하나봐요.. 
