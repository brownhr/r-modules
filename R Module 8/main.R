NC <- readOGR("NC_REGION.shp", "NC_REGION")



NC@data <- NC@data %>%
  mutate(across(-c(NAME, NAME2, NAME_1, County, Region), as.numeric))
NC <- st_as_sf(NC)


NC_utm <- st_transform(NC, st_crs(26917))
coords <-  st_centroid(NC_utm)$geometry

NC_queen <- poly2nb(NC_utm,
                    row.names = NC_utm$NAME,
                    queen = T)


NC_queen_sf <-
  as(nb2lines(NC_queen, coords = coords$geometry), "sf") %>%
  st_set_crs(st_crs(NC_utm))
NC_rook.nb <- NC_utm %>%
  poly2nb(queen = F)
rook.cards <- card(NC_rook.nb)

NC_rook.nb$card <- rook.c

NC_rook <-
  as(nb2lines(NC_rook.nb, coords = coords$geometry), "sf") %>%
  st_set_crs(st_crs(NC_utm))






ggplot() +
  geom_sf(data = NC_utm,
          color = "gray80", fill = "gray60") +
  theme(
    plot.title = element_text(hjust = .5,
                              size = 20),
    text = element_text(family = "mono"),
    legend.position = "none"
  ) +
  geom_sf(data = NC_rook,
          color = "seagreen1") +
  geom_sf(data = coords,
          size = 2) +
  labs(title = "NC Counties Rook-method Neighbors")


summary(NC_queen)
summary(NC_rook.nb)






klist <- c(1,2,4,6)

knn.gg <- k.gg(klist)


plot_grid(plotlist = knn.gg)


k_1 <- knn2nb(knearneigh(coords, k = 1))

dist <- unlist(nbdists(k_1, coords))
max.dist <- max(dist)


dist.list <- c(.5, .75, 1, 1.25)
d.gg.list <- d.gg(dist.list)

plot_grid(plotlist = d.gg.list)

