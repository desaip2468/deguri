library(tidyverse)

## Loading DMwr to balance the unbalanced class
library(DMwR)

## Train test split
library(caTools)

## ROCR curve
library(ROCR)

data <- read.csv('data/payments_ppdb_app_g_x_category_code_aggregated.csv')

x <- data %>% filter(age >= 50)
x[x$approval_real_price_sum_by_by_approval_type_LT01 > 0,"approval_real_price_sum_by_by_approval_type_LT01"] = 1
x$approval_real_price_sum_by_by_approval_type_LT01 <- factor(x$approval_real_price_sum_by_by_approval_type_LT01)

target <- x %>% select('approval_real_price_sum_by_by_approval_type_LT01')

# log(1+X)
ppdb_data <- x %>% select(matches("^X[0-9]{4}$"))
ppdb <- cbind(target, ppdb_data)


ppdb_split <- sample.split(ppdb$approval_real_price_sum_by_by_approval_type_LT01, SplitRatio = 0.90)
ppdb_train <- ppdb %>% filter(ppdb_split)
ppdb_test <- ppdb %>% filter(!ppdb_split)

## Let's check the count of unique value in the target variable
as.data.frame(table(ppdb$approval_real_price_sum_by_by_approval_type_LT01))


## Smote : Synthetic Minority Oversampling Technique To Handle Class Imbalancy In Binary Classification
# perc.over=200,  # 적은 쪽의 데이터를 얼마나 추가로 샘플링해야 하는지
# k=5            # 고려할 최근접 이웃의 수
# perc.under=200 적은 쪽의 데이터를 추가로 샘플링할 때 각 샘플에 대응해서 많은 쪽의 데이터를
# 얼마나 샘플링할지 지정


balanced.ppdb <- SMOTE(approval_real_price_sum_by_by_approval_type_LT01 ~., ppdb_train, perc.over =200, k = 5, perc.under = 150)

as.data.frame(table(balanced.ppdb$approval_real_price_sum_by_by_approval_type_LT01))


model_ppdb <- glm(approval_real_price_sum_by_by_approval_type_LT01~., data=balanced.ppdb, family = binomial)
summary(model_ppdb)

## Predict the Values
predict_ppdb <- predict(model_ppdb, ppdb_test, type = 'response')

## Create Confusion Matrix
table(ppdb_test$approval_real_price_sum_by_by_approval_type_LT01, predict_ppdb > 0.3)


# AUC를 판단하는 대략적인 기준은 아래와 같습니다.

# excellent =  0.9~1
# good = 0.8~0.9
# fair = 0.7~0.8
# poor = 0.6~0.7
# fail = 0.5~0.6

# ROCR Curve
ROCRpred <- prediction(predict_ppdb, ppdb_test$approval_real_price_sum_by_by_approval_type_LT01)
ROCRperf <- performance(ROCRpred, 'tpr','fpr')
plot(ROCRperf, colorize = TRUE, text.adj = c(-0.2,1.7))

auc <- performance(ROCRpred, measure = "auc")
auc <- auc@y.values[[1]]
auc
