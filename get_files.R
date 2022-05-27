get_local_files <- function() {
  local_rm_html <-
    list.files("docs", "RModule.+\\.html", full.names = TRUE)
  local_rm_pdf <-
    list.files("rendered_docs", "\\.pdf", full.names = TRUE)
  local_rm_rmd <-
    list.files(
      pattern = "RModule\\d*\\.rmd",
      full.names = TRUE,
      ignore.case = T
    )

  local_num <- local_rm_html %>%
    basename() %>%
    path_ext_remove() %>%
    str_extract("\\d+\\b")

  local_names <- paste0("R Module ", local_num)

  local_id <- left_join(
    rmd_ls,
    data.frame(
      name = local_names,
      local_html = local_rm_html,
      local_pdf = local_rm_pdf,
      local_rmd = local_rm_rmd
    )
  )
  return(local_id)
}
