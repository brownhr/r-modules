election@data <- election_sp@data %>% 
  mutate(
    across(.cols = -c(NAME, STATE_NAME, STATE_FIPS, CNTY_FIPS, FIPS),
           .fns = function(x){
             ifelse(is.na(as.numeric(x)),
                    x, as.numeric(x))
           })
  )

e <- "+proj=lcc +lat_1=20n +lat_2=60n +lon_0=90w"

election@proj4string@projargs <- e


election_sf <- st_as_sf(election)

st_crs(election_sf) <- 4326
map_centroids <- st_centroid(election_sf)

W_cont_el <- poly2nb(election_sf, queen = T)
W_cont_el_mat <- nb2listw(W_cont_el, style = "W", zero.policy = T)


W_cont_el_mat.sf <-
  as(nb2lines(W_cont_el,
              coords = as(map_centroids, "Spatial")), "sf") %>%
  st_set_crs(st_crs(election_sf))

ggplot(W_cont_el_mat.sf) + 
  geom_sf(lwd = .25)


moran.test(election_sf$Bush_pct,
           list = W_cont_el_mat,
           zero.policy = T)


ols <- lm(Bush_pct ~ pcincome, data = election_sf)


election_sf <- election_sf %>%
  mutate(
    residuals = ols$residuals
  )

ggplot(election_sf, aes(fill = residuals %>% unname())) + 
  geom_sf(color = "transparent") + 
  scale_fill_steps2(low = "red",
                    mid = "white",
                    high = "blue",
                    nice.breaks = T,
                    show.limits = T) + 
  labs(fill = "Residuals",
       title = "Residuals of % Bush Voters ~ Income per Capita")


election_spatialreg <- spatialreg::lagsarlm(Bush_pct ~ pcincome, data = election_sf, listw = W_cont_el_mat, zero.policy = T)


spatialerror <- 
  spatialreg::errorsarlm(Bsh_pct ~ pcincom,
                         data = election_sf,
                         listw = W_cont_el_mat,
                         zero.policy = TRUE)


saveRDS(spatialerror, "data/spatialerror.RDS")

election_sf <- election_sf %>%
  mutate(
    rsdls_e = spatialerror$residuals
  )

moran <- 
  moran.test(x = election_sf$residls,
             listw = W_cont_el_mat,
             zero.policy = TRUE)





election_sf <- election_sf %>% 
  mutate(
    residuals_lag = unname(election_spatialreg$residuals)
  )


ggplot(election_sf, aes(fill = residuals_lag)) +
  geom_sf(color = "transparent") +
  scale_fill_steps2(
    low = "red",
    mid = "white",
    high = "blue",
    nice.breaks = T,
    show.limits = T) +
  labs(fill = "Residuals",
       title = "Residuals with Spatial Lag",
       subtitle = "Percent Bush voters as function of Per Capita Income")
