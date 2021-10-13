# Resubmission

## Previous cran-comments

> Thanks, Please use only undirected quotation marks in the description text. e.g. `palmscan` --> 'palmscan'

Updated code to double-quotes only and documentation contains undirected quotation marks.

> Please write TRUE and FALSE instead of T and F. (Please don't use 'T' or'F' as vector names.), e.g.:
>  man/geoFilter.Rd, man/geoFilter2.Rd, man/get.sraBio.Rd, man/get.sraOrgn.Rd, man/normalizeWordcount.Rd, man/PlotID.Rd, man/PlotOrgn.Rd, man/PlotProReport.Rd, man/PlotTax.Rd

Updated to use of full 'TRUE' or 'FALSE' throughout code and documentation.

> Some code lines in examples are commented out. Please never do that. Ideally find toy examples that can be regularly executed and checked. Lengthy examples (> 5 sec), can be wrapped in \donttest. Warning: Examples in comments in:
> get.sOTU.Rd, get.sraBio.Rd, get.sraDate.Rd, get.sraGeo.Rd, get.sraOrgn.Rd, make_bg_data.Rd, PlotGeoReport.Rd, PlotTimeline.Rd, SerratusConnect.Rd, waxsys.palm.sra.Rd, waxsys.pro.df.Rd

I've updated the toy examples and made more donttest{} examples where they are needed. Please note, waxsys.palm.sra.Rd and waxsys.palm.sra.Rd are dataest description files and do not contain examples.

> Please fix and resubmit.
<3

## Previous cran-comments

> Wrap the lengthy example in \donttest{}, please.
...
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
      Examples with CPU (user + system) or elapsed time > 10s,        user system elapsed
  get.palmSra 4.57   0.17      32

```