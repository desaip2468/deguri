library(tidyverse)

## Loading DMwr to balance the unbalanced class
library(DMwR)

## Train test split
library(caTools)

## ROCR curve
library(ROCR)

data <- read.csv('data/payments_ppdb_app_g2.csv')

x <- data %>% filter(age >= 50)
x[x$approval_real_price_sum_by_by_approval_type_LT01 > 0,"approval_real_price_sum_by_by_approval_type_LT01"] = 1
x$approval_real_price_sum_by_by_approval_type_LT01 <- factor(x$approval_real_price_sum_by_by_approval_type_LT01)

target <- x %>% select('approval_real_price_sum_by_by_approval_type_LT01')

# log(1+X)
usage_time_data <- log(x %>% select(matches("*[^N]_usagetime$")) + 1)
usage_time <- cbind(target, usage_time_data)

# compa <- select(x, 729:790)
# company_code <- cbind(target, compa)

# card_pa <- select(x, 725:728)
# cate2 <- cbind(target, card_pa)

# ppd <- select(x, 813:1184)
# ppdb <- cbind(target, ppd)

###### category code!!!!!!
# cate1_split <- sample.split(cate1$approval_real_price_sum_by_by_approval_type_LT01, SplitRatio = 0.90)
# cate1_train <- subset(cate1, cate1_split == TRUE)
# cate1_test <- subset(cate1, cate1_split == FALSE)

library(caTools)
usage_time_split <- sample.split(usage_time$approval_real_price_sum_by_by_approval_type_LT01, SplitRatio = 0.90)
usage_time_train <- usage_time %>% filter(usage_time_split)
usage_time_test <- usage_time %>% filter(!usage_time_split)

## Let's check the count of unique value in the target variable
as.data.frame(table(usage_time$approval_real_price_sum_by_by_approval_type_LT01))


## Smote : Synthetic Minority Oversampling Technique To Handle Class Imbalancy In Binary Classification
# perc.over=200,  # 적은 쪽의 데이터를 얼마나 추가로 샘플링해야 하는지
# k=5            # 고려할 최근접 이웃의 수
# perc.under=200 적은 쪽의 데이터를 추가로 샘플링할 때 각 샘플에 대응해서 많은 쪽의 데이터를
# 얼마나 샘플링할지 지정


set.seed(2217)
balanced.usage_time <- SMOTE(approval_real_price_sum_by_by_approval_type_LT01 ~., usage_time_train, perc.over =200, k = 5, perc.under = 150)

as.data.frame(table(balanced.usage_time$approval_real_price_sum_by_by_approval_type_LT01))


model_usage_time <- glm(approval_real_price_sum_by_by_approval_type_LT01~., data=usage_time, family = binomial)
summary(model_usage_time)

## Predict the Values
predict_usage_time <- predict(model_usage_time, usage_time_test, type = 'response')

## Create Confusion Matrix
table(usage_time_test$approval_real_price_sum_by_by_approval_type_LT01, predict_usage_time > 0.3)


# AUC를 판단하는 대략적인 기준은 아래와 같습니다.

# excellent =  0.9~1
# good = 0.8~0.9
# fair = 0.7~0.8
# poor = 0.6~0.7
# fail = 0.5~0.6

# ROCR Curve
ROCRpred <- prediction(predict_usage_time, usage_time_test$approval_real_price_sum_by_by_approval_type_LT01)
ROCRperf <- performance(ROCRpred, 'tpr','fpr')
plot(ROCRperf, colorize = TRUE, text.adj = c(-0.2,1.7))

auc <- performance(ROCRpred, measure = "auc")
auc <- auc@y.values[[1]]
auc
