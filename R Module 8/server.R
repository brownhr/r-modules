library(shiny)
library(dplyr)
library(sf)
library(ggplot2)


NC <- readOGR("NC_REGION.shp", "NC_REGION")
NC@data <- NC@data %>%
  mutate(across(-c(NAME, NAME2, NAME_1, County, Region), as.numeric))
NC <- st_as_sf(NC)


NC_utm <- st_transform(NC, st_crs(26917))
coords <-  st_centroid(NC_utm)$geometry

shinyServer(function(input, output) {
  dat <- reactive({
    k <- knn2nb(knearneigh(coords, k = input$k)) %>%
      nb2lines(coords = coords) %>%
      as("sf") %>%
      st_set_crs(st_crs(NC_utm))
  })
  output$kplot <- renderCachedPlot({
    p <- ggplot(dat()) +
      geom_sf(data = NC_utm) +
      geom_sf() +
      geom_sf(data = coords) +
      labs(title = paste0("k = ", input$k)) +
      theme(plot.title = element_text(hjust = .5),
            text = element_text(family = "mono"))
    print(p)
    }, cacheKeyExpr = { input$k })
})