library(dplyr)
library(tidyr)
library(tibble)
library(stringr)
library(shinydashboard)
library(ggplot2)
library(gganimate)


# source("~/R Projects/R Module 8/poisson/poisson.R")



ui <- fluidPage(
  titlePanel("Visualizing Poisson"),
  img(
    src = "www/poisson_lambda.gif",
    align = "left",
    width = "480px",
    height = "480px"
  )
  
)

server <- function(input, output, session) {

}

shinyApp(ui, server)
