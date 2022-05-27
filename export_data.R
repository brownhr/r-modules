find_files <- function(x) {
  s <- str_extract_all(read_lines(x), pattern = "data/\\w+\\.\\w{0,4}", simplify = T)
  s <- s[str_which(s, pattern = "example", negate = T)]
  s[nzchar(s)]
}
append_local_data <- function(x) {
  local_id <- x
  local_id <- local_id %>%
    rowwise() %>%
    mutate(
      files = list(find_files(local_rmd))
    )


  local_data <- tribble(
    ~name, ~data_files,
    "R Module 1", NA_character_,
    "R Module 10", "export/export.zip",
    "R Module 2", NA_character_,
    "R Module 3", list("data/US_States.zip", "data/NC_Counties.zip"),
    "R Module 4", "data/salary_survey.zip",
    "R Module 5", "data/us_county_pop.zip",
    "R Module 6", "data/NC_REGION.zip",
    "R Module 7", "data/NC_REGION.zip",
    "R Module 8", "data/NC_REGION.zip",
    "R Module 9", "data/NC_REGION.zip"
  )

  local_id <- left_join(local_id, local_data)
  return(local_id)
}

make_rmd_gd_dir <- function(dir){
  dir_ls <- drive_ls(dir)
  if(!"data" %in% dir_ls$name){
    data_dir <- drive_mkdir(name = "data", path = dir)
  }
  data_dir <- dir_ls[dir_ls$name == "data",]
}



