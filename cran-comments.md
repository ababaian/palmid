## Test environments
* local ubuntu 20.01, R 4.0.3
* win-builder (devel)

## R CMD check results

0 errors | 0 warnings | 2 notes

### Notes
* This is a new release.

* Internal plotting functions for `palmid` data-structures use data.frame column names to make the code more legible, these variables are implicitely defined in the import functions `read.fev()`, `read.pro()`, and `get.palmSra()`.

```
N  checking R code for possible problems (8.3s)
   PlotDistro: no visible binding for global variable ‘bg’
   PlotGeo: no visible binding for global variable ‘palm.usra’
   ...
   read.fev: no visible binding for global variable ‘fev.name’

```