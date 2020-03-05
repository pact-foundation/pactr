######################################################################
# Create the Mock Server configuration object
#
#' @export
MockServerConfig <- R6Class(
  "MockServerConfig",
  public = list(
    initialize = function() {
      private$secure <- FALSE
      private$host  <- "127.0.0.1"
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
    getPactSpecificationVersion = function() {
      private$pact_specification_version
    },
    setPactSpecificationVersion = function(val) {
      private$pact_specification_version = val
      invisible(self)
    },
    getPactLog = function() {
      private$pact_log
    },
    setPactLog = function(val) {
      private$pact_log = val
      invisible(self)
    },
    getPort = function() {
      private$port
    },
    setPort = function(val) {
      private$port = val
      invisible(self)
    },
    getConsumer = function() {
      private$consumer
    },
    setConsumer = function(val) {
      private$consumer = val
      invisible(self)
    },
    getProvider = function() {
      private$provider
    },
    setProvider = function(val) {
      private$provider = val
      invisible(self)
    },
    getPactDir = function() {
      private$pact_dir
    },
    setPactDir = function(val) {
      private$pact_dir = val
      invisible(self)
    },
    getPactFileWriteMode = function() {
      private$pact_file_write_mode
    },
    setPactFileWriteMode = function(val) {
      private$pact_file_write_mode = val
      invisible(self)
    },
    getUri = function() {
      protocol <- "http"
      if (private$secure) {
        protocol <- "https"
      }
      uri <-
        paste(protocol, "://" , private$host, ":" , private$port, sep = "")
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
    cors = FALSE,
    pact_specification_version = "2.0.0",
    pact_log = NULL,
    consumer = NULL,
    provider = NULL,
    pact_dir = NULL,
    pact_file_write_mode = 'merge'
  )
)
