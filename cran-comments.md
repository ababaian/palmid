# Resubmission

## Previous cran-comments

> Use standard evaluation whenever possible.
> If you use non standard evaluation e.g. with asome of the (un)tidyverse packages, declare these via globalVariables(), see its help page.

Updated to standard evaluation, and using local variables bindings and .data with associated tidyverse functions.

> RE: Runtime
> Please reduce.

Reduced the example data to a single query, runtime is still 5s, which is the server processing time. Query cannot be reduced any further.

## Test environments
* local ubuntu 20.01, R 4.0.3
* win-builder (devel)

## R CMD check results

0 errors | 0 warnings | 1 notes

### Notes
* This is a new release.

# Initial Submission

## Test environments
* local ubuntu 20.01, R 4.0.3
* win-builder (devel)

## R CMD check results

0 errors | 0 warnings | 3 notes

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

* The example data includes submitting SQL queries on an outside server, those functions are complex and may take >10s depending on server load.

```
N  Flavor: r-devel-windows-ix86+x86_64
   Check: examples, Result: NOTE
      Examples with CPU (user + system) or elapsed time > 10s
              user system elapsed
  get.palmSra 4.57   0.17      32

```