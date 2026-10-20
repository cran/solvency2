test_that("all exports have installed help and package overview is available", {
  package_path <- system.file(package = "solvency2", mustWork = TRUE)
  # During load_all, Rd files live in man/. Installed tests use the help index.
  aliases_path <- file.path(package_path, "help", "aliases.rds")
  if (file.exists(aliases_path)) {
    aliases <- names(readRDS(aliases_path))
    expect_true(all(getNamespaceExports("solvency2") %in% aliases))
    expect_true(all(c("solvency2", "solvency2-package") %in% aliases))
  }
  for (topic in c("README", "API", "DATA", "PARAMETERS", "RECIPES", "LIMITATIONS",
    "DEVELOPMENT", "ACCEPTANCE", "DISCLAIMER", "SECURITY", "THIRD_PARTY_NOTICES", "CHANGELOG")) {
    expect_true(nzchar(documentation(topic)), info = topic)
  }
})
