# select, filter, %>%
library(dplyr)

## Loading DMwR to balance the unbalanced class
library(DMwR)

## Train test split
library(caTools)

data <- read.csv('data/payments_ppdb_app_category_code_aggregated.csv')

x <- data %>% filter(age >= 50 & 0 < approval_real_price_sum_by_by_approval_type_LT01 & approval_real_price_sum_by_by_approval_type_LT01  < 1396500)
target <- x %>% select(approval_real_price_sum_by_by_approval_type_LT01)

mutate_params <- x %>% select(matches('usagetime$')) %>% colnames %>% paste(collapse = '+')
x <- x %>% mutate(total_usagetime = UQ(parse_quosure(mutate_params)))

usage_time_data <- x %>% select(matches("usagetime$"))
usage_time <- cbind(target, usage_time_data)



m1 <- glm(non_zero ~ ., data = usage_time_train %>% select(-approval_real_price_sum_by_by_approval_type_LT01), family = binomial(link = logit))
m2 <- glm(approval_real_price_sum_by_by_approval_type_LT01 ~ ., data = usage_time_train %>% filter(non_zero) %>% select(-non_zero), family = poisson(link = log))

## Predict the Values
predict_m1 <- predict(m1, usage_time_test %>% select(-approval_real_price_sum_by_by_approval_type_LT01), type = 'response')
predict_m2 <- predict(m2, usage_time_test %>% filter(non_zero) %>% select(-non_zero), type = 'response')

formula <- 'approval_real_price_sum_by_by_approval_type_LT01 ~ .' %>% as.formula

summary(model_usage_time)
