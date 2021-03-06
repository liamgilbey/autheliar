#' Initalize an authelia object
#'
#' This is an internal function used to initialize a new authelia object
#' @param self R6 self reference
#' @param private R6 private object
#' @param url The URL of your authelia instance
#'
#' @keywords internal
authelia_init <- function(
  self,
  private,
  url
){
  # check the API is reachable
  url_check <- httr::GET(url)
  if(!url_check$status_code == 200){
    stop(paste0("The authelia instance does not appear reachable at ", url), call. = F)
  }
  # set the basic private elements
  private$url <- url
  private$api <- paste0(url, "/api")

  # now grab the server configuration
  config <- httr::GET(
    paste0(url,"/api/configuration")
  )
  private$server_config <- httr::content(config)

  # return self
  self
}
