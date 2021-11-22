library(GISTools)
library(plyr)
library(magrittr)
library(dplyr)
library(ggplot2)
library(tmap)
library(tmaptools)
library(twitterTheme)
library(rgdal)
library(sf)
library(tigris)
library(RColorBrewer)

nc.shapefile <- readOGR("NC.shp")



c("POP1990","POP2000",
  "MNEM2000","MNEM1990",
  "TOTJOB2000","TOTJOB1990")

nc.shapefile@data <- nc.shapefile@data %>% 
  mutate(
    POP1990=POP1990 %>% as.numeric(),
    POP2000=POP2000 %>% as.numeric(),
    MNEM2000=MNEM2000 %>% as.numeric(),
    MNEM1990=MNEM1990 %>% as.numeric(),
    TOTJOB2000=TOTJOB2000 %>% as.numeric(),
    TOTJO1990=TOTJO1990 %>% as.numeric()
  )
 

hist(MNEM2000, probability = T, col = "red",breaks = "fd")
lines(density(MNEM2000), lwd = 4, lty = "dashed",
      col = "black")
abline()
abline(v = mean(MNEM2000), lwd = 4, lty = 'dotted',
       col = "blue")
abline(v = median(MNEM2000), lwd = 4,
       lty = "twodash", 
       col = "green")
leg <- legend(x = "topright", c("Density plot", "Mean",
                         "Median"),
                 col = c("black", "blue", "green"),
                 lwd = c(4, 4, 3),
                 lty = c("dashed", "dotted", "twodash"))


shp <- c("ncshp")
field <- c("TOTJO1990")


gbreaks <-  ncshp$MNEM2000 %>% pretty(range(.), n = nclass.FD(.), min.n = 1)
gbwidth <-  gbreaks[2] - gbreaks[1]

ggplot(ncshp@data, aes(x = MNEM2000)) +
  theme(text = element_text(family = "mono",
                            size = 14),
        plot.title = element_text(hjust = .5,
                                  size = 16,
                                  face = "bold"),
        legend.position = "right",
        legend.key = element_rect(color = NA)) +
  geom_histogram(fill = "red2",
                 aes(y = ..density..),
                 binwidth = gbwidth,
                 center = gbwidth/2) + 
  labs(y = "Density",
       title = "Manufacturing Jobs (2000)") + 
  geom_density(size = 1.2, aes(color = "Density",
                   linetype = "Density",)) +
  geom_vline(size = 1.2, aes(xintercept = MNEM2000 %>% mean(),
             color = "Mean",
             linetype = "Mean")) + 
  geom_vline(size = 1.2, aes(xintercept = MNEM2000 %>% median(),
             color = "Median",
             linetype = "Median")) +
  scale_color_manual(name = "",
                     values = c("Median" = "green",
                                "Mean" = "blue",
                                "Density" = "black")) + 
  scale_linetype_manual(name ="",
                        values = c("Median" = "twodash",
                                   "Mean" = "dashed",
                                   "Density" = "solid"))





jobrate.2000 <- sum(nc.shapefile$MNEM2000)/sum(nc.shapefile$TOTJOB2000)
jobrate.1990 <- sum(nc.shapefile$MNEM1990)/sum(nc.shapefile$TOTJO1990)

nc.shapefile$LQ2000 <- (nc.shapefile$MNEM2000/nc.shapefile$TOTJOB2000)/jobrate.2000
nc.shapefile$LQ1990 <- (nc.shapefile$MNEM1990/nc.shapefile$TOTJO1990)/jobrate.1990

nc.shapefile@data <- nc.shapefile@data %>% 
  mutate(
    ABBR = abbreviate(NAME, minlength = 3L,strict = F)
  )


writeOGR(nc.shapefile,dsn = getwd(),layer = "nc_shp" , driver = "ESRI Shapefile", overwrite_layer = T)

ncshp <- readOGR("nc_shp.shp")

states <- states(cb = T) %>% 
  filter(STUSPS %in%  c("TN", "VA","GA", "SC", "KY"))
mg <- .01

lqmap <- function(year, palette = brewer.pal(5, "Greens")){
  (tm_shape(ncshp, is.master = T) +
  
  tm_layout(outer.margins = c(mg,mg,mg,mg),
            fontfamily = "mono",
            main.title = paste0("Location Quotient of\nManufacuring Jobs (",year,")"),
            main.title.position = "center",
            frame.lwd = 4) +
  tm_polygons(col = paste0("LQ",year), 
              palette = palette,
              border.col = "black",
              style = "pretty",
              border.alpha = .5) + 
  tm_text("ABBR",
          size = .8,
          alpha = .8) + 
  tm_shape(states) + 
  tm_borders(col = "gray50",
             alpha = .7))
}
lqsave <- function(year, palette){
  lqmap(year, palette) %>% assign(paste0("lm",year),.) %>% 
  
  tmap_save(filename = paste0("lq",year,".png"))
}

for (i in c(1990, 2000)){
  lqsave(i, palette = brewer.pal(5, "Greens"))
}


ncshp$LQ1990 %>% multiply_by(2) %>% round_any(.5) %>% multiply_by(.5) %>% sort() %>% table()

ncshp$LQ2000 %>% multiply_by(2) %>% round_any(.5) %>% multiply_by(.5) %>% sort() %>% table()

