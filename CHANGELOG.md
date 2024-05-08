# Changelog

All notable changes to this project will be documented in this file.

## [0.2.0] - 2024-06-13

### Added

- [#20](https://github.com/DLR-SR/Credibility/issues/20): Enable multilingual descriptions and add German translation as a starter

### Changed

- Example `SimpleControlledDrive_virtualMeasurement`: Use `fixedLocalSeed` for noise generator to always get reproducible results.

### Fixed

- [#3](https://github.com/DLR-SR/Credibility/issues/3): Functions defined in the protected section of record `Table1D` moved into package `Utilities.Table1DScalings`.
- [#4](https://github.com/DLR-SR/Credibility/issues/4): `Table1D`: fix mismatching array size of `uncertainty.table` in the function call `getTableLambdaByTolerance()`.
- Several typos in the documentation.

## [0.1.0]  - 2022-09-17

### Added

- First public version of the library
