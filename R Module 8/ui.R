library(shiny)

shinyUI(pageWithSidebar(
  headerPanel("Varying value of k"),
  sidebarPanel(sliderInput(
    "k",
    "k =",
    min = 1,
    max = 6,
    value = 1
  )),
  mainPanel(plotOutput("kplot"))
))