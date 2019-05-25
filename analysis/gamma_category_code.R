library(dplyr)

data <- read.csv('data/payments_ppdb_app_category_code_aggregated.csv')

x <- data %>% filter(age >= 50)
x <- data %>% filter(approval_real_price_sum_by_by_approval_type_LT01 < 15000000)
target <- x %>% select('approval_real_price_sum_by_by_approval_type_LT01')

category_code_data <- x %>% select(matches("^category_code_\\d{1,2}_count$")) %>% select(-contains('17'))
category_code <- cbind(target, category_code_data)

binary_model <- 

formula <- 'approval_real_price_sum_by_by_approval_type_LT01 ~ .' %>% as.formula

model_category_code <- glm(formula, data = category_code, family = Gamma(link = 'log'))
summary(model_category_code)
