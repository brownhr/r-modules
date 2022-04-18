library(rmarkdown)
library(tidyverse)

# Hi, Maggie,
#
# Run this script if you need to rebuild the rubrics. I've put them in
# `word_document` format, but you can change that to `pdf_document` if you want
# PDFs instead. Make sure your rubrics are named like RM1_Rubric.Rmd,
# RM2_Rubric.Rmd, etc.


rubric_list <- list.files(pattern = "^_.+_Rubric\\.Rmd")

map(rubric_list,
    function (input){
      rmarkdown::render(
        input = input,
        output_format = "word_document"
      )
    })
