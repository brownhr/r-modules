quad.sig <- function(sig = .5, ...) {
  alpha <- as.character(sig)
  quadrant <- vector(mode = "numeric", length = nrow(loc.mor.queen))
  quadrant[mMNEM < 0 & mloc.man < 0] = 1
  quadrant[mMNEM < 0 & mloc.man > 0] = 2
  quadrant[mMNEM > 0 & mloc.man < 0] = 3
  quadrant[mMNEM > 0 & mloc.man > 0] = 4
  
  quadrant[loc.mor.queen[, 5] > sig] = 0
  quad.names <- c(
    `0` = "Insignificant",
    `1` = "Low-low",
    `2` = "Low-high",
    `3` = "High-low",
    `4` = "High-high"
  )
  
  
  NC.LISA <- NC_utm %>%
    mutate(QUAD = quadrant) %>%
    mutate(Quadrant = recode(QUAD,!!!quad.names) %>% as.factor()) %>%
    mutate(QuadColor = recode(Quadrant,!!!sig.colors))
  
  
  sig.colors <- c(
    "Low-low" = "#1030f7",
    "Low-high" = "#8f7efe",
    "Insignificant" = "#EEEEEE",
    "High-low" = "#e98ddb",
    "High-high" = "#fC0233"
  )
  
  
  colorScale <- scale_fill_manual(name = 'Significance', values = sig.colors)
  
  LISA <- NC.LISA %>%
    ggplot(aes(fill = Quadrant)) +
    geom_sf(color = "gray70") +
    colorScale +
    theme(text = element_text(family = "mono"),
          plot.title = element_text(hjust = .5)) + 
    labs(fill = "Significance",
         title = paste0("LISA Cluster Map at Alpha = ", alpha))
  LISA
}