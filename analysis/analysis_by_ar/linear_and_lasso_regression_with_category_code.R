data2<-read.csv("C:/Users/user/Downloads/payments_ppdb_app_category_code_aggregated2.csv")

attach(data2)



#multicolinearity: no multicolinearity

library(car)
vif(lm(price_sum_by_by_approval_type_LT01~category_code_1_count+category_code_2_count+ category_code_3_count+ category_code_4_count+ 
       category_code_5_count+ category_code_6_count+ category_code_7_count+ category_code_8_count+
       category_code_9_count+ category_code_10_count+ category_code_11_count+ category_code_12_count+ 
       category_code_13_count+ category_code_14_count+ category_code_15_count+ category_code_16_count, data=data2))

##basic regression: category: choose category 2,3,4,5,6,9,13,14

summary(lm(price_sum_by_by_approval_type_LT01~category_code_1_count+category_code_2_count+ category_code_3_count+ category_code_4_count+ 
            category_code_5_count+ category_code_6_count+ category_code_7_count+ category_code_8_count+
            category_code_9_count+ category_code_10_count+ category_code_11_count+ category_code_12_count+ 
            category_code_13_count+ category_code_14_count+ category_code_15_count+ category_code_16_count, data=data2))


#lasso regression:choose category 6: remove 1,2,10,15

library(glmnet)


x <- model.matrix(price_sum_by_by_approval_type_LT01~category_code_1_count+category_code_2_count+ category_code_3_count+ category_code_4_count+ 
                    category_code_5_count+ category_code_6_count+ category_code_7_count+ category_code_8_count+
                    category_code_9_count+ category_code_10_count+ category_code_11_count+ category_code_12_count+ 
                    category_code_13_count+ category_code_14_count+ category_code_15_count+ category_code_16_count, data2)[,-1]
y <- data2$price_sum_by_by_approval_type_LT01

set.seed(1575)
train = sample(1:nrow(x), nrow(x)/2)
test = (-train)
ytest = y[test]

cv.lasso <- cv.glmnet(x[train,], y[train], alpha=1)
lasso.coef = predict(cv.lasso, type = "coefficients", s=cv.lasso$lambda.min) # coefficients
lasso.coef
lasso.prediction = predict(cv.lasso, s=cv.lasso$lambda.min, newx = x[test,]) # coefficients

plot(cv.lasso) ## 1 
plot(cv.lasso$glmnet.fit, xvar="lambda", label=TRUE) ## 2
plot(cv.lasso$glmnet.fit, xvar="norm", label=TRUE) ## 3






