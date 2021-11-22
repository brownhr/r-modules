#' @title
#' @author
#' @description
#' @details
#' @keywords

library(shiny)
library(shinyWidgets)
library(plotly)

# Remove variables from environment.
rm(list = ls())

# Source functions.
function_files = list.files(path = "functions", full.names = TRUE, recursive = TRUE)

for (file in function_files) {
  source(file, encoding = "UTF-8")
}

# Source modules.
module_files = list.files(path = "modules", full.names = TRUE, recursive = TRUE)

for (file in module_files) {
  source(file, encoding = "UTF-8")
}
