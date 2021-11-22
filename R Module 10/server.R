server <- function(input, output, session) {
  output$ui_46376412521253 <- renderPlotly({
    fig = plot_ly(
      data = iris, x = ~Sepal.Length, y = ~Petal.Length,
      type = "scatter", mode = "markers"
    ) %>%
      layout(
        title = "Sepal Length vs. Petal Length",
        xaxis = list(title = "Sepal Length"),
        yaxis = list(title = "Petal Length")
      )
    fig
  })
}
