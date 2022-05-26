library(googledrive)
library(tidyverse)
library(doconv)

output_dir <- "rendered_docs"

RMD_files <-
  list.files(path = "docs",
             pattern = "RModule.+\\.html",
             full.names = TRUE)

RMD_files %>%
  walk(
    .f = function(x) {
      name <- fs::path_ext_remove(basename(x))
      out_name <- fs::path(output_dir, fs::path_ext_set(name, ".pdf"))
      pagedown::chrome_print(input = x,
                             output = out_name)
    }
  )

rmd_gd <- drive_get(id = "1dFkBUBZY0JV6QUEMHV6mLBtZ0UPDMHjE")


rmd_out <-
  list.files("rendered_docs", pattern = "\\.pdf", full.names = TRUE)

rmd_out %>%
  walk(function(x) {
    num <- x %>%
      basename() %>%
      fs::path_ext_remove() %>%
      str_extract("\\d+")
    drive_put(x, path = rmd_ls[str_which(rmd_ls$name, paste0(num, "\\b")), ])
  })
