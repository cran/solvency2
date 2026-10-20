#' Offline Solvency II Calculations and Regulatory Parameters
#'
#' Native R components for insurance solvency analysis, with explicit rule
#' profiles, regulatory parameters, synthetic reference data and auditable
#' results. Individual formulas can be used independently of the graph engine.
#'
#' @section Getting started:
#' Create a [Context()] to select valuation date, information date, currency and
#' rule profile. Call a granular function such as [intangible_risk()] and inspect
#' its `value`, `unit`, `sources`, `details` and `status`. Monetary amounts use the
#' context currency, without an implicit thousands multiplier. Rates and ratios
#' are decimal fractions unless the individual help page states otherwise.
#'
#' @section Finding functions and data:
#' [api_catalogue()] lists the reference API and [coverage()] describes the
#' supported scope. [rule_profiles()] exposes dated rule sets. [parameter()]
#' reads scalars, tables and correlation or catastrophe resources.
#' [reference_cases()], [reference_case()], [reference_portfolios()] and
#' [reference_dataset()] provide synthetic inputs and fixed expected outcomes.
#' `vignette("getting-started", package = "solvency2")` introduces the workflow;
#' [documentation()] provides additional installed, offline documentation.
#'
#' @section Main interfaces:
#' Valuation and capital calculations include [best_estimate_cashflows()],
#' [aggregate_risk()], [basic_scr()], [scr_standard_formula()] and [mcr_combined()].
#' Use [Engine()] or [calculate()] for explicitly linked calculations.
#' [DiscountCurve()] and the local JSON/CSV adapters accept user-supplied curves.
#' [NumericOverride()] records context-local sensitivities without changing
#' installed regulatory resources. [reporting_catalog()], [reporting_data()],
#' [reporting_bound_rule_check()] and [reporting_instance()] expose archived
#' definitions, component checks and draft XBRL generation.
#'
#' @section Scope and responsibility:
#' Runtime is offline. The package does not obtain market observations, develop
#' insurer-specific internal models, infer approvals or submit filings.
#' Synthetic examples are not production market data. Profile validity and
#' documented qualification limits remain explicit; a successful calculation or
#' software test is not supervisory approval. Invalid or unsupported inputs
#' produce structured [CalculationError()] conditions. See the individual
#' function's assumptions and `documentation("LIMITATIONS")` before use.
#'
#' @references European Parliament and Council (2009), Directive 2009/138/EC,
#'   <https://eur-lex.europa.eu/eli/dir/2009/138/oj>.
#'   European Commission (2014), Delegated Regulation (EU) 2015/35,
#'   <https://eur-lex.europa.eu/eli/reg_del/2015/35/oj>.
#' @seealso [Context()], [api_catalogue()], [documentation()]
#' @examples
#' ctx <- Context("2025-01-17", "2026-09-23", "EUR",
#'   "EU-S2-DOCUMENTS-2024-2025-v0.1")
#' charge <- intangible_risk(100, context = ctx)
#' charge$value
#' charge$unit
#' parameter("scalars/intangible", context = ctx)$value
#' @keywords package
"_PACKAGE"
