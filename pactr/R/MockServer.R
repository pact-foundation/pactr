######################################################################
#' Create the Mock Server  object
#'
#' @importFrom R6 R6Class 
#' @export
MockServer <- R6Class(
  "MockServer",
  public = list(
    initialize = function(config,
                          http_service = NULL,
                          install_dir = NULL) {
      private$config <- config
      
      installer <- InstallManager$new()
      if (!is.null(install_dir)) {
        installer$setDestinationDir(install_dir)
      }
      if (is.null(http_service)) {
        private$http_service <- MockServerHttpService$new(private$config)
      } else {
        private$http_service <- http_service
      }
      private$scripts <- installer$install()
    },
    start = function(process_x_args = list()) {
      private$process_runner <-
        pactr::ProcessRunner$new(private$scripts$mockService, private$getArguments(), process_x_args)
      process <- private$process_runner$runNonBlocking()
      # todo @verify it is up and running
      return(process)
    },
    stop = function(val) {
      private$process_runner$stop()
    }
  ),
  private = list(
    config = NULL,
    http_service = NULL,
    scripts = NULL,
    process_runner = NULL,
    getArguments = function() {
      parameters = c(
        'service',
        paste0("--consumer=",
               private$config$getConsumer()),
        paste0("--provider=",
               private$config$getProvider()),
        paste0("--pact-dir=",
               private$config$getPactDir()),
        paste0(
          "--pact-file-write-mode=",
          private$config$getPactFileWriteMode()
        ),
        paste0("--host=",
               private$config$getHost()),
        paste0("--port=",
               private$config$getPort())
      )
      
      if (private$config$hasCors() == TRUE) {
        parameters = append(parameters,
                            '--cors=true')
      }
      
      if (!is.null(private$config$getPactSpecificationVersion())) {
        parameters <- append(
          parameters,
          paste0(
            "--pact-specification-version=",
            private$config$getPactSpecificationVersion()
          )
        )
      }
      
      if (!is.null(private$config$getPactLog())) {
        parameters <- append(parameters,
                             paste0("--log=",
                                    private$config$getPactLog()))
      }
      
      return(parameters)
    },
    verifyHealthCheck = function() {
      stop("Implement verifyHealthCheck")
    }
  )
)
