
#' IEX Depth of Book
#'
#' DEEP is used to receive real-time depth of book quotations direct from IEX.
#' The depth of book quotations received via DEEP provide an aggregated size
#'  of resting displayed orders at a price and side, and do not indicate the
#'  size or number of individual orders at any price level. Non-displayed orders
#'  and non-displayed portions of reserve orders are not represented in DEEP.
#'
#' DEEP also provides last trade price and size information.
#' Trades resulting from either displayed or non-displayed orders matching on IEX will be reported.
#' Routed executions will not be reported.
#'
#' Data Weighting: FREE
#'
#' Data Timing: REAL TIME
#'
#' Data Schedule: Market hours 9:30am-4pm ET
#'
#'Data Source(s): Consolidated Tape Investors Exchange
#'
#' @family deep service functions
#' @param symbol a market symbol, one and only one symbol
#' @export
#' @examples
#' deep('AAPL')
 deep <- function(symbol) {
  endpoint <- glue::glue('/deep?symbols={symbol}');
  res = iex_api(endpoint);
  if (res$status) {
    return (tibble::as_tibble(list()))
  }
  tibble::as_tibble(do.call(rbind,res$content)) %>%
    tidyr::unnest_legacy();
}

  #' IEX Depth of Book
  #'
  #' DEEP is used to receive real-time depth of book quotations direct from IEX.
  #' The depth of book quotations received via DEEP provide an aggregated size
  #'  of resting displayed orders at a price and side, and do not indicate the
  #'  size or number of individual orders at any price level. Non-displayed orders
  #'  and non-displayed portions of reserve orders are not represented in DEEP.
  #'
  #' DEEP also provides last trade price and size information.
  #' Trades resulting from either displayed or non-displayed orders matching on IEX will be reported.
  #' Routed executions will not be reported.
  #'
  #' Data Weighting: FREE
  #'
  #' Data Timing: REAL TIME
  #'
  #' Data Schedule: Market hours 9:30am-4pm ET
  #'
  #'Data Source(s): Consolidated Tape Investors Exchange
  #'
  #' @family deep service functions
  #' @param symbol a market symbol, one and only one symbol
  #' @export
  #' @examples
  #' deepAuction('AAPL')\
  deepAuction <- function(symbol) {
  endpoint <- glue::glue('/deep/auction?symbols={symbol}');
  res = iex_api(endpoint);
  if (res$status) {
    return (tibble::as_tibble(list()))
  }
  tibble::as_tibble(do.call(rbind,res$content)) %>%
    tidyr::unnest_legacy();
  }

  #' The Official Price message is used to disseminate the IEX Official Opening and Closing Prices.
  #'
  #'These messages will be provided only for IEX Listed Securities.
  #'
  #' Data Weighting: FREE
  #'
  #'Data Source(s): Investors Exchange
  #'
  #' @family deep service functions
  #' @param symbol a market symbol, one and only one symbol
  #' @export
  #' @examples
  #' deepOfficialPrice('AAPL')\
  deepOfficialPrice <- function(symbol) {
    endpoint <- glue::glue('/deep/official-price?symbols={symbol}');
    res <- iex_api(endpoint);
    if (res$status) {
      return (tibble::as_tibble(list()))
    }
    data <- res$content[symbol];
    tibble::as_tibble(do.call(rbind,data)) %>%
      tidyr::unnest_legacy();
  }

  #' Trade report messages are sent when an order on the IEX Order Book
  #' is executed in whole or in part. DEEP sends a Trade report message
  #' for every individual fill.
  #'
  #' Data Weighting: FREE
  #'
  #' Data Source(s): Investors Exchange
  #'
  #' @family deep service functions
  #' @param symbol a market symbol, one and only one symbol
  #' @export
  #' @examples
  #' deepTrades('AAPL')\
  deepTrades <- function(symbol) {
    endpoint <- glue::glue('/deep/trades?symbols={symbol}');
    res <- iex_api(endpoint);
    if (res$status) {
      return (tibble::as_tibble(list()))
    }
    data <- res$content[[symbol]];
    tibble::as_tibble(do.call(rbind,data)) %>%
      tidyr::unnest_legacy() %>%
      dplyr::mutate(datetime = lubridate::with_tz(lubridate::as_datetime(timestamp/1000),"America/New_York")) %>%
      dplyr::mutate(minute = lubridate::hour(datetime)*60+lubridate::minute(datetime)-570) %>%
      dplyr::arrange(desc(tradeId));
  }
