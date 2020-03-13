######################################################################
#' Create the Verifier object
#'
#' Wrapper for the Ruby Standalone Verifier service.
#' 
#' @importFrom R6 R6Class 
#' @export
PactVerifier <- R6Class(
  "PactVerifier",
  public = list(
    initialize = function(config, install_pact_dir="../pact-bin") {
      private$config <- config
      
      installer <- InstallManager$new()
      installer$setDestinationDir(install_pact_dir)
      private$scripts <- installer$install()
    },
    getArguments = function() {
      parameters = c()
      
      if (!is.na(private$config$getProviderBaseUrl())) {
        parameters = append(
          parameters,
          paste0(
            "--provider-base-url=",
            private$config$getProviderBaseUrl()
          )
        )
      }
      
      if (!is.na(private$config$getProviderVersion())) {
        parameters = append(
          parameters,
          paste0(
            "--provider-app-version=",
            private$config$getProviderVersion()
          )
        )
      }
      
      if (!is.na(private$config$getProviderStatesSetupUrl())) {
        parameters = append(
          parameters,
          paste0(
            "--provider-states-setup-url=",
            private$config$getProviderStatesSetupUrl()
          )
        )
      }
      
      # if (private$config$getPublishResults()) {
      #   parameters = append(parameters, "--publish-verification-results")
      # }
      # 
      # if (!is.na(private$config$getBrokerUsername())) {
      #   parameters = append(parameters,
      #                       paste0(
      #                         "--broker-username=",
      #                         private$config$getBrokerUsername()
      #                       ))
      # }
      # 
      # if (!is.na(private$config$getBrokerPassword())) {
      #   parameters = append(parameters,
      #                       paste0(
      #                         "--broker-password=",
      #                         private$config$getBrokerPassword()
      #                       ))
      # }
      # 
      # for (customHeader in private$config$getCustomProviderHeaders()) {
      #   parameters = append(parameters,
      #                       paste0("--custom-provider-header=", customHeader))
      # }
      
      if (private$config$getVerbose()) {
        parameters = append(parameters, "--verbose")
      }
      
      # if (!is.na(private$config$getFormat())) {
      #   parameters = append(parameters,
      #                       paste0("--format=", private$config$getFormat()))
      # }
      
      return(parameters)
    },
    verify = function(consumer_name,
                      tag = NA,
                      consumer_version = NA,
                      process_x_args=list()) {
      path <-
        paste0(
          "pacts/provider/",
          private$config$getProviderName(),
          "/consumer/",
          private$config$getConsumerName(),
          "/"
        )
      
      if (!is.na(tag)) {
        path <- paste0(path, "latest/", tag, "/")
      } else if (!is.na(consumer_version)) {
        path <- paste0(path, "version/", consumer_version, "/")
      } else {
        path <- paste0(path, "latest/")
      }
      
      uri = paste0(private$config$getBrokerUri(), path)
      
      args = prepend(uri, self$getArguments())
      return(self$verifyAction(args, process_x_args=list()))
    },
    verifyFiles = function(files, process_x_args=list()) {
      args = c(files, self$getArguments())
      return(self$verifyAction(args, process_x_args))
    },
    verifyAll = function(process_x_args=list()) {
      # @todo
      stop("Need to implement BrokerHttpClient")
    },
    verifyAllForTag = function(tag, process_x_args=list()) {
      # @todo
      stop("Need to implement BrokerHttpClient")
    },
    verifyAction = function(args, process_x_args=list()) {
      process_runner <-
        pactr::ProcessRunner$new(private$scripts$providerVerifier, args, process_x_args)
      process <- process_runner$runBlocking()
            
      if (process$get_exit_status() != 0) {
        stop(paste("Verification action failed. Process Exit Code: ",process$get_exit_status()))
      }
      
      return(process$get_exit_status())
    }
  ),
  private = list(config = NA,
                 scripts = c())
)
