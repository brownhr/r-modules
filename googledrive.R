library(googledrive)
library(tidyverse)





rubric_list <- list.files(path = "rubrics/docx", pattern = "^_.+\\.docx", full.names = TRUE)


base <- basename(rubric_list)
num <- str_extract(base, "\\d+")

map(rubric_list[4:6], function (x){
  base <- basename(x)
  num <- str_extract(x, "\\d+")
  name <- paste0("R Module ", num)
  dir <- paste0("Updated R Modules/", name, "/")
  drive_upload(x, path = dir, name = paste0(name,".docx"), overwrite = T)
})
