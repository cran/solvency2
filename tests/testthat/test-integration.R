test_that("all fixed integration portfolios retain their independent values", {
  portfolios <- reference_portfolios()$portfolios
  if (!.s2_test_full) {
    # Formula-by-profile coverage is checked in test-capital; keep one linked
    # portfolio per explicit profile here and retain all portfolios opt-in.
    keys <- vapply(portfolios, function(p) p$context$profile_id, character(1))
    portfolios <- portfolios[!duplicated(keys)]
  }
  for (p in portfolios) {
    result <- suppressWarnings(calculate(p$nodes, do.call(Context, p$context)))
    for (id in names(p$expected_values)) {
      expected <- p$expected_values[[id]]
      expect_true(abs(result$results[[id]]$value - expected) <= 1e-10 * max(1, abs(expected)), info = paste(p$id, id))
    }
    expect_false(result$regulatory_total_released)
  }
})

test_that("local curve adapters preserve explicit values and reject nonlocal inputs", {
  context <- Context("2025-01-17", "2026-09-23", "EUR", "EU-S2-DOCUMENTS-2024-2025-v0.1")
  curve <- DiscountCurve("demo", context$as_of, "EUR", "custom", "synthetic", list(list("2026-01-17", .97)))
  expect_identical(discount_curve_factor(discount_curve_from_dict(discount_curve_to_dict(curve)), "2026-01-17"), .97)
  path <- tempfile(fileext = ".json")
  on.exit(unlink(path))
  jsonlite::write_json(discount_curve_to_dict(curve), path, auto_unbox = TRUE, digits = NA)
  expect_identical(load_discount_curve_json(path), curve)
  expect_error(load_discount_curve_json("https://example.invalid/curve.json"), class = "CalculationError")
  expect_error(discount_curve_factor(curve, "2027-01-17"), class = "CalculationError")
  cashflows <- list("2026-01-17" = list(expected_inflows = 10, expected_outflows = 100))
  expect_equal(best_estimate_with_curve(cashflows, curve, TRUE, "synthetic", context)$value, 87.3)
  rates <- discount_curve_from_spot_rates(list("2026-01-17" = list(annual_effective_rate = .03, time_years = 1)),
    "rates", "custom", "synthetic", "explicit year", context)
  expect_equal(discount_curve_factor(rates, "2026-01-17"), 1/1.03)
})

test_that("installed documentation and explicit exports are discoverable", {
  expect_true(nzchar(documentation("README")))
  expect_true(nzchar(documentation("API")))
  expect_error(documentation("../secret"), class = "CalculationError")
  existing <- tempfile("s2-existing-")
  dir.create(existing)
  on.exit(unlink(existing, recursive = TRUE), add = TRUE)
  expect_error(export_resources(existing), class = "CalculationError")
  if (!.s2_test_full) return(invisible(NULL))
  destination <- tempfile("s2-export-")
  on.exit(unlink(destination, recursive = TRUE))
  exported <- export_resources(destination)
  expect_true("profile.json" %in% unlist(exported$files))
  expect_error(export_resources(destination), class = "CalculationError")
  for (name in names(exported$sha256)) expect_identical(digest::digest(file = file.path(destination, name), algo = "sha256", serialize = FALSE), exported$sha256[[name]])
})
