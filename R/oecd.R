#' Download OECD data
#'
#' Downloads requested data from the OECD's API, parses the download, and
#' returns the data in country-time format
#'
#' @param country character vector of country names in ISO 3 country code
#' format. The default (\code{'all'}) downloads data for all available
#' countries.
#' @param indicator character vector of indicator codes.
#' @param start first year or quarter to download data for.
#' @param end final year or quarter to download data for.
#' @param extra logical. If \code{TRUE} then all information from the download
#' is returned.
#'
#' @return a data frame
#'
#' @examples
#' \dontrun{
#' qrt_public_debt <- oecd()
#' }
#'
#' @importFrom rsdmx readSDMX
#' @importFrom dplyr %>% rename
#' @importFrom curl curl_fetch_memory
#'
#' @export

oecd <- function(country = 'all', indicator = 'QASA_TABLE7PSD',
                 start = '2000-Q1', end = '2011-Q4',
                 extra = FALSE) {
    LOCATION <- obsTime <- obsValue <- iso3c <- NULL

    for (i in indicator) {
        message(sprintf('Attempting to download: %s . . .', i))
        URL <- oecd_url(country = country, indicator = i, start = start,
                        end = end)

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
                    dplyr::rename(time = obsTime) %>%
                    dplyr::rename(i = obsValue)
        if (!isTRUE(extra)) temp <- temp %>% dplyr::select(iso3c, time, i)
    }
    return(temp)
}
