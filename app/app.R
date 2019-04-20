# Usage: `Rscript app.R`

# Database connection
library(DBI)

# Global vars used in both ui and server
connection <- dbConnect(RMariaDB::MariaDB(), group = "desaip")
approval_stores <- as.vector(
  t(
    dbGetQuery(connection, "SELECT approval_store FROM simple_payments WHERE approval_store IS NOT NULL GROUP BY approval_store HAVING COUNT(panel_id) > 100")
  )
)

source('multiplot.R')
source('ui.R')
source('server.R')

# Run app
shinyApp(ui = ui, server = server, options = list(port = 8300))
