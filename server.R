# Graphs
library(ggplot2)

# String interpolation
library(stringr)

server <- function(input, output) {
  output$approvalStorePlot <- renderPlot({
    if (input$approval_store == '전체') {
      if (input$gender == 0) {
        query <- paste(
          "SELECT panel_id, COUNT(panel_id) AS panel_id_count FROM simple_payments WHERE approval_store IN (\"",
          paste(approval_stores, collapse = '", "'),
          "\") GROUP BY panel_id HAVING COUNT(panel_id) > 50 AND COUNT(panel_id) < 350"
        )
        bindParameters <- list()
      }
      else {
        query <- paste(
          "SELECT panel_id, COUNT(panel_id) AS panel_id_count FROM simple_payments WHERE gender = ? AND approval_store IN (\"",
          paste(approval_stores, collapse = '", "'),
          "\") GROUP BY panel_id HAVING COUNT(panel_id) > 50 AND COUNT(panel_id) < 350"
        )
        bindParameters <- list(input$gender)
      }
    }
    else {
      if (input$gender == 0) {
        query <- "SELECT panel_id, COUNT(panel_id) AS panel_id_count FROM simple_payments WHERE approval_store = ? GROUP BY panel_id"
        bindParameters <- list(input$approval_store)
      }
      else {
        query <- "SELECT panel_id, COUNT(panel_id) AS panel_id_count FROM simple_payments WHERE gender = ? AND approval_store = ? GROUP BY panel_id"
        bindParameters <- list(input$gender, input$approval_store)
      }
    }
    prepare <- dbSendQuery(connection, query)
    if (length(bindParameters) != 0) dbBind(prepare, bindParameters)
    result <- dbFetch(prepare)
    dbClearResult(prepare)

    # Sort by count
    result$panel_id <- factor(result$panel_id, levels = result$panel_id[order(as.integer(-result$panel_id_count))])
    multiplot(
      ggplot(result, aes(panel_id, as.integer(panel_id_count))) +
        geom_bar(stat = "identity") +
        labs(title = "", x = "panel_id", y = "빈도"),
      ggplot(result, aes(as.integer(panel_id_count))) +
        geom_bar(stat = "count") +
        labs(title = "", x = "freq", y = "count")
    )
  })

  output$xVersusYPlot <- renderPlot({
    fieldYWithAggF <- strsplit(input$field_y, " - ")[[1]]
    fieldY <- fieldYWithAggF[1]
    aggF <- fieldYWithAggF[2]

    if (input$approval_store2 == '전체') {
      if (aggF == 'count') {
        availableApprovalStores <- paste(approval_stores, collapse = '", "')

        # 전체 count 에 따른 상위 30개 field_x만 대상으로 분석해 보자
        preQuery <- str_interp("
          SELECT ${input$field_x}, COUNT(DISTINCT ${fieldY}) AS distinct_count
          FROM simple_payments WHERE approval_store IN (\"${availableApprovalStores}\")
          GROUP BY ${input$field_x} ORDER BY distinct_count DESC LIMIT 30
        ")
        preQueryResult <- dbGetQuery(connection, preQuery)
        fieldXLimits <- paste(as.vector(t(preQueryResult[input$field_x])), collapse = '", "')

        query <- str_interp("
          SELECT field1, field2, field2_count
          FROM (
            SELECT ${input$field_x} AS field1, ${fieldY} AS field2, COUNT(${fieldY}) AS field2_count,
              @rank := IF(@current_field_value = ${input$field_x}, @rank + 1, 1) AS field_rank,
              @current_field_value := ${input$field_x}
            FROM simple_payments
            WHERE ${fieldY} IS NOT NULL
            AND approval_store IN (\"${availableApprovalStores}\")
            AND ${input$field_x} IN (\"${fieldXLimits}\")
            GROUP BY ${input$field_x}, ${fieldY}
            ORDER BY ${input$field_x}, COUNT(${fieldY}) DESC
          ) ranked_payments
          WHERE field_rank <= 10
        ")
        bindParameters <- list()
      }
      else if (aggF == 'distinct_count') {
        query <- paste(
          "SELECT ",
          input$field_x,
          ", COUNT(DISTINCT ",
          fieldY,
          ") AS distinct_count FROM simple_payments WHERE approval_store IN (\"",
          paste(approval_stores, collapse = '", "'),
          "\") GROUP BY ",
          input$field_x,
          " ORDER BY distinct_count DESC LIMIT 50"
        )
        bindParameters <- list()
      }
      else if (aggF == 'sum') {
        query <- paste(
          "SELECT ",
          input$field_x,
          ", SUM(",
          fieldY,
          ") AS sum FROM simple_payments WHERE approval_store IN (\"",
          paste(approval_stores, collapse = '", "'),
          "\") GROUP BY ",
          input$field_x,
          " ORDER BY sum DESC LIMIT 50"
        )
        bindParameters <- list()
      }
    }
    else {
      if (aggF == 'count') {
        preQuery <- str_interp("
          SELECT ${input$field_x}, COUNT(DISTINCT ${fieldY}) AS distinct_count
          FROM simple_payments WHERE approval_store = ?
          GROUP BY ${input$field_x} ORDER BY distinct_count DESC LIMIT 30
        ")
        preQueryBindParameters <- list(input$approval_store2)
        preQueryPrepare <- dbSendQuery(connection, preQuery)
        dbBind(preQueryPrepare, preQueryBindParameters)
        preQueryResult <- dbFetch(preQueryPrepare)
        dbClearResult(preQueryPrepare)
        fieldXLimits <- paste(as.vector(t(preQueryResult[input$field_x])), collapse = '", "')

        query <- str_interp("
          SELECT field1, field2, field2_count
          FROM (
            SELECT ${input$field_x} AS field1, ${fieldY} AS field2, COUNT(${fieldY}) AS field2_count,
              @rank := IF(@current_field_value = ${input$field_x}, @rank + 1, 1) AS field_rank,
              @current_field_value := ${input$field_x}
            FROM simple_payments
            WHERE ${fieldY} IS NOT NULL
            AND approval_store = ?
            AND ${input$field_x} IN (\"${fieldXLimits}\")
            GROUP BY ${input$field_x}, ${fieldY}
            ORDER BY ${input$field_x} DESC, COUNT(${fieldY}) DESC
          ) ranked_payments
          WHERE field_rank <= 10
        ")
        bindParameters <- list(input$approval_store2)
      }
      else if (aggF == 'distinct_count') {
        query <- paste(
          "SELECT ",
          input$field_x,
          ", COUNT(DISTINCT ",
          fieldY,
          ") AS distinct_count FROM simple_payments WHERE approval_store = ? GROUP BY ",
          input$field_x,
          " ORDER BY distinct_count DESC LIMIT 50"
        )
        bindParameters <- list(input$approval_store2)
      }
      else if (aggF == 'sum') {
        query <- paste(
          "SELECT ",
          input$field_x,
          ", SUM(",
          fieldY,
          ") AS sum FROM simple_payments WHERE approval_store = ? GROUP BY ",
          input$field_x,
          " ORDER BY sum DESC LIMIT 50"
        )
        bindParameters <- list(input$approval_store2)
      }
    }
    prepare <- dbSendQuery(connection, query)
    if (length(bindParameters) != 0) dbBind(prepare, bindParameters)
    result <- dbFetch(prepare)
    dbClearResult(prepare)

    if (aggF == 'count') {
      # Integer conversion, sorting
      result$field2_count <- as.integer(result$field2_count)
      return(
        ggplot(result, aes(field1, field2_count, fill = field2)) +
          geom_bar(position = 'dodge', stat = 'identity') +
          geom_text(aes(label = field2_count)) +
          labs(title = paste(input$approval_store2, input$field_x, " vs ", input$field_y), x = input$field_x, y = input$field_y) +
          theme(
            axis.text.x = element_text(angle = 90, hjust = 1),
            text = element_text(size = 14, family = "NanumGothic")
          )
      )
    }
    else {
      if (aggF == 'distinct_count') {
        result$distinct_count <- as.integer(result$distinct_count)
      }
      else if (aggF == 'sum') {
        result$sum <- as.integer(result$sum)
      }

      return(
        ggplot(result, aes_string(input$field_x, aggF)) +
          geom_bar(stat = "identity") +
          labs(title = paste(input$approval_store2, input$field_x, " vs ", input$field_y), x = input$field_x, y = input$field_y) +
          theme(
            axis.text.x = element_text(angle = 90, hjust = 1),
            text = element_text(size = 14, family = "NanumGothic")
          )
      )
    }
  })
}
