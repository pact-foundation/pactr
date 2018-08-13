######################################################################
# Create the Mock Server configuration object
#
#' @export
MockServerConfig <- R6Class("MockServerConfig",
                          public = list(
                            initialize = function() {
                              private$secure <- FALSE
                              private$host  <- "localhost"
                              private$port  <- 80
                              private$cors  <- FALSE
                            },
                            getHost = function() {
                              private$host
                            },
                            setHost = function(val) {
                              private$host = val
                              invisible(self)
                            },
                            getPort = function() {
                              private$port
                            },
                            setPort = function(val) {
                              private$port = val
                              invisible(self)
                            },
                            getUri = function() {
                              protocol <- "http"
                              if (private$secure) {
                                protocol <- "https"
                              }
                              uri <- paste(protocol, "://" , private$host, ":" , private$port, sep="")
                              return (uri)
                            },
                            hasCors = function() {
                              private$cors
                            },
                            setCors = function(val) {
                              private$cors = val
                              invisible(self)
                            },
                            isSecure = function() {
                              private$secure
                            },
                            setSecure = function(val) {
                              private$secure = val
                              invisible(self)
                            }
                          ),
                          private = list(
                            secure = logical(1),
                            host = character(0),
                            port = numeric(0),
                            cors = logical(1)
                          )
)
