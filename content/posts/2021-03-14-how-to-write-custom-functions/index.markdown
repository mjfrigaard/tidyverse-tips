---
title: How to write custom functions
author: Martin Frigaard
date: '2021-03-14'
slug: []
categories:
  - programming
tags: []
---
<link href="{{< blogdown/postref >}}index_files/pagedtable/css/pagedtable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/pagedtable/js/pagedtable.js"></script>
<link href="{{< blogdown/postref >}}index_files/pagedtable/css/pagedtable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/pagedtable/js/pagedtable.js"></script>
<link href="{{< blogdown/postref >}}index_files/pagedtable/css/pagedtable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/pagedtable/js/pagedtable.js"></script>
<link href="{{< blogdown/postref >}}index_files/pagedtable/css/pagedtable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/pagedtable/js/pagedtable.js"></script>
<link href="{{< blogdown/postref >}}index_files/pagedtable/css/pagedtable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/pagedtable/js/pagedtable.js"></script>
<link href="{{< blogdown/postref >}}index_files/pagedtable/css/pagedtable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/pagedtable/js/pagedtable.js"></script>
<link href="{{< blogdown/postref >}}index_files/pagedtable/css/pagedtable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/pagedtable/js/pagedtable.js"></script>
<link href="{{< blogdown/postref >}}index_files/pagedtable/css/pagedtable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/pagedtable/js/pagedtable.js"></script>
<link href="{{< blogdown/postref >}}index_files/pagedtable/css/pagedtable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/pagedtable/js/pagedtable.js"></script>
<link href="{{< blogdown/postref >}}index_files/pagedtable/css/pagedtable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/pagedtable/js/pagedtable.js"></script>
<link href="{{< blogdown/postref >}}index_files/pagedtable/css/pagedtable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/pagedtable/js/pagedtable.js"></script>
<link href="{{< blogdown/postref >}}index_files/pagedtable/css/pagedtable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/pagedtable/js/pagedtable.js"></script>




This post comes from a [Stackoverflow question](https://stackoverflow.com/questions/4350440/split-data-frame-string-column-into-multiple-columns) that I've revisited numerous times over the years. 

The original question:

> **Stackoverflow: Split data frame string column into multiple columns**

> *I'd like to take data of the form*


```r
before = data.frame(attr = c(1, 30, 4, 6), 
                    type = c('foo_and_bar', 
                             'foo_and_bar_2'))
                              
  attr          type
1    1   foo_and_bar
2   30 foo_and_bar_2
3    4   foo_and_bar
4    6 foo_and_bar_2
```

> *and use `split()` on the column "`type`" from above to get something like this:*


```r
  attr type_1 type_2
1    1    foo    bar
2   30    foo  bar_2
3    4    foo    bar
4    6    foo  bar_2
```

#### Load packages

Let's load the `tidyverse` and get started!


```r
library(tidyverse)
```

```
## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.0 ──
```

```
## ✓ ggplot2 3.3.3     ✓ purrr   0.3.4
## ✓ tibble  3.1.0     ✓ dplyr   1.0.5
## ✓ tidyr   1.1.3     ✓ stringr 1.4.0
## ✓ readr   1.4.0     ✓ forcats 0.5.1
```

```
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```

#### Create some messy data

Below is an example `tibble` with a jumbled `name` column (`JJJSBefore`) similar to the one above. I chose to use commas and spaces instead of underscores because I find them a little easier to read. 


```r
JJJSBefore <- tibble::tribble(
     ~value,                       ~name,
        29L,                      "John",
        91L,               "John, Jacob",
        39L, "John, Jacob, Jingleheimer",
        28L,     "Jingleheimer, Schmidt",
        12L,              "JJJ, Schmidt")
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["value"],"name":[1],"type":["int"],"align":["right"]},{"label":["name"],"name":[2],"type":["chr"],"align":["left"]}],"data":[{"1":"29","2":"John"},{"1":"91","2":"John, Jacob"},{"1":"39","2":"John, Jacob, Jingleheimer"},{"1":"28","2":"Jingleheimer, Schmidt"},{"1":"12","2":"JJJ, Schmidt"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

<br></br>

***

### A 'not quite' solution

One possible solution is to combine `dplyr::mutate()`, `stringr::str_split()`, and `tidyr::unnest()`.  


```r
JJJSBefore %>%
        dplyr::mutate(name = 
    # 1) split this on the ", " pattern
             stringr::str_split(string = name, 
                                pattern = ", ")) %>% 
    # 2) convert output from str_split across rows
        tidyr::unnest(name) 
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["value"],"name":[1],"type":["int"],"align":["right"]},{"label":["name"],"name":[2],"type":["chr"],"align":["left"]}],"data":[{"1":"29","2":"John"},{"1":"91","2":"John"},{"1":"91","2":"Jacob"},{"1":"39","2":"John"},{"1":"39","2":"Jacob"},{"1":"39","2":"Jingleheimer"},{"1":"28","2":"Jingleheimer"},{"1":"28","2":"Schmidt"},{"1":"12","2":"JJJ"},{"1":"12","2":"Schmidt"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

This gets the data into a tidy format, but it would require some additional wrangling steps to get the data back into the two columns the question was looking for. 

Fortunately, this particular question was posed 9 years and 6 months ago at the time of this writing, so there are quite a few solutions listed. I liked the approach [Yannis-P](https://stackoverflow.com/users/1885713/yannis-p) took because 1) it offers a `tidyverse` solution *and* 2) it's written as a function. 

I've copied Yannis-P's comment on the proposed solution below:

> *We can't use `dplyr` `separate()` because we don't know the number of the result columns before the split, so I have then created a function that uses `stringr` to split a column, given the pattern and a name prefix for the generated columns.*

<br></br>

### Original `split_into_multiple()`

Here is the function:


```r
split_into_multiple <- function(column, pattern = ", ", into_prefix){
  cols <- str_split_fixed(column, pattern, n = Inf)
  # Sub out the ""'s returned by filling the matrix 
  # to the right, with NAs which are useful
  cols[which(cols == "")] <- NA
  
  cols <- as.tibble(cols)
  # name the 'cols' tibble as 'into_prefix_1', 
  # 'into_prefix_2', ..., 'into_prefix_m' 
  # where m = # columns of 'cols'
  m <- dim(cols)[2]
  
  names(cols) <- paste(into_prefix, 1:m, sep = "_")
  
  return(cols)
}
```



### How it works

Let's break down the `split_into_multiple()` function's components: 

The first step takes an input column and applies the `stringr::str_split_fixed()` function, which returns ["a character matrix with `n` columns."](https://stringr.tidyverse.org/reference/str_split.html) 


```r
cols <- stringr::str_split_fixed(column, pattern, n = Inf)
```

By setting `n` to `Inf`, the number of items to split the `string` into is infinite. 


```r
cols <- stringr::str_split_fixed(string = JJJSBefore$name, 
                                 pattern = ", ", 
                                 n = Inf)
cols
```

```
##      [,1]           [,2]      [,3]          
## [1,] "John"         ""        ""            
## [2,] "John"         "Jacob"   ""            
## [3,] "John"         "Jacob"   "Jingleheimer"
## [4,] "Jingleheimer" "Schmidt" ""            
## [5,] "JJJ"          "Schmidt" ""
```

After the `name` column is split into a character matrix of split columns (`cols`), the `split_into_multiple()` function uses [`base::which()`](https://stat.ethz.ch/R-manual/R-devel/library/base/html/which.html) to identify the empty columns in the matrix.


```r
base::which(cols == "")
```

```
## [1]  6 11 12 14 15
```

`base::which()` returns a numerical vector that correspond to the empty columns in the `cols` matrix.

![](https://raw.githubusercontent.com/mjfrigaard/tidyverse-tips/master/public/posts/2021-03-14-how-to-write-a-custom-wrangling-function/images/matrix-indeces.png){width=80%}

<!-- ![](~/Dropbox/@projects/02-low-priority/@blogs/tidyverse-dot-tips/tidyverse-tips/public/posts/2021-03-14-how-to-write-a-custom-wrangling-function/images/matrix-indeces.png){width=80%} -->

The `split_into_multiple()` function subsets the `cols` matrix with the output from `base::which(cols == "")` and assigns `NA`s to the locations identified above. 


```r
cols[base::which(cols == "")] <- NA
cols
```

```
##      [,1]           [,2]      [,3]          
## [1,] "John"         NA        NA            
## [2,] "John"         "Jacob"   NA            
## [3,] "John"         "Jacob"   "Jingleheimer"
## [4,] "Jingleheimer" "Schmidt" NA            
## [5,] "JJJ"          "Schmidt" NA
```

Next, we need a `tibble`, not a matrix, so `split_into_multiple()` converts `cols` into a tibble with `cols <- as.tibble(cols)`. 


```r
cols <- tibble::as.tibble(cols)
cols
```

### `as.tibble()` warning

`as.tibble()` throws the following warning, 

```
1: `as.tibble()` is deprecated as of tibble 2.0.0.
Please use `as_tibble()` instead.
The signature and semantics have changed, see `?as_tibble`.
This warning is displayed once every 8 hours.
```

I'll replace it with [`as_tibble()` from `tibble`](https://tibble.tidyverse.org/reference/as_tibble.html).


```r
cols <- tibble::as_tibble(cols, .name_repair = "universal")
cols
```

### `as_tibble()` warning

Now `tibble::as_tibble()` is throwing this warning, 

```
2: The `x` argument of `as_tibble.matrix()` must have column 
names if  `.name_repair` is omitted as of tibble 2.0.0.  
Using compatibility `.name_repair`.  
This warning is displayed once every 8 hours.
```

If I supply the `.name_repair = "universal"` argument, I get the following column names:


```
## New names:
## * `` -> ...1
## * `` -> ...2
## * `` -> ...3
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["...1"],"name":[1],"type":["chr"],"align":["left"]},{"label":["...2"],"name":[2],"type":["chr"],"align":["left"]},{"label":["...3"],"name":[3],"type":["chr"],"align":["left"]}],"data":[{"1":"John","2":"NA","3":"NA"},{"1":"John","2":"Jacob","3":"NA"},{"1":"John","2":"Jacob","3":"Jingleheimer"},{"1":"Jingleheimer","2":"Schmidt","3":"NA"},{"1":"JJJ","2":"Schmidt","3":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

<br></br>

This will likely be an issue down the road, so I'll address it when I make some adjustments to the `split_into_multiple()` function.

Now we have a `tibble`, but we're missing the original `value` column from `JJJSBefore` (see below). 

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["value"],"name":[1],"type":["int"],"align":["right"]},{"label":["name"],"name":[2],"type":["chr"],"align":["left"]}],"data":[{"1":"29","2":"John"},{"1":"91","2":"John, Jacob"},{"1":"39","2":"John, Jacob, Jingleheimer"},{"1":"28","2":"Jingleheimer, Schmidt"},{"1":"12","2":"JJJ, Schmidt"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

<br></br>

`split_into_multiple()` then takes the second value from the  [`base::dim()`](https://stat.ethz.ch/R-manual/R-devel/library/base/html/dim.html) function (which is short for `dim`ensions). 

The second number from `base::dim()` is the number of columns in the `cols` tibble, 


```r
m <- base::dim(cols)[2]
m
```

```
## [1] 3
```

I can also get this with [`base::ncols()`](https://stat.ethz.ch/R-manual/R-devel/library/base/html/nrow.html)


```r
base::ncol(cols)
```

```
## [1] 3
```

Finally, `split_into_columns()` uses `base::paste()` to combine `m` with `into_prefix` to create the new column `base::names()` (separated by an underscore `"_"`). 

The `return()` value is `cols` with the new names. 


```r
into_prefix <- "name"
base::paste(into_prefix, 1:m, sep = "_")
```

```
## [1] "name_1" "name_2" "name_3"
```

Put all together, the function works like so,


```r
split_into_multiple(column = JJJSBefore$name, 
                    pattern = ", ", 
                    into_prefix = "name") -> JJJAfter
JJJAfter
```


```
## Warning: `as.tibble()` was deprecated in tibble 2.0.0.
## Please use `as_tibble()` instead.
## The signature and semantics have changed, see `?as_tibble`.
```

```
## Warning: The `x` argument of `as_tibble.matrix()` must have unique column names if `.name_repair` is omitted as of tibble 2.0.0.
## Using compatibility `.name_repair`.
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["name_1"],"name":[1],"type":["chr"],"align":["left"]},{"label":["name_2"],"name":[2],"type":["chr"],"align":["left"]},{"label":["name_3"],"name":[3],"type":["chr"],"align":["left"]}],"data":[{"1":"John","2":"NA","3":"NA"},{"1":"John","2":"Jacob","3":"NA"},{"1":"John","2":"Jacob","3":"Jingleheimer"},{"1":"Jingleheimer","2":"Schmidt","3":"NA"},{"1":"JJJ","2":"Schmidt","3":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

<br></br>

***

### Address `tibble` warnings 

The `as_tibble()`/`as.tibble()` warnings can be addressed by assigning column names with `base::colnames()` to the matrix ***before*** converting this into a tibble. 


```r
# create cols matrix
cols <- str_split_fixed(JJJSBefore$name, 
                        pattern = ", ", 
                        n = Inf)
# replace "" with NAs
cols[which(cols == "")] <- NA
# get cols
m <- dim(cols)[2]
# assign names
into_prefix <- "name"
colnames(cols) <- paste(into_prefix, 1:m, sep = "_")
# create tibble
cols <- as_tibble(cols)
cols
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["name_1"],"name":[1],"type":["chr"],"align":["left"]},{"label":["name_2"],"name":[2],"type":["chr"],"align":["left"]},{"label":["name_3"],"name":[3],"type":["chr"],"align":["left"]}],"data":[{"1":"John","2":"NA","3":"NA"},{"1":"John","2":"Jacob","3":"NA"},{"1":"John","2":"Jacob","3":"Jingleheimer"},{"1":"Jingleheimer","2":"Schmidt","3":"NA"},{"1":"JJJ","2":"Schmidt","3":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

<br></br>

### Add arguments 

I'll also add a few arguments: 

- an argument for data (`data = `),  
- a default pattern argument (`pattern = [^[:alnum:]]+`),  
- `dplyr::bind_cols()` to combine the new output columns with the original input `data.frame`/`tibble`, and  
- I changed the names of the inputs to have an `in_` prefix, and the outputs to have an `out_` prefix 

<br></br>

## New `split_into_multiple()` 

My adjusted `split_into_multiple()` function is below. 


```r
split_into_multiple <- function(data, col, pattern = "[^[:alnum:]]+", into_prefix){
  # use regex for pattern, or whatever is provided 
  in_pattern <- pattern
  # convert data to tibble 
  in_data <- tibble::as_tibble(data)
  # convert col to character vector
  in_col <- base::as.character(col)
  # split columns into character matrix
  out_cols <- stringr::str_split_fixed(in_data[[in_col]], 
                                       pattern = in_pattern, 
                                       n = Inf)
  # replace NAs in matrix
  out_cols[base::which(out_cols == "")] <- NA
  # get number of cols
  m <- base::dim(out_cols)[2]
  # assign column names
  base::colnames(out_cols) <- base::paste(into_prefix, 1:m, sep = "_")
  # convert to tibble
  out_cols <- tibble::as_tibble(out_cols)
  # bind cols together
  out_tibble <- dplyr::bind_cols(in_data, out_cols)
  # return the out_tibble
  return(out_tibble)
}
```

<br></br>

Now I'll test `split_into_multiple()` with `JJJSBefore` and see what I get:


```r
JJJSBefore %>% 
  split_into_multiple(data = ., 
                      col = "name", 
                      into_prefix = "name") -> JJJAfter
JJJAfter
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["value"],"name":[1],"type":["int"],"align":["right"]},{"label":["name"],"name":[2],"type":["chr"],"align":["left"]},{"label":["name_1"],"name":[3],"type":["chr"],"align":["left"]},{"label":["name_2"],"name":[4],"type":["chr"],"align":["left"]},{"label":["name_3"],"name":[5],"type":["chr"],"align":["left"]}],"data":[{"1":"29","2":"John","3":"John","4":"NA","5":"NA"},{"1":"91","2":"John, Jacob","3":"John","4":"Jacob","5":"NA"},{"1":"39","2":"John, Jacob, Jingleheimer","3":"John","4":"Jacob","5":"Jingleheimer"},{"1":"28","2":"Jingleheimer, Schmidt","3":"Jingleheimer","4":"Schmidt","5":"NA"},{"1":"12","2":"JJJ, Schmidt","3":"JJJ","4":"Schmidt","5":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

**GREAT!** It works! But I should test `split_into_multiple()` on a few more examples.

<br></br>

I'll test to see if `split_into_multiple()` works on the `Before` data in the original example,  



<br></br>


```r
Before
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["attr"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["type"],"name":[2],"type":["chr"],"align":["left"]}],"data":[{"1":"1","2":"foo_and_bar"},{"1":"30","2":"foo_and_bar_2"},{"1":"4","2":"foo_and_bar_2_and_bar_3"},{"1":"6","2":"foo_and_bar"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

<br></br>


```r
Before %>% 
  split_into_multiple(data = ., 
                      col = "type", 
                      pattern = "_and_", 
                      into_prefix = "type")
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["attr"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["type"],"name":[2],"type":["chr"],"align":["left"]},{"label":["type_1"],"name":[3],"type":["chr"],"align":["left"]},{"label":["type_2"],"name":[4],"type":["chr"],"align":["left"]},{"label":["type_3"],"name":[5],"type":["chr"],"align":["left"]}],"data":[{"1":"1","2":"foo_and_bar","3":"foo","4":"bar","5":"NA"},{"1":"30","2":"foo_and_bar_2","3":"foo","4":"bar_2","5":"NA"},{"1":"4","2":"foo_and_bar_2_and_bar_3","3":"foo","4":"bar_2","5":"bar_3"},{"1":"6","2":"foo_and_bar","3":"foo","4":"bar","5":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

So far, so good!

<br></br>


What if there is a `data.frame`/`tibble` with a bunch of different characters we need to split on? I can test these data in the `WorseThanBefore` data below. 


```r
WorseThanBefore <- tibble::tribble(
     ~attr,                     ~type,
        1L,                "foo, bar",
       30L,               "foo-bar/2",
        4L, "foo...bar...2...bar...3",
        6L,               "foo | bar")
WorseThanBefore
```

<br></br>

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["attr"],"name":[1],"type":["int"],"align":["right"]},{"label":["type"],"name":[2],"type":["chr"],"align":["left"]}],"data":[{"1":"1","2":"foo, bar"},{"1":"30","2":"foo-bar/2"},{"1":"4","2":"foo...bar...2...bar...3"},{"1":"6","2":"foo | bar"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

<br></br>

We'll use `split_into_multiple()` on `WorseThanBefore`, but omit the argument for `pattern`.


```r
WorseThanBefore %>% 
    split_into_multiple(data = ., 
                      col = "type", 
                      into_prefix = "type")
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["attr"],"name":[1],"type":["int"],"align":["right"]},{"label":["type"],"name":[2],"type":["chr"],"align":["left"]},{"label":["type_1"],"name":[3],"type":["chr"],"align":["left"]},{"label":["type_2"],"name":[4],"type":["chr"],"align":["left"]},{"label":["type_3"],"name":[5],"type":["chr"],"align":["left"]},{"label":["type_4"],"name":[6],"type":["chr"],"align":["left"]},{"label":["type_5"],"name":[7],"type":["chr"],"align":["left"]}],"data":[{"1":"1","2":"foo, bar","3":"foo","4":"bar","5":"NA","6":"NA","7":"NA"},{"1":"30","2":"foo-bar/2","3":"foo","4":"bar","5":"2","6":"NA","7":"NA"},{"1":"4","2":"foo...bar...2...bar...3","3":"foo","4":"bar","5":"2","6":"bar","7":"3"},{"1":"6","2":"foo | bar","3":"foo","4":"bar","5":"NA","6":"NA","7":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

<br></br>

`split_into_multiple()` removed any sequence of non-alphanumeric values, but it still retains the original column, which I can remove using `dplyr::select()` helpers (like above).


```r
JJJSBefore %>% 
  split_into_multiple(data = ., 
                      col = "name", 
                      into_prefix = "name") %>% 
  dplyr::select(value, dplyr::contains("name_"))
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["value"],"name":[1],"type":["int"],"align":["right"]},{"label":["name_1"],"name":[2],"type":["chr"],"align":["left"]},{"label":["name_2"],"name":[3],"type":["chr"],"align":["left"]},{"label":["name_3"],"name":[4],"type":["chr"],"align":["left"]}],"data":[{"1":"29","2":"John","3":"NA","4":"NA"},{"1":"91","2":"John","3":"Jacob","4":"NA"},{"1":"39","2":"John","3":"Jacob","4":"Jingleheimer"},{"1":"28","2":"Jingleheimer","3":"Schmidt","4":"NA"},{"1":"12","2":"JJJ","3":"Schmidt","4":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

<br></br>

### In closing

This `split_into_multiple()` function has been really helpful for me in the last few projects I've been working on. I hope you can use it too!


#### Noteworthy non-`tidyverse` alternatives

I also liked the `cSplit()` function from the [`splitstackshape` package](https://github.com/mrdwab/splitstackshape) because it can take multiple columns and can be tidied up all in one go!


```r
library(splitstackshape)
# original
JJJSBefore
```

```
## # A tibble: 5 x 2
##   value name                     
##   <int> <chr>                    
## 1    29 John                     
## 2    91 John, Jacob              
## 3    39 John, Jacob, Jingleheimer
## 4    28 Jingleheimer, Schmidt    
## 5    12 JJJ, Schmidt
```


```r
# wide
JJJSBefore %>% 
  splitstackshape::cSplit(indt = ., 
                          splitCols = "name", 
                          sep = ", ", 
                          drop = FALSE, 
                          direction = "wide") 
```

```
##    value                      name       name_1  name_2       name_3
## 1:    29                      John         John    <NA>         <NA>
## 2:    91               John, Jacob         John   Jacob         <NA>
## 3:    39 John, Jacob, Jingleheimer         John   Jacob Jingleheimer
## 4:    28     Jingleheimer, Schmidt Jingleheimer Schmidt         <NA>
## 5:    12              JJJ, Schmidt          JJJ Schmidt         <NA>
```


```r
# long
JJJSBefore %>% 
  splitstackshape::cSplit(indt = ., 
                          splitCols = "name", 
                          sep = ", ", 
                          direction = "long") 
```

```
##     value         name
##  1:    29         John
##  2:    91         John
##  3:    91        Jacob
##  4:    39         John
##  5:    39        Jacob
##  6:    39 Jingleheimer
##  7:    28 Jingleheimer
##  8:    28      Schmidt
##  9:    12          JJJ
## 10:    12      Schmidt
```



Huge thanks to [Hadley](https://stackoverflow.com/users/16632/hadley) and [Yannis P.](https://stackoverflow.com/users/1885713/yannis-p) and everyone else on Stackoverflow!


```r
tidyverse_logo()
```

```
## ⬢ __  _    __   .    ⬡           ⬢  . 
##  / /_(_)__/ /_ ___  _____ _______ ___ 
## / __/ / _  / // / |/ / -_) __(_-</ -_)
## \__/_/\_,_/\_, /|___/\__/_/ /___/\__/ 
##      ⬢  . /___/      ⬡      .       ⬢
```



