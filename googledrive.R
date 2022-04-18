library(googledrive)
library(tidyverse)

google_dir <- googledrive::drive_find(q = c("starred = true")) %>% 
  filter(name == "Updated R Modules")

for (i in 3:10) { 
  dir <-  paste("R Module", i)
  drive_mkdir(dir, path = google_dir$name)
  }

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
