library(rmarkdown)
library(purrr)

# Hi, Maggie,
#
# Run this script if you need to rebuild the rubrics. I've put them in both
# `word_document` and `pdf_document` format. Just hit the "source" button.
# Hopefully you wont need this often; it's mostly to have rubrics with embedded
# plots that can be changed easily.   Make sure your rubrics are named like
# _RM1_Rubric.Rmd, _RM2_Rubric.Rmd, etc. The leading underscore tells R studio
# to ignore the file when building the website


rubric_list <- list.files(pattern = "^_.+_Rubric\\.Rmd")

map(
  rubric_list,
  function(input) {
    rmarkdown::render(
      input = input, output_dir = "rubrics",
      output_format = "word_document"
    )
  }
)

map(
  rubric_list,
  function(input) {
    rmarkdown::render(
      input = input, output_dir = "rubrics",
      output_format = "pdf_document"
    )
  }
)
