#' Authelia authentication
#'
#' This function passes a request to the authelia API to perform first-factor
#' authentication.
#' @param self R6 self reference
#' @param private R6 private object
#' @param username The username to authenticate against
#' @param password The password to authenticate with
#' @param domain The domain to authenticate against. If left NULL, no redirect
#' header will be supplied
#' @param keepMeLoggedIn A boolean flag on whether to keep the user logged in.
#' This utilises the server's configuration for the duration of authentication
#'
#' @keywords internal
authelia_firstfactor <- function(
  self,
  private,
  username,
  password,
  domain = NULL,
  keepMeLoggedIn = TRUE
){
  r <- httr::POST(
    paste0(private$api, "/firstfactor"),
    httr::accept_json(),
    httr::content_type_json(),
    body = list(
      username = username,
      password = password,
      targetURL = domain,
      keepMeLoggedIn = keepMeLoggedIn
    ),
    encode = "json"
  )
  jsonlite::fromJSON(
    rawToChar(r$content)
  )
}
