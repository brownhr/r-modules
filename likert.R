p_n <- p %>% group_by(Quarter) %>% count(`Parking facilities`) %>% 
  mutate(
    Year = paste0("20",str_extract(Quarter, pattern = "\\d{2}"))
  )

HH::likert(Quarter~., p_n)
