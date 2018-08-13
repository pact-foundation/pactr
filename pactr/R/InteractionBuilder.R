######################################################################
# Build an interaction and send it to the Ruby Standalone Mock Service
#
#' @export
InteractionBuilder <- R6Class("InteractionBuilder",
                              public = list(
                                initialize = function() {
                                  private$interaction <- Interaction$new();
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
                                }
                              ),
                              private = list(
                                interaction = NA,
                                config = NA
                              )
)
