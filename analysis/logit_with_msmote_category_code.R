library(tidyverse)

## Loading DMwr to balance the unbalanced class
library(DMwR)

## Train test split
library(caTools)

## ROCR curve
library(ROCR)

## MSMOTE
source('MSMOTE.R')

data <- read.csv('data/payments_ppdb_app_category_code_aggregated.csv')

x <- data %>% filter(age >= 50)
x[x$approval_real_price_sum_by_by_approval_type_LT01 > 0,"approval_real_price_sum_by_by_approval_type_LT01"] = 1
x$approval_real_price_sum_by_by_approval_type_LT01 <- factor(x$approval_real_price_sum_by_by_approval_type_LT01)

target <- x %>% select('approval_real_price_sum_by_by_approval_type_LT01')

# log(1+X)
category_code_data <- log(x %>% select(matches("^category_code_\\d{1,2}_count$")) + 1)
category_code <- cbind(target, category_code_data)

category_code_split <- sample.split(category_code$approval_real_price_sum_by_by_approval_type_LT01, SplitRatio = 0.90)
category_code_train <- category_code %>% filter(category_code_split)
category_code_test <- category_code %>% filter(!category_code_split)

## Let's check the count of unique value in the target variable
frequency.table.category_code <- as.data.frame(table(category_code_train$approval_real_price_sum_by_by_approval_type_LT01))

deficient <- frequency.table.category_code$Freq[1] - frequency.table.category_code$Freq[2]
deficient.rat <- floor(deficient / 10) * 10
balanced.category_code.result <- MSMOTE(category_code_train, 1, 5, 5, deficient.rat * 10)

new.sample.matrix <- balanced.category_code.result$new.sample.security %>% rbind(balanced.category_code.result$new.sample.border) %>% as.data.frame()
new.samples <- new.sample.matrix[sample(nrow(new.sample.matrix), deficient), ]

# if (nrow(new.sample.matrix) < deficient) {
#   deficient.border <- balanced.category_code.result$new.sample.border %>% as.data.frame()
#   new.border.samples <- deficient.border[sample(nrow(deficient.border), deficient - nrow(new.sample.matrix)), ]
#   new.samples <- new.sample.matrix %>% rbind(new.border.samples)
# } else {
#   new.samples <- new.sample.matrix[sample(nrow(new.sample.matrix), deficient), ]
# }

balanced.category_code <- new.samples %>% mutate(approval_real_price_sum_by_by_approval_type_LT01 = 1) %>% rbind(category_code_train)
balanced.category_code$approval_real_price_sum_by_by_approval_type_LT01 <- as.numeric(balanced.category_code$approval_real_price_sum_by_by_approval_type_LT01)

as.data.frame(table(balanced.category_code$approval_real_price_sum_by_by_approval_type_LT01))

model_category_code <- glm(approval_real_price_sum_by_by_approval_type_LT01~., data=balanced.category_code, family = binomial)
summary(model_category_code)

## Predict the Values
predict_category_code <- predict(model_category_code, category_code_test, type = 'response')

## Create Confusion Matrix
table(category_code_test$approval_real_price_sum_by_by_approval_type_LT01, predict_category_code > 0.3)

# AUC를 판단하는 대략적인 기준은 아래와 같습니다.

# excellent =  0.9~1
# good = 0.8~0.9
# fair = 0.7~0.8
# poor = 0.6~0.7
# fail = 0.5~0.6

# ROCR Curve
ROCRpred <- prediction(predict_category_code, category_code_test$approval_real_price_sum_by_by_approval_type_LT01)
ROCRperf <- performance(ROCRpred, 'tpr','fpr')
plot(ROCRperf, colorize = TRUE, text.adj = c(-0.2,1.7))

auc <- performance(ROCRpred, measure = "auc")
auc <- auc@y.values[[1]]
auc
