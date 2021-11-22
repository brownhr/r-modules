nc <- readOGR("NC_REGION.shp", 'NC_REGION')

nc$BLACK <- nc$BLACK %>% as.numeric()


aov.black <- aov(formula = pctBLACK ~ Region, data = nc)
aov.black %>% summary()

nc$pctBLACK <- (nc$BLACK %>% as.numeric()) / (nc$POP2000 %>% as.numeric()) * 100


nc@data %>% 
  ggplot(aes(x = pctBLACK, y = Region)) +
  geom_boxplot(notch = T, notchwidth = .5) + 
  labs(
    x = "Percent",
    title = "Black Population by NC Region"
  )

nc@data %>% 
  ggplot(aes(x = pctBLACK))+
  geom_histogram() +
  facet_wrap(~ Region)

  
oneway.test(pctBLACK ~ Region, data = nc, var.equal = F)

bartlett.test(pctBLACK ~ Region, data = nc)

shapiro.test(nc$pctBLACK)


gplot.1 <- nc@data %>% 
  ggplot(aes(x = pctBLACK, color = Region))+
  geom_density()

gplot.2 <- nc@data %>% 
  ggplot(aes(x = pctBLACK %>% sqrt(), color = Region))+
  geom_density()


gridExtra::grid.arrange(gplot.1, gplot.2)


aov.sqrtblack <- aov(sqrt(pctBLACK) ~ Region, data = nc)
aov.sqrtblack %>% summary()


oneway.black.2 <- oneway.test(sqrt.MNEM1990 ~ Region, data = nc, var.equal = F)

kruskal.test(sqrt(pctBLACK) ~ Region, data = nc)

TukeyHSD(aov.pctblack) 

TukeyHSD(aov.pctblack)%>% plot()
