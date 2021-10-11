## Test environments
* local ubuntu 20.01, R 4.0.3
* win-builder (devel)

## R CMD check results

0 errors | 1 warnings | 2 notes

### Warnings
* Conflict namespace between `dbplyr` and `dplyr`, and `ggplot2` and `plotly`. Package depends on `dplyr` and `ggplot2`, and `dbplyr` and `plotly` NAMESPACE collisions do not affect any of the functions in which those packages are imported.

```
W  checking whether package ‘palmid’ can be installed (6.7s)
   Found the following significant warnings:
     Warning: replacing previous import ‘dbplyr::ident’ by ‘dplyr::ident’ when loading ‘palmid’
     Warning: replacing previous import ‘dbplyr::sql’ by ‘dplyr::sql’ when loading ‘palmid’
     Warning: replacing previous import ‘dplyr::combine’ by ‘gridExtra::combine’ when loading ‘palmid’
     Warning: replacing previous import ‘ggplot2::last_plot’ by ‘plotly::last_plot’ when loading ‘palmid’
```


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