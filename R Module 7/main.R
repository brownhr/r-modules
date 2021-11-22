NC <- readOGR(file.choose())
options(scipen = 10)


library(dplyr)
NC@data <- NC@data %>% 
  mutate_at(vars(-NAME, -NAME2, -NAME_1, -County, -Region), ~as.numeric(.))

NC@data <- NC@data %>% 
  mutate(across(-c(NAME, NAME2, NAME_1, County, Region), as.numeric))



breaks <-
  NC@data$POP2000 %>% pretty(range(.), n = nclass.FD(.), min.n = 1)
bwidth <- breaks[2] - breaks[1]
nc.hist <- NC@data %>%
  ggplot(aes(x = POP2000)) +
  geom_histogram(binwidth = bwidth,
                 center = 25000,
                 fill = twitterTheme::twitterblue) +
  geom_density(aes(y = 10 * ..scaled..,
                   color = "Density")) +
  geom_vline(aes(
    xintercept = NC@data$POP2000 %>%  mean(),
    color = "Mean"
  )) +
  geom_vline(aes(
    xintercept = NC@data$POP2000 %>%  median(),
    color = "Median"
  )) +
  scale_color_manual(name = "Statistics",
                     values = c(
                       Median = "green",
                       Mean = "red",
                       Density = "black"
                     )) +
  labs(x = "Population (2000)",
       y = "Count",
       title = "Histogram of Population (2000)") +
  theme(text = element_text(family = "mono"),
        plot.title = element_text(hjust = .5))

nc.hist %>% ggplotly()

scatter <- NC@data %>%
  ggplot(aes(x = MNEM2000 %>% sqrt, y = POP2000 %>% sqrt)) +
  geom_point() + 
  geom_smooth(method = "lm", formula= y~x,se = F) + 
  stat_poly_eq(formula = y~x,
               aes(label = paste(..eq.label.., ..rr.label.., sep = "~~~")),
                   parse = TRUE) +
  labs(
    x = "Manufacturing 2000 (Sqrt)",
    y = "Population 2000 (Sqrt)",
    title = "Correlation: Manufacturing vs. Population"
  ) + 
  theme(
    plot.title = element_text(hjust = .5)
  )
scatter
scatter %>% ggplotly()

NC_subset <- NC[, -(5:41)]
NC_subset <- NC_subset[, -(5:10)]
NC <- NC_subset

lm.2000 <- lm(NC$MNEM2000 ~ NC$POP2000)

lm.res <- lm.2000$residuals %>% as.numeric()

breaks <-  pretty(range(lm.res), n = nclass.FD(lm.res), min.n = 1)
bwidth <- breaks[2]-breaks[1]

residual.gg <- lm.2000 %>%
  ggplot(aes(x = .$residuals)) +
  geom_histogram(binwidth = bwidth,
                 fill = twitterTheme::twitterblue,
                 color = "gray30") +
  geom_vline(aes(
    xintercept = lm.2000$residuals %>% mean(),
    color = "Mean"),
             size = 1) +
  geom_vline(aes(
    xintercept = lm.2000$residuals %>% median(),
    color = "Median"
  ),
  size = 1) +
  scale_color_manual(name = "Statistics",
                     values = c(Mean = "green",
                                Median = "red")) +
  labs(x = "Residuals",
       y = "Count",
       title = "Histogram of Residuals for Manufacturing ~ Population") +
  theme(plot.title = element_text(hjust = .5))

residual.gg
residual.gg %>% ggplotly()

NC$RES2000 <- lm.2000$residuals
tm_shape(NC) +
  tm_polygons(
    col = "RES2000",
    style = "quantile",
    title = "Residuals",
    n = 4,
    legend.hist = T,
    palette = brewer.pal(4, "Greens") %>% rev()
  ) +
  tm_layout(
    legend.outside = T,
    main.title = "Residuals of Manufacturing ~ Population (2000)",
    bg.color = "grey90",
    legend.bg.color = "grey90",
    outer.bg.color = "grey90",
    legend.hist.bg.color = "grey90",
    legend.hist.height = .5
  )
