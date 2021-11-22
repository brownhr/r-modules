library(GISTools)
library(sf)
library(MASS)
library(maptools)
library(rgeos)
library(RColorBrewer)
library(rgdal)
library(mapsf)
library(plyr)
library(gdata)
library(sp)
library(reshape2)
library(ggplot2)
library(ggsn)
library(tmap)
library(tmaptools)


nc <- rgdal::readOGR("C:/Users/Harrison Brown/Downloads/ncblkgrp/ncblkgrp/ncblkgrp.shp")
WNC_Counties <- rgdal::readOGR("Data/WNC_Counties.shp")

us_states <- readOGR("Data/cb_2018_us_state_20m.shp")

us_states <- spTransform(us_states, CRS(proj4string(WNC_Counties)))

# summary(nc)
# plotShades <- function(n){
#   shades <- auto.shading(nc$MED_AGE, n=n, cols=brewer.pal(n, "Greens"))
#   choropleth(nc, nc$MED_AGE, shades)
#   choro.legend(-84,37.2, sh = shades, title = "Median Age")
#   title(paste("Median Age in North Carolina (2010) by block group","(",n,")"))
#   # png(file = paste0(n,"groups.png"))
# }




WNC_Counties@data$id <- rownames(WNC_Counties@data)
tm_shape(us_states,
         bbox = tmaptools::bb(x = WNC_Counties, ext = 1.2)) + 
  tm_borders(col = "gray70", lwd = .8) +

tm_shape(WNC_Counties) +
  # tm_grid(n.x = 8,
  #         n.y = 5,
  #         col = "gray90", lwd = .1) +
  # tm_graticules(col = "gray90", lwd = .1) +
  tm_fill(col = "Golfcourse",
          title = "Number of Courses",
          style = "fixed",
          breaks = c(0,3,5,7,9,12),
          pal = hcl.colors(6, "Emrld")[1:5] %>% rev(),
          interactive = T) +
  tm_borders(col = "gray30", lwd = 1) + 
  tm_layout(
    main.title = "Golf Courses in Western North Carolina",
    main.title.size = 1.8,
    main.title.position = c("center", "top"),
    main.title.fontfamily  = "mono",
    main.title.fontface = "bold",
    frame.double.line = T,
    legend.title.size = 1.3,
    legend.title.fontfamily = "mono",
    legend.title.fontface = "italic",
    legend.bg.color = "gray90",
    legend.frame = "gray40",
    legend.width = -.25,
    legend.frame.lwd = 2,
    legend.text.fontfamily = "mono",
    legend.text.size = 1,
    inner.margins = .05,
    legend.position = c("left","top")
    
    ) +
  tm_credits("Harrison Brown,\nData acquired from ESRI",
             fontfamily = "mono",
             position = c("left", "bottom"))
tmap_save(filename = "WNC_Courses.png", width = 9, height = 5)
  


