# select, filter, %>%
library(dplyr)

## Loading DMwR to balance the unbalanced class
library(DMwR)

## Train test split
library(caTools)

data <- read.csv('data/payments_ppdb_app_g2_category_code_aggregated.csv')

x <- data %>% filter(age >= 50 & approval_real_price_sum_by_by_approval_type_LT01 < 800000)
target <- x %>% select(approval_real_price_sum_by_by_approval_type_LT01)

category_code_data <- x %>% select(matches("^category_code_\\d{1,2}_count$")) %>% select(-contains('17'))
category_code <- cbind(target, category_code_data) %>% mutate(non_zero = approval_real_price_sum_by_by_approval_type_LT01 != 0)

## Train test split
category_code_split <- sample.split(category_code$non_zero, SplitRatio = 0.90)
category_code_train <- category_code %>% filter(category_code_split)
category_code_test <- category_code %>% filter(!category_code_split)

m1 <- glm(non_zero ~ ., data = category_code_train %>% select(-approval_real_price_sum_by_by_approval_type_LT01), family = binomial(link = logit))
m2 <- glm(approval_real_price_sum_by_by_approval_type_LT01 ~ ., data = category_code_train %>% filter(non_zero) %>% select(-non_zero), family = poisson(link = log))

## Predict the Values
predict_m1 <- predict(m1, category_code_test %>% select(-approval_real_price_sum_by_by_approval_type_LT01), type = 'response')
predict_m2 <- predict(m2, category_code_test %>% filter(non_zero) %>% select(-non_zero), type = 'response')

formula <- 'approval_real_price_sum_by_by_approval_type_LT01 ~ .' %>% as.formula

summary(model_category_code)
