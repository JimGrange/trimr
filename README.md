[![](http://www.r-pkg.org/badges/version/trimr)](https://cran.r-project.org/web/packages/trimr/index.html)
[![](http://cranlogs.r-pkg.org/badges/grand-total/trimr)](https://cran.r-project.org/web/packages/trimr/index.html)

# trimr: Response Time Trimming in R

For a detailed overview of how to use *trimr*, please see the vignettes.

## Installation

A stable release of *trimr* [is available on
CRAN](https://CRAN.R-project.org/package=trimr). To install this, use:

``` r
install.packages("trimr")
```

You can also install the latest developmental version of *trimr*. Please
note, though, that this version is undergoing testing and potentially
has unidentified bugs. (If you do use this version and note a bug,
[please log it as an issue](https://github.com/JimGrange/trimr/issues)).
To install the developmental version, you will first need to install the
*devtools* package and install *trimr* directly from GitHub by using the
following commands:

``` r
# install devtools
install.packages("devtools")

# install trimr from GitHub
devtools::install_github("JimGrange/trimr")
```

## Overview

*trimr* is an R package that implements most commonly-used response time
trimming methods, allowing the user to go from a raw data file to a
finalised data file ready for inferential statistical analysis.

The trimming functions available in *trimr* fall broadly into three
families:

1.  **Absolute Value Criterion**
2.  **Standard Deviation Criterion**
3.  **Recursive / Moving Criterion**

The latter implements the methods first suggsted by Van Selst &
Jolicoeur (1994).

## Example

In the example below, we go from a data frame containing data from 32
participants (in total, 20,518 trials) to a trimmed data set showing the
mean trimmed RT for each experimental condition & participant using the
modified recursive trimming procedure of Van Selst & Jolicoeur (1994):

``` r
# load trimr's library
library(trimr)

# load the example data that ships with trimr
data(exampleData)

# look at the top of the example raw data
head(exampleData)
#>   participant condition   rt accuracy
#> 1           1    Switch 1660        1
#> 2           1    Switch  913        1
#> 3           1    Repeat 2312        1
#> 4           1    Repeat  754        1
#> 5           1    Switch 3394        1
#> 6           1    Repeat  930        1

# perform the trimming
trimmedData <- modifiedRecursive(data = exampleData, minRT = 150, digits = 0)

# look at the trimmedData
trimmedData
#>    participant Switch Repeat
#> 1            1   1047    717
#> 2           10    779    647
#> 3           11   1075    931
#> 4           12    871    638
#> 5           13    911    763
#> 6           14   1014    799
#> 7           15   1151    831
#> 8           16    983    675
#> 9           17    831    664
#> 10          18    870    761
#> 11          19    672    584
#> 12           2   1118   1022
#> 13          20   1035    718
#> 14          21    807    680
#> 15          22   1239    941
#> 16          23    786    685
#> 17           3   1020    793
#> 18           4   1103    804
#> 19           5   1184    916
#> 20           6   1430   1123
#> 21           7    994    851
#> 22           8   1118    930
#> 23           9    951    721
#> 24          24    627    589
#> 25          25    590    602
#> 26          26    721    682
#> 27          27    826    784
#> 28          28    706    653
#> 29          29    543    560
#> 30          30    751    652
#> 31          31   1080    977
#> 32          32    686    634
```

## Installation Instructions

To install the package from GitHub, you need the devools package:

``` r
install.packages("devtools")
library(devtools)
```

Then *trimr* can be directly installed:

``` r
devtools::install_github("JimGrange/trimr")
```

## References

Van Selst, M., & Jolicoeur, P. (1994). A solution to the effect of
sample size on outlier elimination. *Quarterly Journal of Experimental
Psychology, 47 (A)*, 631–650.
