#' Create URL that fits the OECD's API
#'
#' @keywords internal
#' @noRd

oecd_url <- function(country, indicator, start, end) {
    if ('all' %in% country) {
        country_list <- paste0('AUS+AUT+BEL+CAN+CHL+CZE+DNK+EST+FIN+FRA+DEU+GRC',
                            '+HUN+ISL+IRL+ISR+ITA+JPN+KOR+LUX+MEX+NLD+NZL+NOR+',
                            'POL+PRT+SVK+SVN+ESP+SWE+CHE+TUR+GBR+USA+NMEC+COL+',
                            'LVA+RUS')
    } else country_list <- addp(country)

    url_out <- sprintf('http://stats.oecd.org/restsdmx/sdmx.ashx/GetData/%s/%s.SAFGD.S1311C.PCTGDPA.NSA/all?startTime=%s&endTime=%s',
            indicator, country_list, as.character(start), as.character(end))
    return(url_out)
}

#' @keywords internal
#' @noRd

addp <- function(countries) {
    country_out <- paste(countries, collapse = '+')
    return(country_out)
}
