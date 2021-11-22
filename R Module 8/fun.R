getknn <- function(k, coordinates, ...) {
  knear <-
    knn2nb(knearneigh(x = coordinates, k = k)) %>%
    nb2lines(coords = coordinates) %>%
    as("sf") %>%
    st_set_crs(st_crs(NC_utm))
}

k.gg <- function(k, ...) {
  lapply(k, function(x) {
    kval <- x %>% as.character()
    k. <- getknn(x)
    k_plot <- ggplot() +
      geom_sf(data = NC_utm) +
      geom_sf(data = k.) +
      geom_sf(data = coords) +
      labs(title = paste0("k = ", kval)) +
      theme(plot.title = element_text(hjust = .5),
            text = element_text(family = "mono"))
  })
}


getd <- function(d, coordinates, ...) {
  NC_max.sf <-
      dnearneigh(x = coordinates,
               d1 = 0,
               d2 = (d * max.dist)) %>%
    nb2lines(coords = coordinates) %>%
    as("sf") %>%
    st_set_crs(st_crs(NC_utm))
  
}

d.gg <- function(d) {
  len <- as.character(d * 100)
  dl <- getd(d)
  gg <- ggplot() +
    geom_sf(data = NC_utm) +
    geom_sf(data = dl) +
    geom_sf(data = coords) +
    labs(title = paste0("Distance Construct = ", len, "%")) +
    theme(plot.title = element_text(hjust = .5),
          text = element_text(family = "mono"))
  
}