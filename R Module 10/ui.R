ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(dropdownButton(
      inputId = "ui_410058530894095",
      label = NULL
    )),
    mainPanel(plotlyOutput(outputId = "ui_46376412521253"))
  ),
  titlePanel(title = "title")
)
