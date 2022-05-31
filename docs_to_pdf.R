library(googledrive)
library(tidyverse)
library(doconv)

output_dir <- "rendered_docs"

if(!dir.exists(output_dir)) dir.create(output_dir)

RMD_files <-
  list.files(path = ".",
             pattern = "RModule.+\\.[Rr]md",
             full.names = TRUE)

RMD_files[6:10] %>%
  walk(
    .f = function(input) {
      rmarkdown::render(
        input,
        output_format = "bookdown::word_document2",
        output_dir = output_dir,
        output_options = list(
          number_sections = FALSE,
          toc = FALSE
        )
      )
    }
  )

rmd_gd <- drive_get(id = "1dFkBUBZY0JV6QUEMHV6mLBtZ0UPDMHjE")


rmd_out <-
  list.files("rendered_docs", pattern = "\\.docx", full.names = TRUE)
rmd_ls <- drive_ls(rmd_gd)

rmd_out %>%
  walk(function(x) {
    num <- x %>%
      basename() %>%
      fs::path_ext_remove() %>%
      str_extract("\\d+")
    drive_put(x, path = rmd_ls[str_which(rmd_ls$name, paste0(num, "\\b")), ])
  })
