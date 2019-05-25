# Usage: `Rscript analysis/lasso.R`
library(dplyr)
library(unbalanced)
library(testit)
library(glmnet)

all_data <- read.csv('~/Downloads/payments_ppdb_app_category_code_aggregated.csv')

# Ensure that we are working with right data
assert(class(all_data) == 'data.frame')
assert(nrow(all_data) == 1424)

filtered_all_data <- all_data %>% filter(price_sum_by_by_approval_type_LT01 > 0)
filtered_all_data <- filtered_all_data %>% 
  select(-matches("^category_group|^approval_type")) %>%
  select(matches("_\\d{1,2}_count$|^price_sum_by_by_approval_type_LT01"))

# Alias
fdf <- filtered_all_data

x <- filtered_all_data %>% select(-price_sum_by_by_approval_type_LT01) %>% as.matrix() # Removes class
y <- filtered_all_data$price_sum_by_by_approval_type_LT01 # Only class

# Train-test split: Not yet...


# Register parallel backend
cl <- parallel::makeCluster(2)
doParallel::registerDoParallel(cl)

# Fitting the model (Lasso: Alpha = 1)
set.seed(217)
cv.lasso <- cv.glmnet(x, y, family='gaussian', alpha=1, parallel=TRUE, type.measure='mse')

# Results
plot(cv.lasso)
plot(cv.lasso$glmnet.fit, xvar="lambda", label=TRUE)
coefs <- coef(cv.lasso, s=cv.lasso$lambda.min)
selected_variables <- coefs@Dimnames[[1]][coefs@i]
selected_variables

formula <- paste('price_sum_by_by_approval_type_LT01 ~ ', paste(selected_variables, collapse = '+')) %>% as.formula()
fit <- lm(formula, data = filtered_all_data)

summary(fit)
