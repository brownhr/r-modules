find_files <- function(x) { 
  s <- str_extract_all(read_lines(x), pattern = "data/\\w+\\.\\w{0,4}", simplify = T)
  s <- s[str_which(s, pattern = "example", negate = T)]
  s[nzchar(s)]
}

local_id <- local_id %>% 
  rowwise() %>% 
  mutate(
    files = list(find_files(local_rmd))
  )


local_data <- tribble(
  ~name, ~path,
  "R Module 1", "",
  "R Module 10", "export/export.zip",
  "R Module 2", "",
  "R Module 3", list("data/US_States.zip", "data/NC_Counties.zip")
  
)
