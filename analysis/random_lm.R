# select, filter, %>%
library(dplyr)

## Loading DMwR to balance the unbalanced class
library(DMwR)

## Train test split
library(caTools)

## `parse_quosure`
library(rlang)

setwd('analysis')
data <- read.csv('data/payments_ppdb_app_g2_category_code_aggregated.csv')

## Only first cluster
x <- data %>% filter(age >= 50 & 0 < approval_real_price_sum_by_by_approval_type_LT01 & approval_real_price_sum_by_by_approval_type_LT01  < 1396500)
target <- x %>% select(approval_real_price_sum_by_by_approval_type_LT01)

mutate_params <- x %>% select(matches('usagetime$')) %>% colnames %>% paste(collapse = '+')
x <- x %>% mutate(total_usagetime = UQ(parse_quosure(mutate_params)))

for(c1 in x%>%colnames) {
  for(c2 in x%>%colnames) {
    tryCatch({
      formula_str <- paste('log(', c1, ' + 1) ~ log(', c2, ' + 1)')
      summary.object <- (x %>% lm(formula_str %>% as.formula, .) %>% summary)
      if(summary.object$adj.r.squared > 0.3) {
        cat('########################################\n')
        cat(paste(formula_str, summary.object$adj.r.squared, '\n'))
        print(summary.object)
        cat('########################################\n')
      }
    }, error=function(e){})
  }
}


