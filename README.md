# oecdr

Version: 0.1.0

Download and extract data from the [OECD](https://stats.oecd.org) into R.

## Install

```{S}
devtools::install_github('christophergandrud/oecdr')
```

## Use

```{S}
qrt_public_debt <- oecdr::oecd(indicator = c('SAF2LXT.S1311C.PCTGDPA.NSA',
                        'SAFGD.S1311C.CAR.NSA'))

head(qrt_public_debt)

  iso3c    time SAF2LXT.S1311C.PCTGDPA.NSA SAFGD.S1311C.CAR.NSA
1   AUS 2000-Q1                          0             197175.0
2   AUS 2000-Q2                          0             198660.5
3   AUS 2000-Q3                          0             195187.8
4   AUS 2000-Q4                          0             205515.9
5   AUS 2001-Q1                          0             203152.5
6   AUS 2001-Q2                          0             209870.5
```
