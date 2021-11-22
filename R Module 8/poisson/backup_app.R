library(dplyr)
library(tidyr)
library(tibble)
library(stringr)
library(shinydashboard)
library(ggplot2)
library(gganimate)


# source("~/R Projects/R Module 8/poisson/poisson.R")


ui <- dashboardPage(
  dashboardHeader(title = "Visualizing Poisson"),
  dashboardSidebar(sidebarMenu(
    menuItem("Poisson", tabName = "poisson", icon = icon("dashboard"))
  )),
  dashboardBody(fluidRow(box(
    plotOutput("poissonPlot", width = "100%")
  )),
  box(
    title = "Changing Lambda",
    sliderInput("lambda", "Lambda:", 1, 30, 1, animate = animationOptions(interval = 500, loop = T))
  ))
)

server <- function(input, output) {
  poisList <- c(lambda = seq(1:30))
  
  poisList <- lapply(poisList, function(x){rpois(1000, x)})
  
  names(poisList) <- seq(1:30)
  
  
  plotLambda <- reactive({
    poisList[[input$lambda]]
  }) %>% bindCache(input$lambda)
  output$poissonPlot <- renderCachedPlot({
    ggplot(plotLambda() %>% data.frame(), aes(x = .,
                             y = ..count..)) +
      geom_bar() +
      coord_cartesian(xlim = c(0, 100),
                      ylim = c(0, 200))
  }, cacheKeyExpr = {
    input$lambda
  })
}

shinyApp(ui, server)