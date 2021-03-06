#' Authelia verification
#'
#' This function passes a request to the authelia API to test whether the
#' requester is authenticated and verified to access a particular domain
#' @param self R6 self reference
#' @param private R6 private object
#' @param domain The URL of the domain we are verifying against
#'
#' @keywords internal
authelia_verify <- function(
  self,
  private,
  domain
){
  # send the verification request
  r <- httr::GET(
    paste0(private$api, "/verify"),
    httr::add_headers(
      `accept` = "*/*",
      `X-Original-URL` = domain
    )
  )
  # if successful, the body is empty
  if(length(r$content) == 0){
    headers <- r$headers
    private$domains[[domain]] <- headers
  } else{
    # else, decode the body
    private$domains[[domain]] <- tryCatch({
      jsonlite::fromJSON(
        rawToChar(r$content)
      )
    },
    error = function(e){
      rawToChar(r$content)
    })
  }

  self
}
