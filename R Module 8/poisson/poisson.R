
library(dplyr)
library(tidyr)
library(tibble)
library(stringr)

poisList <- c(lambda = seq(1:20))

poisList <- lapply(poisList, function(x){rpois(250000, x)})

names(poisList) <- seq(1:20)



plist2 <- poisList %>% 
  data.frame() %>% t() %>% as.data.frame() %>% 
  rownames_to_column(var = "lambda") %>% 
  pivot_longer(cols = -lambda,
               names_to = "v",
               values_to = "n") %>% 
  dplyr::select(-v) %>% 
  mutate(
    lambda = str_replace(lambda, pattern = "X", replacement = "") %>% as.numeric()
  )


lambda <- ggplot(plist2, aes(x = n, y = ..count..)) +
  geom_bar(width = 1, fill = "violetred2") +
  transition_time(lambda) +
  ease_aes('cubic-in-out') +
  coord_cartesian(xlim = c(0, 40)) +
  labs(
    x = "Lambda = {frame_time}",
    y = "Count",
    title = "Poisson Distribution",
    subtitle = "Changing the value of Lambda"
  ) +
  theme(
    plot.title = element_text(hjust = .5,
                              face = "bold"),
    plot.subtitle = element_text(hjust = .5,
                                 face = "italic"),
    text = element_text(family = "serif"),
    legend.position = "none"
  )

pois.animation <- animate(lambda,fps = 25)
anim_save("poisson_lambda.gif", animation = pois.animation, path = "poisson/www/")
