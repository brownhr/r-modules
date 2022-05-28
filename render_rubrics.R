library(rmarkdown)
library(doconv)


rubric_list <-
  list.files(pattern = "^_.+_Rubric\\.Rmd", full.names = T)

out_dir <- "drive/rubrics"

if (!dir.exists(out_dir)) {
  dir.create(out_dir)
}


render_rubrics <- function() {
  walk(
    rubric_list,
    function(input) {
      base <- basename(input)
      num <- str_extract(input, "\\d+")
      out_name <- paste0("R Module ", num, " Rubric")
      out <- rmarkdown::render(
        input = input,
        output_dir = out_dir,
        output_options = list(number_sections = FALSE),
        output_format = c("bookdown::word_document2"),
        output_file = out_name
      )
      doconv::docx2pdf(out)
    }
  )
}

update_rubric_gdrive <- function() {
  rubric_docx <- list.files(
    path = out_dir,
    pattern = "\\.docx",
    full.names = TRUE)
  
  
  # Uploads .docx rubrics to Google Drive
  walk(rubric_docx, function(input) {
    base <- input %>% 
      basename() %>% 
      str_remove(" Rubric.docx")
    gd_dir <- drive_get(id = rmd_ls[rmd_ls$name == base,]$id)
    drive_put(input, path = gd_dir)
  })
}


render_rubrics()

update_rubric_gdrive()
