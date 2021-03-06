
<!-- README.md is generated from README.Rmd. Please edit that file -->

# autheliar

[![Travis build
status](https://travis-ci.org/liamgilbey/autheliar.svg?branch=master)](https://travis-ci.org/liamgilbey/autheliar)
[![Codecov test
coverage](https://codecov.io/gh/liamgilbey/autheliar/branch/master/graph/badge.svg)](https://codecov.io/gh/liamgilbey/autheliar?branch=master)

The goal of autheliar is to provide an R interface to the Authelia API,
allowing a low-overhead way to bring authentication into R applications.

## Installation

For now this package is only available from GitHub.

``` r
# install.packages("devtools")
devtools::install_github("liamgilbey/autheliar")
```

## Usage

The central object to `autheliar` is the R6 class `authelia`. As with
all R6 classes, a new `ldap` object is created with the `new` method:

``` r
auth <- autheliar::authelia$new("https://authelia.example.com")
```

Logging into the server can be achieved using first-factor
authentication:

``` r
auth$firstfactor(
  username = "John",
  password = "secretpassword"
)
```
