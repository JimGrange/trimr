## Test Environments
* local Windows 7 install, R 3.2.1
* local Mac OS X v.10.9.5, R 3.1.1
* win-builder

## R CMD Check Results
There were no ERRORs, WARNINGs, or NOTES.

## Win-Builder Test
There were two NOTES:

* "checking CRAN incoming feasibility": This is my first CRAN submission
* "checking package dependencies... ...No repository set, so cyclic dependency check skipped": I have changed my CRAN repository in .Rprofile file, but this note keeps appearing. 


There were highlights regarding "Possibly mis-spelled words in DESCRIPTION":

* "Jolicoeur (7:19)" - This is a name, and is spelled correctly.
* "Selst (7:9)" - This is a name, and is spelled correctly.

There was also one further comment worth mention:

* "The Description field should not start with the package name": The DESCRIPTION starts with "This package...", so source of this comment is unclear.
