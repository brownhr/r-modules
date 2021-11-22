NC.sf <- st_read("C:/Users/Harrison Brown/Documents/R Projects/Data/NC_REGION.shp")


NC_utm <- st_transform(NC.sf, st_crs(26917))
coords <-  st_centroid(NC_utm)$geometry

NC_queen <- poly2nb(NC_utm,
                    row.names = NC_utm$NAME,
                    queen = T)

NC_queen.w <- nb2listw(NC_queen)

MNEM2000.moran <- moran.test(NC_utm$MNEM2000,
                             listw = NC_queen.w,
                             alternative = 'two.sided')


# Select numeric variables, other than area and OID
NC_utm.vars <- NC_utm %>% 
  select(-NAME, -AREA, -NAME2, -OID_, -County, -Region, -geometry) %>% 
  colnames() %>% as.list()
# Get rid of Region and geometry, too
NC_utm.vars <- NC_utm.vars[-c(47,48)]


# Apply moran.test to everything within NC_utm.vars
NC.Moran <- lapply(NC_utm.vars, function(x){
  data <- NC_utm %>% dplyr::pull(x)
  moran.test(x = data, listw = NC_queen.w, zero.policy = T, 
             alternative = 'two.sided')
})

# set the name within NC.Moran to the variable it represents 
for (i in 1:length(NC.Moran)){
  name = NC_utm.vars[i]
  NC.Moran[[i]][["data.name"]] <- name[[1]]
}
# Make a dataframe 
NC.pval = data.frame()

# Extract the p-value with lapply; I'm sure there's a better way to do this


NC.moran.stats.2 = lapply(NC.Moran, function(x){
  
  x$estimate["Moran I statistic"]
  }) %>% unlist() %>% tibble()
# Do the same for the Moran's I
names(NC.pval) <- "p-value"
names(NC.moran.stats.2) <- "Moran's I Statistic"
# Set the rownames to each variable's name, then turn that into a column
# Again, not the best way to do this I know
NC.pval <- NC.pval %>% `rownames<-`(NC_utm.vars %>% unlist)
NC.pval <- tibble::rownames_to_column(NC.pval, var = "Variable")
# Bring everything together into one df.
NC.moran.stats <- bind_cols(NC.pval, NC.Moran.value)



NC.k_4 <- knn2nb(knearneigh(coords, k = 4))
k_1 <- knn2nb(knearneigh(coords, k = 1))

dist <- unlist(nbdists(k_1, coords))
max.dist <- max(dist)


NC.d_100 <- dnearneigh(coords, 0, max.dist)


W.list.names <- c("Queen", "Rook", "k = 4", "d = 100%")
W.list <- list(
  Queen = NC_queen,
  Rook = NC_rook.nb,
  `k = 4` = NC.k_4,
  `d = 100%` = NC.d_100
)


W.list.nb <- lapply(W.list, nb2listw)

W.moran <- lapply(W.list, function(w){
  moran.test(x = NC_utm$MNEM2000,
             listw = w,
             alternative = 'two.sided')
})

W.values <- data.frame(matrix(NA,
                              nrow = 4,
                              ncol = 1))

W.values$`Moran's I` <- lapply(W.moran, `[[`, 1) %>% unlist()
W.values$`p-values` <- lapply(W.moran, `[[`, 2) %>% unlist()
W.values$`Statistic` <- W.list.names

W.values <- W.values %>% dplyr::select(-1)


W.values$Neighbors <- lapply(W.list, summary)



names(W.list) <- W.list.names

cor.gram <- sp.correlogram(NC_queen, NC_utm$MNEM2000, order = 4, method = 'I', style = 'W')

cor.res.q <- cor.gram$res %>% data.frame()
cor.res.q <-  cor.gram.res %>% 
  mutate(w = "Queen",
         min = -2*sqrt(X3),
         max = 2*sqrt(X3))
cor.res.q <- cor.res.q %>% rownames_to_column(var = "lag")

cor.res.q %>% ggplot(aes(x = lag, y = X1, ymin = X1 + min, ymax = X1 + max, color = lag)) +
  geom_point(size = 2) + 
  geom_errorbar(width = .2) + 
  labs(x = "Lag",
       y = "Estimate (+/- 2*sqrt(var))",
       title = "Moran's I",
       subtitle = "Queen's Method") + 
  theme(legend.position = "null")

cor.list <- lapply(W.list, function(w)corgram(w = w, var = NC_utm$MNEM2000))


W.list.x <- W.list[-4]
library(cowplot)
cor.gg.list <- lapply(W.list.x, geom_cor)


library(tibble)
cor.gg.list.2 <- list()
for (i in 1:length(W.list.x)){
  name = W.list.names[i]
  y <- geom_cor(W.list.x[[i]], sub = name)
  cor.gg.list.2 <- append(cor.gg.list.2, list(y))
}


library(cowplot)
do.call("plot_grid", cor.gg.list.2)

