######################################################################
#' Build an interaction and send it to the Ruby Standalone Mock Service
#'
#' @importFrom R6 R6Class 
#' @export
InteractionBuilder <- R6Class(
  "InteractionBuilder",
  public = list(
    initialize = function(config) {
      private$interaction <- Interaction$new()
      private$config <- config
      private$mockServerHttpService <- MockServerHttpService$new(private$config)
    },
    given = function(providerState) {
      private$interaction$setProviderState(providerState)
    },
    uponReceiving = function(description) {
      private$interaction$setDescription(description)
    },
    with = function(request) {
      utility <- PactUtility$new()
      utility$EnforceR6ClassType(request, "ConsumerRequest")
      
      private$interaction$setRequest(request)
    },
    willRespondWith = function(response) {
      utility <- PactUtility$new()
      utility$EnforceR6ClassType(response, "ProviderResponse")
      
      private$interaction$setResponse(response)
      self$registerInteraction(private$interaction)
    },
    verify = function() {
      result <- private$mockServerHttpService$verifyInteractions()
      if (result==FALSE) {
        warning("Interaction not verified")
      }
      return(result)
    },
    registerInteraction = function(interaction) {
      private$mockServerHttpService$registerInteraction(interaction)
    },
    writePact = function() {
      private$mockServerHttpService$getPactJson()
    },
    finalize = function() {
      self$writePact()
      private$mockServerHttpService$deleteAllInteractions()
    }
  ),
  private = list(interaction = NA,
                 mockServerHttpService = NA,
                 config = NA)
)
