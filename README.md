# oecdr

Version: 0.1.0

Download and extract data from the [OECD](https://stats.oecd.org) into R.

## Install

```{S}
devtools::install_github('christophergandrud/oecdr')
```

## Example

```{S}
qrt_public_debt <- oecd()

head(qrt_public_debt)

  iso3c    time        i
1   AUS 2000-Q1 30.40947
2   AUS 2000-Q2 30.06433
3   AUS 2000-Q3 28.93960
4   AUS 2000-Q4 29.99138
5   AUS 2001-Q1 29.21112
6   AUS 2001-Q2 29.75726
```
