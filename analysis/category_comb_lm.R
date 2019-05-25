# select, filter, %>%
library(dplyr)

## `parse_quosure`
library(rlang)

data <- read.csv('data/payments_ppdb_app_category_code_aggregated_LT01.csv')

## Only first cluster
x <- data %>% filter(age >= 50 & 0 < approval_real_price_sum_by_by_approval_type_LT01)
target <- x %>% select(approval_real_price_sum_by_by_approval_type_LT01)

category_code <- x %>% select(matches("^category_code_LT01_\\d{1,2}_count$")) %>% cbind(target)

for(i in seq(2, 6)) {
  cat("i: ", i, '\n')
  combinations <- combn(16, i)
  for(j in seq(ncol(combinations))) {
    # cat("j: ", j, '\n')
    comb.vector <- combinations[,j]
    comb.representation <- paste(paste0('category_code_LT01_', comb.vector, '_count'), collapse = '+')
    tmp <- category_code %>% mutate(new_category_count_col = UQ(parse_quosure(comb.representation)))

    # single.formula_str <- paste('approval_real_price_sum_by_by_approval_type_LT01 ~ new_category_count_col')
    # single.summary.object <- ((tmp + 1) %>% log %>% lm(single.formula_str %>% as.formula, .) %>% summary)
    # if (single.summary.object$adj.r.squared > 0.7) {
    #   cat('########################################\n')
    #   cat(comb.representation, '\n')
    #   cat(paste(single.formula_str, single.summary.object$adj.r.squared, '\n'))
    #   print(single.summary.object)
    #   cat('########################################\n')
    # }

    multiple.formula_str <- paste('approval_real_price_sum_by_by_approval_type_LT01 ~ ', comb.representation)
    multiple.summary.object <- ((tmp + 1) %>% log %>% lm(multiple.formula_str %>% as.formula, .) %>% summary)
    if(multiple.summary.object$adj.r.squared > 0.6) {
      cat('########################################\n')
      cat(comb.representation, '\n')
      cat(paste(multiple.formula_str, multiple.summary.object$adj.r.squared, '\n'))
      print(multiple.summary.object)
      cat('########################################\n')
    }
  }
}
