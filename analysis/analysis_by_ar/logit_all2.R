library(dplyr)

## Loading DMwr to balance the unbalanced class
library(DMwR)

## Train test split
library(caTools)

## ROCR curve
library(ROCR)


#preparing data 
data<-read.csv("C:/Users/user/Desktop/2019-1/DATA/EMBRAIN/data_for_modeling5.csv")
data<-data[ , -c(36:232)] #엠브레인 기준 usagetime 컬럼은 제거하겠습니다
data1<-read.csv("payments_ppdb_app_g2_company_code_aggregated_cp949.csv")

par(mfrow=c(1,1))
plot(data1$category_code_00401_count, data1$approval_real_price_sum_by_by_approval_type_LT01)
plot(data1$category_code_00401_count, data1$approval_real_price_sum_by_by_approval_type_LT01)


length(which(data1$category_code_00401_count==0))/length(data1$category_code_00401_count)

#기존 aggregated data + google 기준 데이터 +real_price

hi<-data.frame(data1%>%dplyr::select("panel_id"), data1%>%dplyr::select(ends_with("usagetime")), data1%>%select(starts_with("approval_real_price_sum_by_by_approval_type"))) #구글기준 usagetime 컬럼과 real price 컬럼다추출


data$panel_id<-as.character(data$panel_id)
hi$panel_id<-as.character(hi$panel_id)

data2<-full_join(data,hi, by="panel_id")
colnames(data2)

#5060 user 추출

old<-data2%>%filter(data$age>=50) #50대 이상만 추출


old<-old[ , -1] #이 컬럼은 왜 자꾸 생기는지 모르겠는데 지우겠습니다



#x 변수에 0이 많으므로 log(x+1)을 취해줌. 

category<-old%>%dplyr::select(starts_with("category"))
category<-log(category+1)

company<-data.frame(old$bksum,	old$cdsum,	old$cusum,	old$sesum,	old$sbsum,	old$spsum) #companycode pa는 제외할게요 
company<-log(company+1)

usagetime<-old%>%dplyr::select(ends_with("usagetime"))

target <- old %>% select('approval_real_price_sum_by_by_approval_type_LT01')

old<-data.frame(target, old$age, category, company, usagetime) #target + age+ category + company + usagetime


#target 변수를 0과 1로 변환

old[old$approval_real_price_sum_by_by_approval_type_LT01 > 0,"approval_real_price_sum_by_by_approval_type_LT01"] = 1
old$approval_real_price_sum_by_by_approval_type_LT01 <- factor(old$approval_real_price_sum_by_by_approval_type_LT01)

old$approval_real_price_sum_by_by_approval_type_LT01





#split data

all_split <- sample.split(old$approval_real_price_sum_by_by_approval_type_LT01, SplitRatio = 0.90)
all_train <- old %>% filter(all_split)
all_test <- old %>% filter(!all_split)

## Let's check the count of unique value in the target variable

as.data.frame(table(old$approval_real_price_sum_by_by_approval_type_LT01))


  set.seed(2217)
balanced.all <- SMOTE(approval_real_price_sum_by_by_approval_type_LT01 ~., all_train, perc.over =200, k = 5, perc.under = 150)

as.data.frame(table(balanced.all$approval_real_price_sum_by_by_approval_type_LT01))

model_all <- glm(approval_real_price_sum_by_by_approval_type_LT01~., data=old, family = binomial)

summary(model_all)

predict_all <- predict(model_all, all_test, type = 'response')

## Create Confusion Matrix
table(all_test$approval_real_price_sum_by_by_approval_type_LT01, predict_all > 0.3)

# ROCR Curve
ROCRpred <- prediction(predict_all, all_test$approval_real_price_sum_by_by_approval_type_LT01)
ROCRperf <- performance(ROCRpred, 'tpr','fpr')
plot(ROCRperf, colorize = TRUE, text.adj = c(-0.2,1.7))


auc <- performance(ROCRpred, measure = "auc")
auc <- auc@y.values[[1]]
auc


#category 10,11,15 제거 

old<-old%>%select(  -c("category_code_10_count", "category_code_11_count", "category_code_15_count"))

#다시한번 가즈아



#split data

all_split <- sample.split(old$approval_real_price_sum_by_by_approval_type_LT01, SplitRatio = 0.90)
all_train <- old %>% filter(all_split)
all_test <- old %>% filter(!all_split)

## Let's check the count of unique value in the target variable

as.data.frame(table(old$approval_real_price_sum_by_by_approval_type_LT01))


set.seed(2217)
balanced.all <- SMOTE(approval_real_price_sum_by_by_approval_type_LT01 ~., all_train, perc.over =200, k = 5, perc.under = 150)

as.data.frame(table(balanced.all$approval_real_price_sum_by_by_approval_type_LT01))

model_all <- glm(approval_real_price_sum_by_by_approval_type_LT01~., data=old, family = binomial)

summary(model_all)

predict_all <- predict(model_all, all_test, type = 'response')

## Create Confusion Matrix
table(all_test$approval_real_price_sum_by_by_approval_type_LT01, predict_all > 0.3)

# ROCR Curve
ROCRpred <- prediction(predict_all, all_test$approval_real_price_sum_by_by_approval_type_LT01)
ROCRperf <- performance(ROCRpred, 'tpr','fpr')
plot(ROCRperf, colorize = TRUE, text.adj = c(-0.2,1.7))


auc <- performance(ROCRpred, measure = "auc")
auc <- auc@y.values[[1]]
auc


#variable selection

glm.null<-glm(approval_real_price_sum_by_by_approval_type_LT01~1, data=old)
glm.full<-glm(approval_real_price_sum_by_by_approval_type_LT01~., data=old)
forward.selection<- step(glm.null, direction = "forward", scope=list(lower=glm.null, upper=glm.full))
summary(forward.selection)


#split data

all_split <- sample.split(old$approval_real_price_sum_by_by_approval_type_LT01, SplitRatio = 0.90)
all_train <- old %>% filter(all_split)
all_test <- old %>% filter(!all_split)

## Let's check the count of unique value in the target variable

as.data.frame(table(old$approval_real_price_sum_by_by_approval_type_LT01))


set.seed(2217)
balanced.all <- SMOTE(approval_real_price_sum_by_by_approval_type_LT01 ~., all_train, perc.over =200, k = 5, perc.under = 150)

as.data.frame(table(balanced.all$approval_real_price_sum_by_by_approval_type_LT01))

model_all <- glm(approval_real_price_sum_by_by_approval_type_LT01~., data=old, family = binomial)

summary(model_all)

predict_all <- predict(model_all, all_test, type = 'response')

## Create Confusion Matrix
table(all_test$approval_real_price_sum_by_by_approval_type_LT01, predict_all > 0.3)

# ROCR Curve
ROCRpred <- prediction(predict_all, all_test$approval_real_price_sum_by_by_approval_type_LT01)
ROCRperf <- performance(ROCRpred, 'tpr','fpr')
plot(ROCRperf, colorize = TRUE, text.adj = c(-0.2,1.7))


auc <- performance(ROCRpred, measure = "auc")
auc <- auc@y.values[[1]]
auc

                    