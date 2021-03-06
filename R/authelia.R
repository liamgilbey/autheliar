#' autheliar
#'
#' Authelia is an open source authentication server. It is able to provide single
#' sign-on to your applications. autheliar is designed to interface directly
#' with the Authelia API to bring such capability to R, particularly to shiny applications.
#'
#' @section Connecting to an Authelia server:
#' An authelia object is an R6 class, that can be created with \code{authelia$new()}.
#' It has the following arguments:
#' \describe{
#'   \item{url}{The Authelia instance we want to authenticate against. This must
#'   already be setup and working as appropriate for your use case. This should be
#'   a fully qualified domain name such as `https://authelia.example.com`}
#' }
#'
#' @section General use of autheliar:
#' Besides performing authentication, there is a set of functions that provide back
#' information on the Authelia server
#' \describe{
#'   \item{authelia$config()}{This function returns the configuration for the server.
#'   The configuration endpoint provides detailed information including available second factor methods,
#'   if any second factor policies exist and the TOTP period configuration.
#'   }
#'   \item{authelia$health()}{This function performs a health check on the Authelia API}
#' }
#'
#' @section Authentication:
#' For now, autheliar only provides first-factor authentication against the backend API.
#' To perform authentication, use the \code{authelia$firstfactor()} function. This has
#' the following arguments:
#' \describe{
#'   \item{username}{The username to authenticate against.}
#'   \item{password}{The password to authenticate with. NOTE, that this is plain text
#'   and such should be treated with caution. Instead of hard-coding into scripts, it
#'   is recommended to use either \code{keyring::key_get()} or \code{rstudioapi::askForPassword()}.}
#'   \item{domain}{The domain to authenticate against. This is an optional field, and if
#'   left as NULL, will provide back no `re-direct` header}
#'   \item{keepMeLoggedIn}{An optional boolean flag to keep the user logged in.
#'   Authentication duration is controlled by the Authelia server}
#' }
#'
#' autheliar also provides a method for logging out. This can be an important part of an
#' application, especially if being used in a shared environment. Logging out is very simple:
#' \code{authelia$logout()}
#'
#'
#' @section Verification:
#' Once logged in, the next step is to verify access to the domain of interest. Verification
#' is achieved with \code{authelia$verify()}, a function which has the following arguments:
#' \describe{
#'   \item{domain}{The domain of interest. If verification is successful, Authelia will
#'   return the following set of headers which are useful in downstream applications: `remote-name`,
#'   `remote-user`, `remote-email`, `remote-groups`}
#' }
#'
#' @export
#' @examples
#' \dontrun{
#' # connect to the server
#' x <- authelia$new("https://authelia.example.com")
#'
#' # verify authentication against an rstudio server instance
#' x$verify("https://rstudio.example.com")
#'
#' }
#'
#' @name authelia
NULL

authelia <- R6::R6Class(
  "authelia",

  # ============================================================================
  # public functions
  # ============================================================================
  public = list(

    # initialize a new object
    initialize = function(url){
      authelia_init(self, private, url)
    },

    # get the server configuration
    config = function(){
      private$server_config
    },

    # perform first factor logging in
    firstfactor = function(
      username,
      password,
      domain,
      keepMeLoggedIn = TRUE
    ){
      authelia_firstfactor(
        self,
        private,
        username = username,
        password = password,
        domain = domain,
        keepMeLoggedIn = keepMeLoggedIn
      )
    },

    # get the server health
    health = function(){
      r <- httr::GET(
        paste0(private$api, "/health")
      )
      httr::content(r)
    },

    # logout from authelia
    logout = function(){
      r <- httr::POST(
        paste0(private$api, "/logout")
      )
      httr::content(r)
    },

    # verify access to a given domain
    verify = function(domain){
      authelia_verify(self, private, domain)
      private$domains[[domain]]
    }
  ),

  # ============================================================================
  # private list
  # ============================================================================
  private = list(
    url = NULL,
    api = NULL,
    server_config = NULL,
    domains = list()
  )
)
