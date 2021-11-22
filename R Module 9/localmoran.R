loc.mor.queen <- localmoran(NC_utm$MNEM2000, NC_queen_listw)

printCoefmat(data.frame(loc.mor.queen))

lm.plot.q <- moran.plot(NC_utm$MNEM2000, NC_queen_listw,
                        labels = as.character(NC_utm$NAME),
                        xlab = "Manufacturing Counts",
                        ylab = "Lag Manufacturing Counts")




quadrant <- vector(mode = "numeric", length = nrow(loc.mor.queen))


mMNEM <- NC_utm$MNEM2000 - mean(NC_utm$MNEM2000)

mloc.man <- loc.mor.queen[,1] - mean(loc.mor.queen[,1])
sig <- .01

quadrant[mMNEM < 0 & mloc.man < 0] = 1
quadrant[mMNEM < 0 & mloc.man > 0] = 2
quadrant[mMNEM > 0 & mloc.man < 0] = 3
quadrant[mMNEM > 0 & mloc.man > 0] = 4

quadrant[loc.mor.queen[,5]>sig] = 0

breaks <- c(0,1,2,3,4)

quad.names <- c(
  `0` = "Insignificant",
  `1` = "Low-low",
  `2` = "Low-high",
  `3` = "High-low",
  `4` = "High-high"
)
NC_utm <- NC_utm %>% 
  mutate(
    QUAD = quadrant
  ) %>% 
  mutate(
    Quadrant = recode(
      QUAD, !!!quad.names
    ) %>% as.factor()
  )

alpha <- c(.5, .1, .05, .01)

alpha.list <- lapply(alpha, quad.sig)

do.call("plot_grid", alpha.list)
