# Developing the R package

The CRAN edition is derived from the native R Golden Source. By default its
tests exercise each calculation/profile, available error kinds, dated graph
examples and reporting components. Run the exhaustive frozen reference suite
with `SOLVENCY2_FULL_TESTS=true R CMD check solvency2_0.5.1.tar.gz` or set the
same environment variable before `devtools::test()`. The full-resource export
example is enabled with `SOLVENCY2_FULL_EXAMPLES=true`; ordinary examples remain
short. All reference datasets are retained regardless of the test setting.

Runtime code is native R and works offline. Native arithmetic dependencies are
declared in DESCRIPTION; Python is not a runtime dependency. The Golden Source
identity is recorded in the package resources. Private development scaffolding
and emission tools are not part of this distribution.

Keep frozen reference expectations independent of implementation changes.
Run focused tests for changed components, then the complete suite and package
check for a release. Build and install the produced source archive to check
resource availability outside the source directory. Preserve original-source,
decoded-JSON and packaged-file hashes as distinct provenance fields.

See the repository README for local build commands and system prerequisites.
Changing datasets also requires updating their inventory and license notices.
