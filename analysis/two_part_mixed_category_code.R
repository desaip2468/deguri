library(dplyr)

data <- read.csv('data/payments_ppdb_app_category_code_aggregated.csv')

x <- data %>% filter(age >= 50)
x <- data %>% filter(approval_real_price_sum_by_by_approval_type_LT01 < 800000)
target <- x %>% select('approval_real_price_sum_by_by_approval_type_LT01')

category_code_data <- x %>% select(matches("^category_code_\\d{1,2}_count$")) %>% select(-contains('17'))
category_code <- cbind(target, category_code_data) %>% mutate(non_zero = approval_real_price_sum_by_by_approval_type_LT01 != 0)

m1 <- glm(non_zero ~ ., data = category_code %>% select(-approval_real_price_sum_by_by_approval_type_LT01), family = binomial(link = logit))
m2 <- glm(approval_real_price_sum_by_by_approval_type_LT01 ~ ., data = category_code %>% filter(non_zero) %>% select(-non_zero), family = Gamma(link = log))

formula <- 'approval_real_price_sum_by_by_approval_type_LT01 ~ .' %>% as.formula

summary(model_category_code)
