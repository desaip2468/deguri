library(dplyr)

## Loading DMwr to balance the unbalanced class
library(DMwR)

## Train test split
library(caTools)

## ROCR curve
library(ROCR)

data <- read.csv('data/payments_ppdb_app_category_code_aggregated.csv')

x <- data %>% filter(age >= 50)
x <- x %>% mutate(non_zero = approval_real_price_sum_by_by_approval_type_LT01 > 0)

target <- x %>% select('non_zero')

# log(1+X)
category_code_data <- x %>% select(matches("^category_code_\\d{1,2}_count$")) %>% select(-contains('17'))
category_code <- cbind(target, category_code_data)

category_code_split <- sample.split(category_code$non_zero, SplitRatio = 0.90)
category_code_train <- category_code %>% filter(category_code_split)
category_code_test <- category_code %>% filter(!category_code_split)

## Let's check the count of unique value in the target variable
as.data.frame(table(category_code$non_zero))


## Smote : Synthetic Minority Oversampling Technique To Handle Class Imbalancy In Binary Classification
# perc.over=200,  # 적은 쪽의 데이터를 얼마나 추가로 샘플링해야 하는지
# k=5            # 고려할 최근접 이웃의 수
# perc.under=200 적은 쪽의 데이터를 추가로 샘플링할 때 각 샘플에 대응해서 많은 쪽의 데이터를
# 얼마나 샘플링할지 지정


# balanced.category_code <- SMOTE(non_zero ~ ., category_code_train, perc.over = 200, k = 5, perc.under = 150)

# as.data.frame(table(category_code$non_zero))

formula <- 'non_zero~.' %>% as.formula

model_category_code <- glm(formula, data=category_code, family = Gamma(link = 'identity'))
summary(model_category_code)

par(mfrow=c(4,4))
plot(formula, data = balanced.category_code)

## Predict the Values
predict_category_code <- predict(model_category_code, category_code_test, type = 'response')

## Create Confusion Matrix
table(category_code_test$non_zero, predict_category_code > 0.5)

# AUC를 판단하는 대략적인 기준은 아래와 같습니다.

# excellent =  0.9~1
# good = 0.8~0.9
# fair = 0.7~0.8
# poor = 0.6~0.7
# fail = 0.5~0.6

# ROCR Curve
ROCRpred <- prediction(predict_category_code, category_code_test$non_zero)
ROCRperf <- performance(ROCRpred, 'tpr','fpr')
plot(ROCRperf, colorize = TRUE, text.adj = c(-0.2,1.7))

auc <- performance(ROCRpred, measure = "auc")
auc <- auc@y.values[[1]]
auc
