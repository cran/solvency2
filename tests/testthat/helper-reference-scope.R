# CRAN checks every function/profile and each available structured error kind.
# The exhaustive frozen suite remains available without changing package code.
.s2_test_full <- identical(Sys.getenv("SOLVENCY2_FULL_TESTS"), "true")
.s2_test_representative <- function(cases) {
  if (.s2_test_full) return(cases)
  keys <- vapply(cases, function(x) paste(x[["function"]], x$context$profile_id,
    if (is.null(x$expected_error)) "value" else x$expected_error, sep = "/"), character(1))
  cases[!duplicated(keys)]
}
.s2_test_call <- function(expr) {
  withCallingHandlers(expr, warning = function(w) {
    # This warning is an intentional part of the demo-data contract, not a
    # numerical issue. Unexpected warnings remain visible to testthat.
    if (startsWith(conditionMessage(w), "SYNTHETIC_DEMO:")) invokeRestart("muffleWarning")
  })
}
