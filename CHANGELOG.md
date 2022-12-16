# Changelog

All notable changes to this project will be documented in this file.

## [unknown] - 2023-MM-DD

### Added

### Changed

- Example `SimpleControlledDrive_virtualMeasurement`: Use `fixedLocalSeed` for noise generator to always get reproducible results.

### Fixed

- [#4](https://github.com/DLR-SR/Credibility/issues/4): Fix mismatch size of `uncertainty.table` in function call `getTableLambdaByTolerance()`.
- [#3](https://github.com/DLR-SR/Credibility/issues/3): Omit protected sections in record `Table1D`.

## [0.1.0]  - 2022-09-17

### Added

- First public version of the library
