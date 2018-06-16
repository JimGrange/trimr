[![](http://www.r-pkg.org/badges/version/trimr)](https://cran.r-project.org/web/packages/trimr/index.html)
[![](http://cranlogs.r-pkg.org/badges/grand-total/trimr)](https://cran.r-project.org/web/packages/trimr/index.html)

trimr: Response Time Trimming in R
==================================

For a detailed overview of how to use *trimr*, please see the vignettes.

Installation
------------

A stable release of *trimr* [is available on CRAN](https://cran.r-project.org/web/packages/trimr/). To install this, use:

``` r
install.packages("trimr")
```

You can also install the latest developmental version of *trimr*. Please note, though, that this version is undergoing testing and potentially has unidentified bugs. (If you do use this version and note a bug, [please log it as an issue](https://github.com/JimGrange/trimr/issues)). To install the developmental version, you will first need to install the *devtools* package and install *trimr* directly from GitHub by using the following commands:

``` r
# install devtools
install.packages("devtools")

# install trimr from GitHub
devools::install_github("JimGrange/trimr")
```

Overview
--------

*trimr* is an R package that implements most commonly-used response time trimming methods, allowing the user to go from a raw data file to a finalised data file ready for inferential statistical analysis.

The trimming functions available in *trimr* fall broadly into three families:

1.  **Absolute Value Criterion**
2.  **Standard Deviation Criterion**
3.  **Recursive / Moving Criterion**

The latter implements the methods first suggsted by Van Selst & Jolicoeur (1994).

Example
-------

In the example below, we go from a data frame containing data from 32 participants (in total, 20,518 trials) to a trimmed data set showing the mean trimmed RT for each experimental condition & participant using the modified recursive trimming procedure of Van Selst & Jolicoeur (1994):

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
#> 1            1    792    691
#> 2            2   1036    927
#> 3            3    958    716
#> 4            4   1000    712
#> 5            5   1107    827
#> 6            6   1309   1049
#> 7            7    929    777
#> 8            8    976    865
#> 9            9    848    635
#> 10          10    735    619
#> 11          11   1008    900
#> 12          12    846    587
#> 13          13    823    688
#> 14          14    965    726
#> 15          15   1089    760
#> 16          16    845    645
#> 17          17    677    587
#> 18          18    845    718
#> 19          19    637    566
#> 20          20    934    671
#> 21          21    730    625
#> 22          22   1119    813
#> 23          23    752    627
#> 24          24    584    565
#> 25          25    576    581
#> 26          26    709    613
#> 27          27    729    688
#> 28          28    687    623
#> 29          29    528    536
#> 30          30    690    627
#> 31          31    921    859
#> 32          32    604    592
```

Installation Instructions
-------------------------

To install the package from GitHub, you need the devools package:

``` r
install.packages("devtools")
library(devtools)
```

Then *trimr* can be directly installed:

``` r
devtools::install_github("JimGrange/trimr")
```

References
----------

Van Selst, M., & Jolicoeur, P. (1994). A solution to the effect of sample size on outlier elimination. *Quarterly Journal of Experimental Psychology, 47 (A)*, 631–650.
