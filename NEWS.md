# palmid 0.0.2

- Initial release. `palmid` is a containerized analysis suite and R-package for the classification of **viral RNA-dependent RNA Polymerases (RdRP)** based on the **palmprint** sub-domain and the RNA viral palmprint database [`palmdb`](https://github.com/rcedgar/palmdb).

## Features

- Reading of `palmscan` and `palmDB`/`DIAMOND`-based alignment output files.
- Automated access to the Serratus SQL-server and cross-database analysis of input sequences.
- Taxonomic inference of input viral sequencing based on RdRP protein identity.
- Geospatial and temporal analysis of virus-sequence matches.
- Virus-associated host organism analysis of the Sequence Read Archive.
- Containerized work environment for reproducible deployment.