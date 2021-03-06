---
title: Creating an R package
author: Martin Frigaard
date: '2021-04-08'
slug: []
categories:
  - programming
tags: [devtools]
---




This post is going to cover how to convert the `split_into_multiple()` function we wrote in the [last post](https://www.tidyverse.tips/posts/2021-03-14-how-to-write-a-custom-wrangling-function/) into a small R package. Read more about writing R packages in the [R packages book](https://r-pkgs.org/index.html)

## Install and load the necessary packages

Run the code below to install and load the necessary packages 


```r
# install
install.packages(c("devtools", "roxygen2", "testthat", "knitr",
                   "tidyverse", "fs", "withr"))
# load 
library(devtools)
library(roxygen2)
library(testthat)
library(knitr)
library(tidyverse)
library(fs)
library(withr)
```


## Creating the package

We'll use the IDE to create our new package by clicking on *Project* > *New Project* > *R package*, and then fill in the necessary information. We are going to call this package `diyrrr` (for do-it-yourself R).

<!-- <img src="images/diyrrr-pkg-01.jpg" alt="" width="80%" height="80%"/> -->

![](https://raw.githubusercontent.com/mjfrigaard/tidyverse-tips/master/content/posts/2021-04-08-creating-an-r-package/images/diyrrr-pkg-01.jpg)

After clicking on *Create Project*, a new R session will open with the following contents: 

![](https://raw.githubusercontent.com/mjfrigaard/tidyverse-tips/master/content/posts/2021-04-08-creating-an-r-package/images/diyrrr-pkg-02.jpg)

<!-- <img src="images/diyrrr-pkg-02.jpg" alt="" width="70%" height="70%"/> -->

### Package contents 

Below is a folder tree of our new package files. 


```r
diyrrr/
    ├── DESCRIPTION
    ├── NAMESPACE
    ├── R
    │   └── hello.R
    ├── diyrrr.Rproj
    └── man
        └── hello.Rd
```

The DESCRIPTION and NAMESPACE are plain text files. The `R/` folder has a single script file in it (`hello.R`). There is also an associated `man/` folder with a R documentation file for the .R file (`hello.Rd`).

## Using Git

We checked the *Create a git repository* option when we created this package (odds are will want to collaborate and get feedback), but we want to make sure this folder is set up properly (and that the appropriate files/extensions are added to the `.gitignore`). We can do this by running the `usethis::use_git()` function (no additional arguments)


```r
> usethis::use_git()
✓ Setting active project to '/Documents/diyrrr'
✓ Adding '.Rdata', '.httr-oauth', '.DS_Store' to '.gitignore'
There are 7 uncommitted files:
* '.gitignore'
* '.Rbuildignore'
* 'DESCRIPTION'
* 'diyrrr.Rproj'
* 'man/'
* 'NAMESPACE'
* 'R/'
Is it ok to commit them?

1: Absolutely
2: No way
3: Nope
```

We `Absolutely` want to do this, so we'll type `1` and hit enter: 


```r
Selection: 1
✓ Adding files
✓ Making a commit with message 'Initial commit'
```

`usethis::use_git()` was nice enough to add all the files to the repo and include a commit message. We can check the content from these functions in the Terminal with `git log` and `git status`

```bash
$ git log
commit fe0c921fae6a42e8fb11408eb9692d0f46a8af3d (HEAD -> master)
Author: Martin J Frigaard <mjfrigaard@gmail.com>
Date:   Fri Apr 9 07:04:58 2021 -0700

    Initial commit
$ git status
On branch master
nothing to commit, working tree clean
```

## Write our function

In the previous post, we a function for splitting a single column containing multiple pieces of information into an *unknown* number of new columns. After some reflection, we've decided we're going to pick a better name for this function. 

It's similar to tidyr::separate(), but with an known number of `cols`, so we will call it `separate_uk_cols` (for *separate unknown columns*)


To create this function, we use `usethis::use_r("separate_uk_cols")`


```r
usethis::use_r("separate_uk_cols")
✓ Setting active project to '@r-packages/diyrrr'
● Modify 'R/separate_uk_cols.R'
● Call `use_test()` to create a matching test file
```

This creates and opens a `R/separate_uk_cols.R` file, and we will put the code below into our new script:


```r
separate_uk_cols <- function(data, col, pattern = "[^[:alnum:]]+", into_prefix) {
  in_pattern <- pattern
  in_data <- as_tibble(data)
  in_col <- as.character(col)
  out_cols <- str_split_fixed(in_data[[in_col]],
    pattern = in_pattern,
    n = Inf
  )
  out_cols[which(out_cols == "")] <- NA
  m <- dim(out_cols)[2]
  colnames(out_cols) <- paste(into_prefix, 1:m, sep = "_")
  out_cols <- as_tibble(out_cols)
  out_tibble <- bind_cols(in_data, out_cols)
  return(out_tibble)
}
```

We removed the comments (below), but we will use these for documentation later :) 


```r
# use regex for pattern, or whatever is provided
# convert data to tibble
# convert col to character vector
# split columns into character matrix
# replace NAs in matrix
# get number of cols
# assign column names
# convert to tibble
# bind cols together
# return the out_tibble
```


As we can see, this function uses the `tibble`, `stringr` and `dplyr` packages, so we need to add these to the `DESCRIPTION` file using the `usethis::use_package()` function:


```r
> usethis::use_package(package = "tibble")
✓ Adding 'tibble' to Imports field in DESCRIPTION
● Refer to functions with `tibble::fun()`
> usethis::use_package(package = "dplyr")
✓ Adding 'dplyr' to Imports field in DESCRIPTION
● Refer to functions with `dplyr::fun()`
> usethis::use_package(package = "stringr")
✓ Adding 'stringr' to Imports field in DESCRIPTION
● Refer to functions with `stringr::fun()`
```

We see an `Imports:` section has been added to the `DESCRIPTION` file with the three packages we've included. 

```bash
$ cat DESCRIPTION 
Package: diyrrr
Type: Package
Title: What the Package Does (Title Case)
Version: 0.1.0
Author: Who wrote it
Maintainer: The package maintainer <yourself@somewhere.net>
Description: More about what it does (maybe more than one line)
    Use four spaces when indenting paragraphs within the Description.
License: What license is it under?
Encoding: UTF-8
LazyData: true
Imports: 
    dplyr,
    stringr,
    tibble
```

The output tells us we need to add the `package::function()` syntax for the three imported functions (`tibble`, `dplyr`, `stringr`):


```r
separate_uk_cols <- function(data, col, pattern = "[^[:alnum:]]+", into_prefix) {
  in_pattern <- pattern
  in_data <- tibble::as_tibble(data)
  in_col <- as.character(col)
  out_cols <- stringr::str_split_fixed(in_data[[in_col]],
    pattern = in_pattern,
    n = Inf
  )
  out_cols[which(out_cols == "")] <- NA
  m <- dim(out_cols)[2]
  colnames(out_cols) <- paste(into_prefix, 1:m, sep = "_")
  out_cols <- tibble::as_tibble(out_cols)
  out_tibble <- dplyr::bind_cols(in_data, out_cols)
  return(out_tibble)
}
```

## Inserting the Roxygen skeleton

With our cursor placed inside the `separate_uk_cols()` function, we can navigate to the toolbar and under the *'Code'* option, we will select the *'Insert Roxygen skeleton'* option.

<!-- <img src="images/diyrrr-pkg-03.jpg" alt="" width="80%" height="80%"/> -->

![](https://raw.githubusercontent.com/mjfrigaard/tidyverse-tips/master/content/posts/2021-04-08-creating-an-r-package/images/diyrrr-pkg-03.jpg)

This inserts the following code at the top of the `R/separate_uk_cols.R` file:


```r
#' Title
#'
#' @param data
#' @param col
#' @param pattern
#' @param into_prefix
#'
#' @return
#' @export
#'
#' @examples
```

The `Title` can be changed to `separate_uk_cols`.


```r
#' separate_uk_cols
```

The `@param` tags need a `name` and a `description`, we we include below:


```r
#' @param data data.frame or tibble
#' @param col column to be separated
#' @param pattern regular expression pattern
#' @param into_prefix prefix for new columns
```

The `@export` tag is set to `separate_uk_cols`


```r
#' @export separate_uk_cols
```

We will remove the `@return` and `@example` tags from the `separate_uk_cols.R` file and use the `devtools::document()` function (wrapper for  `roxygen2::roxygenize()`) to include the documentation for  `separate_uk_cols()`.


```r
> devtools::document()
ℹ Updating diyrrr documentation
First time using roxygen2. Upgrading automatically...
Updating roxygen version in /Users/mjfrigaard/Documents/diyrrr/DESCRIPTION
ℹ Loading diyrrr
Warning: The existing 'NAMESPACE' file was not generated by roxygen2, and will not be overwritten.
Writing separate_uk_cols.Rd
```

We see that `devtools::document()` updated our version of `roxygen2`, and we receive a warning telling us that the `NAMESPACE` file will not be overwritten because we created it when we build the package. Let's open this file and check it's contents:

```bash
$ cat NAMESPACE 
exportPattern("^[[:alpha:]]+")
```

Because there is only a single line in our `NAMESPACE`, we will remove this file and re-run `devtools::document()` so it will generate (and overwrite) it's contents. 


```r
> unlink(x = "NAMESPACE")
> devtools::document()
ℹ Updating diyrrr documentation
ℹ Loading diyrrr
Writing NAMESPACE
```

### .Rd contents 

Below is the contents of the `man/separate_uk_cols.Rd` file that was generated using the `@tags` in the `separate_uk_cols.R` file when we ran the `devtools::document()` function:

```
% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/separate_uk_cols.R
\name{separate_uk_cols}
\alias{separate_uk_cols}
\title{separate_uk_cols}
\usage{
separate_uk_cols(data, col, pattern = "[^[:alnum:]]+", into_prefix)
}
\arguments{
\item{data}{data.frame or tibble}

\item{col}{column to be separated}

\item{pattern}{regular expression pattern}

\item{into_prefix}{prefix for new columns}
}
\description{
separate_uk_cols
}
```

The `NAMESPACE` also includes `export(separate_uk_cols)`

```bash
$ cat NAMESPACE 
# Generated by roxygen2: do not edit by hand

export(separate_uk_cols)
```

## Checking the package

Finally, we will run `devtools::check()` (*`check` automatically builds and checks a source package, using all known best practices.*)


```r
> devtools::check()
ℹ Updating diyrrr documentation
ℹ Loading diyrrr
Writing NAMESPACE
Writing NAMESPACE
── Building ──────────────────────────────────────────────────────────────────────── diyrrr ──
Setting env vars:
● CFLAGS    : -Wall -pedantic -fdiagnostics-color=always
● CXXFLAGS  : -Wall -pedantic -fdiagnostics-color=always
● CXX11FLAGS: -Wall -pedantic -fdiagnostics-color=always
──────────────────────────────────────────────────────────────────────────────────────────────
✓  checking for file ‘/Documents/diyrrr/DESCRIPTION’ (414ms)
─  preparing ‘diyrrr’:
✓  checking DESCRIPTION meta-information
─  checking for LF line-endings in source and make files and shell scripts
─  checking for empty or unneeded directories
─  building ‘diyrrr_0.1.0.tar.gz’
   
── Checking ──────────────────────────────────────────────────────────────────────── diyrrr ──
Setting env vars:
● _R_CHECK_CRAN_INCOMING_REMOTE_: FALSE
● _R_CHECK_CRAN_INCOMING_       : FALSE
● _R_CHECK_FORCE_SUGGESTS_      : FALSE
● NOT_CRAN                      : true
── R CMD check ───────────────────────────────────────────────────────────────────────────────
─  using log directory ‘/private/var/folders/3p/wzkys03s6p1cvmn8yzm934400000gn/T/RtmpLTecoQ/diyrrr.Rcheck’
─  using R version 4.0.5 (2021-03-31)
─  using platform: x86_64-apple-darwin17.0 (64-bit)
─  using session charset: UTF-8
─  using options ‘--no-manual --as-cran’
✓  checking for file ‘diyrrr/DESCRIPTION’
─  checking extension type ... Package
─  this is package ‘diyrrr’ version ‘0.1.0’
─  package encoding: UTF-8
✓  checking package namespace information ...
✓  checking package dependencies (1.3s)
✓  checking if this is a source package
✓  checking if there is a namespace
✓  checking for executable files ...
✓  checking for hidden files and directories
✓  checking for portable file names
✓  checking for sufficient/correct file permissions
✓  checking serialization versions
✓  checking whether package ‘diyrrr’ can be installed (1.5s)
✓  checking installed package size ...
✓  checking package directory ...
✓  checking for future file timestamps (1.3s)
W  checking DESCRIPTION meta-information ...
   Non-standard license specification:
     What license is it under?
   Standardizable: FALSE
✓  checking top-level files
✓  checking for left-over files
✓  checking index information
✓  checking package subdirectories ...
✓  checking R files for non-ASCII characters ...
✓  checking R files for syntax errors ...
✓  checking whether the package can be loaded ...
✓  checking whether the package can be loaded with stated dependencies ...
✓  checking whether the package can be unloaded cleanly ...
✓  checking whether the namespace can be loaded with stated dependencies ...
✓  checking whether the namespace can be unloaded cleanly ...
✓  checking loading without being on the library search path ...
✓  checking dependencies in R code (833ms)
✓  checking S3 generic/method consistency (485ms)
✓  checking replacement functions ...
✓  checking foreign function calls ...
✓  checking R code for possible problems (1.9s)
✓  checking Rd files ...
✓  checking Rd metadata ...
✓  checking Rd line widths ...
✓  checking Rd cross-references ...
✓  checking for missing documentation entries ...
✓  checking for code/documentation mismatches (436ms)
✓  checking Rd \usage sections (1.1s)
✓  checking Rd contents (982ms)
✓  checking for unstated dependencies in examples ...
E  checking examples (830ms)
   Running examples in ‘diyrrr-Ex.R’ failed
   The error most likely occurred in:
   
   > base::assign(".ptime", proc.time(), pos = "CheckExEnv")
   > ### Name: hello
   > ### Title: Hello, World!
   > ### Aliases: hello
   > 
   > ### ** Examples
   > 
   > hello()
   Error in hello() : could not find function "hello"
   Execution halted
✓  checking for non-standard things in the check directory
✓  checking for detritus in the temp directory
   
   See
     ‘/private/var/folders/3p/wzkys03s6p1cvmn8yzm934400000gn/T/RtmpLTecoQ/diyrrr.Rcheck/00check.log’
   for details.
   
── R CMD check results ───────────────────────────────────────────────────── diyrrr 0.1.0 ────
Duration: 13.9s

> checking examples ... ERROR
  Running examples in ‘diyrrr-Ex.R’ failed
  The error most likely occurred in:
  
  > base::assign(".ptime", proc.time(), pos = "CheckExEnv")
  > ### Name: hello
  > ### Title: Hello, World!
  > ### Aliases: hello
  > 
  > ### ** Examples
  > 
  > hello()
  Error in hello() : could not find function "hello"
  Execution halted

> checking DESCRIPTION meta-information ... WARNING
  Non-standard license specification:
    What license is it under?
  Standardizable: FALSE

1 error x | 1 warning x | 0 notes ✓
```

We can see the package has `1 error` and `1 warning`. The error is being generated by our boilerplate `hello.R` and `hello.Rd` files (which we can remove):


```r
unlink("R/hello.R")
unlink("man/hello.Rd")
```

We can address the warning (`Non-standard license specification`) with the `usethis::use_mit_license()` function:


```r
usethis::use_mit_license()
✓ Setting License field in DESCRIPTION to 'MIT + file LICENSE'
✓ Writing 'LICENSE'
✓ Writing 'LICENSE.md'
✓ Adding '^LICENSE\\.md$' to '.Rbuildignore'
```

Now when we re-run `devtools::check()` it passes with flying colors!


```r
0 errors ✓ | 0 warnings ✓ | 0 notes ✓
```

## Data

We created a test dataset in the previous post to test the `separate_uk_cols()` function, which we will include in the package. The great thing about structuring your projects as a package is that everything has a home :) 

We can include the commands used to create the `j3s` data in the `data-raw/` folder using the `usethis::use_data_raw()` function:


```r
usethis::use_data_raw(name = "j3s")
✓ Creating 'data-raw/'
✓ Adding '^data-raw$' to '.Rbuildignore'
✓ Writing 'data-raw/j3s.R'
● Modify 'data-raw/j3s.R'
● Finish the data preparation script in 'data-raw/j3s.R'
● Use `usethis::use_data()` to add prepared data to package
```

We will add the code to `data-raw/j3s.R` (I've left the boilerplate portions in this file):


```r
## code to prepare `j3s` dataset goes here

j3s <- tibble::tribble(
        ~value,                       ~name,
           29L,                      "John",
           91L,               "John, Jacob",
           39L, "John, Jacob, Jingleheimer",
           28L,     "Jingleheimer, Schmidt",
           12L,              "JJJ, Schmidt")

usethis::use_data(j3s, overwrite = TRUE)
```

After saving and running this code, we can see that the `usethis::use_data(j3s, overwrite = TRUE)` function adds the `j3s.rda` to the `data/` folder only once.


```r
usethis::use_data(j3s, j3s)
Warning: Saving duplicates only once: 'j3s'
✓ Saving 'j3s' to 'data/j3s.rda'
● Document your data (see 'https://r-pkgs.org/data.html')
```

Lets take a look at the `diyrrr` package contents:

```bash
diyrrr/
    ├── DESCRIPTION
    ├── LICENSE
    ├── LICENSE.md
    ├── NAMESPACE
    ├── R
    │   └── separate_uk_cols.R
    ├── data
    │   └── j3s.rda
    ├── data-raw
    │   └── j3s.R
    ├── diyrrr.Rproj
    └── man
        └── separate_uk_cols.Rd
```

Let's build and install this package so see if it works!

## Build tools 

We need to configure our build tools a bit before building the `diyrrr` package. Navigate to the **Build** pane and click on *More* > *Configure Build Tools...*

<!-- <img src="images/diyrrr-pkg-04.jpg" alt="" width="80%" height="80%"/> -->

![](https://raw.githubusercontent.com/mjfrigaard/tidyverse-tips/master/content/posts/2021-04-08-creating-an-r-package/images/diyrrr-pkg-04.jpg)



Under *Project Options* click on *Generate documentation with Roxygen*, 

<!-- <img src="images/diyrrr-pkg-05.jpg" alt="" width="80%" height="80%"/> -->

![](https://raw.githubusercontent.com/mjfrigaard/tidyverse-tips/master/content/posts/2021-04-08-creating-an-r-package/images/diyrrr-pkg-05.jpg)



then click the following options: 

<!-- <img src="images/diyrrr-pkg-06.jpg" alt="" width="80%" height="80%"/> -->

![](https://raw.githubusercontent.com/mjfrigaard/tidyverse-tips/master/content/posts/2021-04-08-creating-an-r-package/images/diyrrr-pkg-06.jpg)



Click *Ok* and *Ok*, the click on *Install and Restart* in the **Build** pane. You should see the following: 

<!-- <img src="images/diyrrr-pkg-07.jpg" alt="" width="80%" height="80%"/> -->

![](https://raw.githubusercontent.com/mjfrigaard/tidyverse-tips/master/content/posts/2021-04-08-creating-an-r-package/images/diyrrr-pkg-07.jpg)

And the `diyrrr` package should be loaded in the **Console** pane. 

<!-- <img src="images/diyrrr-pkg-08.jpg" alt="" width="80%" height="80%"/> -->

![](https://raw.githubusercontent.com/mjfrigaard/tidyverse-tips/master/content/posts/2021-04-08-creating-an-r-package/images/diyrrr-pkg-08.jpg)

We can see the package has been loaded and the data and functions are available!

## Add, commmit and push to Git

Now that we have our package working, we will add and commit the files to Git (and push to Github if you're using it).

```bash
$ git add -A
$ git commit -m "script and data added"
[master 097fb93] script and data added
 12 files changed, 92 insertions(+), 32 deletions(-)
 create mode 100644 LICENSE
 create mode 100644 LICENSE.md
 delete mode 100644 R/hello.R
 create mode 100644 R/separate_uk_cols.R
 create mode 100644 data-raw/j3s.R
 create mode 100644 data/j3s.rda
 delete mode 100644 man/hello.Rd
 create mode 100644 man/separate_uk_cols.Rd
$ git remote add origin git@github.com:mjfrigaard/diyrrr.git
$ git branch -M main
$ git push -u origin main
Enumerating objects: 27, done.
Counting objects: 100% (27/27), done.
Delta compression using up to 4 threads
Compressing objects: 100% (18/18), done.
Writing objects: 100% (27/27), 4.15 KiB | 81.00 KiB/s, done.
Total 27 (delta 2), reused 0 (delta 0)
remote: Resolving deltas: 100% (2/2), done.
To github.com:mjfrigaard/diyrrr.git
 * [new branch]      main -> main
Branch 'main' set up to track remote branch 'main' from 'origin'.

```

Now `diyrrr` lives on [Github](https://github.com/mjfrigaard/diyrrr) :) 
