#' Download OECD data
#'
#' Downloads requested data from the OECD's API, parses the download, and
#' returns the data in country-time format
#'
#' @param country character vector of country names in ISO 3 country code
#' format. The default (\code{'all'}) downloads data for all available
#' countries.
#' @param table character string identifying the table. Note only one table
#' can be queried at a time.
#' @param indicator character vector of indicator codes for variables in
#' \code{table}.
#' @param start first year or quarter to download data for.
#' @param end final year or quarter to download data for.
#' @param extra logical. If \code{TRUE} then all information from the download
#' is returned.
#'
#' @return a data frame with (if \code{extra = TRUE}) country ISO 3 Letter
#' codes, the time variable and the requested indicators.
#'
#' @examples
#' \dontrun{
#' # Download: Central Governement Currency and Deposits (% GDP) and
#' #           Total Gross Central Government Debt in current prices
#' qrt_public_debt <- oecd(indicator = c('SAF2LXT.S1311C.PCTGDPA.NSA',
#'                      'SAFGD.S1311C.CAR.NSA'))
#' }
#'
#' @importFrom rsdmx readSDMX
#' @importFrom dplyr %>% rename rename_
#' @importFrom curl curl_fetch_memory
#'
#' @export

oecd <- function(country = 'all', table = 'QASA_TABLE7PSD',
                 indicator = 'SAFGD.S1311C.CAR.NSA',
                 start = '2000-Q1', end = '2011-Q4',
                 extra = FALSE) {
    LOCATION <- obsTime <- obsValue <- iso3c <- NULL

    if (length(table) > 1) stop('Can only download data from one table at a time', call. = T)

    full_list <- list()

    for (i in indicator) {
        message(sprintf('Attempting to download: %s . . .', i))
        URL <- oecd_url(country = country, table = table, indicator = i,
                        start = start, end = end)

        temp_file <- tempfile()
        on.exit(unlink(temp_file))
        u <- curl_fetch_memory(URL)

        if (u$status_code == 500)
            stop(sprintf('Unable to download requested data for: %s.', i),
                 call. = F)

        writeBin(object = u$content, con = temp_file)

        temp <- readSDMX(temp_file, isURL = F) %>%
                    as.data.frame(stringsAsFactors = F)
        message('                                         download successful.')

        temp <- temp %>%
                    dplyr::rename(iso3c = LOCATION) %>%
                    dplyr::rename(time = obsTime)
        names(temp)[names(temp) == "obsValue"] <- i

        if (!isTRUE(extra)) temp <- temp[, c('iso3c', 'time', i)]

        full_list[[i]] <- temp
    }

    out_df <- Reduce(function(x, y) merge(x, y, by = c('iso3c', 'time'),
                                          all = TRUE),
                     full_list)

    return(out_df)
}
