nc <- readOGR("NC_REGION.shp", 'NC_REGION')

nc$MNEM2000 <- nc$MNEM2000 %>% as.numeric()


aov.out <- aov(formula = MNEM2000 ~ Region, data = nc)

oneway <- oneway.test(MNEM2000 ~ Region, data = nc, var.equal = F)

bartlett.test(MNEM2000 ~ Region, data = nc)

nc$sqrt.MNEM2000 <- nc$MNEM2000 %>% sqrt()

SW.test2 <- shapiro.test(nc$sqrt.MNEM2000)
aov.2 <- aov(sqrt.MNEM2000 ~ Region, data = nc)

oneway.2 <- oneway.test(sqrt.MNEM2000 ~ Region, data = nc, var.equal = F)

NP <- kruskal.test(MNEM2000 ~ Region, data = nc)
posthoc <-TukeyHSD(aov.2)
posthoc
