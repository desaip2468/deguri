library(dplyr)

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
card_payment_type_data <- log(x %>% select(matches("^card_payment_type")) %>% select(-contains('PA', ignore.case = FALSE)) + 1)
card_payment_type <- cbind(target, card_payment_type_data)

# compa <- select(x, 729:790)
# card_payment_type <- cbind(target, compa)

# card_pa <- select(x, 725:728)
# cate2 <- cbind(target, card_pa)

# ppd <- select(x, 813:1184)
# ppdb <- cbind(target, ppd)

###### category code!!!!!!
# cate1_split <- sample.split(cate1$approval_real_price_sum_by_by_approval_type_LT01, SplitRatio = 0.90)
# cate1_train <- subset(cate1, cate1_split == TRUE)
# cate1_test <- subset(cate1, cate1_split == FALSE)

card_payment_type_split <- sample.split(card_payment_type$approval_real_price_sum_by_by_approval_type_LT01, SplitRatio = 0.90)
card_payment_type_train <- card_payment_type %>% filter(card_payment_type_split)
card_payment_type_test <- card_payment_type %>% filter(!card_payment_type_split)

## Let's check the count of unique value in the target variable
as.data.frame(table(card_payment_type$approval_real_price_sum_by_by_approval_type_LT01))


## Smote : Synthetic Minority Oversampling Technique To Handle Class Imbalancy In Binary Classification
# perc.over=200,  # 적은 쪽의 데이터를 얼마나 추가로 샘플링해야 하는지
# k=5            # 고려할 최근접 이웃의 수
# perc.under=200 적은 쪽의 데이터를 추가로 샘플링할 때 각 샘플에 대응해서 많은 쪽의 데이터를
# 얼마나 샘플링할지 지정


set.seed(2217)
balanced.card_payment_type <- SMOTE(approval_real_price_sum_by_by_approval_type_LT01 ~., card_payment_type_train, perc.over =200, k = 5, perc.under = 150)

as.data.frame(table(balanced.card_payment_type$approval_real_price_sum_by_by_approval_type_LT01))


model_card_payment_type <- glm(approval_real_price_sum_by_by_approval_type_LT01~., data=card_payment_type, family = binomial)
summary(model_card_payment_type)

## Predict the Values
predict_card_payment_type <- predict(model_card_payment_type, card_payment_type_test, type = 'response')

## Create Confusion Matrix
table(card_payment_type_test$approval_real_price_sum_by_by_approval_type_LT01, predict_card_payment_type > 0.3)


# AUC를 판단하는 대략적인 기준은 아래와 같습니다.

# excellent =  0.9~1
# good = 0.8~0.9
# fair = 0.7~0.8
# poor = 0.6~0.7
# fail = 0.5~0.6

# ROCR Curve
ROCRpred <- prediction(predict_card_payment_type, card_payment_type_test$approval_real_price_sum_by_by_approval_type_LT01)
ROCRperf <- performance(ROCRpred, 'tpr','fpr')
plot(ROCRperf, colorize = TRUE, text.adj = c(-0.2,1.7))

auc <- performance(ROCRpred, measure = "auc")
auc <- auc@y.values[[1]]
auc
