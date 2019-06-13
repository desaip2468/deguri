data<-read.csv("C:/Users/user/Desktop/2019-1/DATA/EMBRAIN/data_for_modeling5.csv")
data<-data[ , -c(36:232)] #엠브레인 기준 usagetime 컬럼은 제거하겠습니다
data1<-read.csv("payments_ppdb_app_g2_company_code_aggregated_cp949.csv")


#기존 aggregated data + google 기준 데이터 +real_price

hi<-data.frame(data1$panel_id, data1%>%dplyr::select(ends_with("usagetime")), data1%>%select(starts_with("approval_real_price_sum_by_by_approval_type"))) #구글기준 usagetime 컬럼과 real price 컬럼다추출

colnames(hi)[1] <-"panel_id" #이름이 이상하게 바뀌어서 다시 정해줍니다


data$panel_id<-as.character(data$panel_id)
hi$panel_id<-as.character(hi$panel_id)

data2<-full_join(data,hi, by="panel_id")


#5060 user 추출

old<-data2%>%filter(data$age>=50) #50대 이상만 추출
user<-old%>%filter(approval_real_price_sum_by_by_approval_type_LT01>0) #user만 추출


#outlier 제거 (간편결제 이용액 기준 상위 3개 행 제거)

sorted <- user[c(order(user$approval_real_price_sum_by_by_approval_type_LT01, decreasing = TRUE)),] 

user<- sorted[-c(1,2,3), ] #상위 3개 아웃라이어 제거 

user<-user[ , -1] #이 컬럼은 왜 자꾸 생기는지 모르겠는데 지우겠습니다


#x 변수에 0이 많으므로 log(x+1)을 취해줌. 

category<-user%>%dplyr::select(starts_with("category"))
category<-log(category+1)
company<-user%>%dplyr::select(starts_with("company"))
company<-data.frame(company, user$bksum,	user$cdsum,	user$cusum,	user$sesum,	user$sbsum,	user$spsum)
company<-log(company+1)
usagetime<-user%>%dplyr::select(ends_with("usagetime"))
usagetime<-log(usagetime+1)
price_sum<-user%>%dplyr::select(starts_with("approval_real_price_sum_by_by_"))

user<-data.frame(user$age, category, company, usagetime,  price_sum)






#일단 기본 선형 회귀 돌려봅니다
summary(lm(user$approval_real_price_sum_by_by_approval_type_LT01~., data=user))
plot(lm(user$approval_real_price_sum_by_by_approval_type_LT01~., data=user))


#forward selection 방법으로 변수 선택

lm.null<-lm(approval_real_price_sum_by_by_approval_type_LT01~1, data=user)
lm.full<-lm(approval_real_price_sum_by_by_approval_type_LT01~., data=user)
forward.selection<- step(lm.null, direction = "forward", scope=list(lower=lm.null, upper=lm.full))
summary(forward.selection)


#lm.forwad 모델에 대해 다중공선성 체크를 해보겠습니다 

library(car)

which(car::vif(forward.selection)>4) #다중 공선성이 있는 컬럼은 없어보입니다 


# 검정 결과 변환이 필요해보입니다 

plot(forward.selection)


#boxcox transformation

library(MASS)

summary(forward.selection)
bc_norm <- MASS::boxcox(forward.selection)
lambda <- bc_norm$x[which.max(bc_norm$y)]
lm.boxcox<-lm(formula = approval_real_price_sum_by_by_approval_type_LT01 ~ 
                company_code_PA00004_count + company_code_PA00011_count + 
                user.cdsum + X...C_usagetime + Au.._usagetime + X.¹.u.μðAUAI_usagetime + 
                X.ÆAEAIμa_usagetime + user.spsum + company_code_PA00010_count + 
                approval_real_price_sum_by_by_approval_type_LA + X..E._usagetime + 
                AuAi_usagetime + AIº.Æ._usagetime + A.Ao³e_usagetime + 
                X³..._usagetime + AC.a_usagetime + ºIμ..e.E..AIA....i_usagetime, 
              data = user)

# 잔차 그림이 많이 좋아진 것에 비해 결정계수는 0.1정도밖에 안떨어졌네용. 아까보다는 나아보입니다.

summary(lm.boxcox)
plot(lm.boxcox)

