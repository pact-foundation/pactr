######################################################################
# Verifier Configuation object to configure use of the Pact Verifier
#
#' @export
PactVerifierConfig <- R6Class(
  "PactVerifierConfig",
  public = list(
    initialize = function() {
      
    },
    getProviderBaseUrl = function() {
      return(private$provider_base_url)
    },
    setProviderBaseUrl = function(val) {
      private$provider_base_url <- val
    },
    getProviderStatesSetupUrl = function() {
      return(private$provider_states_setup_url)
    },
    setProviderStatesSetupUrl = function(val) {
      private$provider_states_setup_url <- val
    },
    getProviderName = function() {
      return(private$provider_name)
    },
    setProviderName = function(val) {
      private$provider_name <- val
    },
    getProviderVersion = function() {
      return(private$provider_version)
    },
    setProviderVersion = function(val) {
      private$provider_version <- val
    },
    getPublishResults = function() {
      return(private$publish_results)
    },
    setPublishResults = function(val) {
      private$publish_results <- val
    },
    getBrokerUri = function() {
      return(private$broker_uri)
    },
    setBrokerUri = function(val) {
      private$broker_uri <- val
    },
    getBrokerUserName = function() {
      return(private$broker_user)
    },
    setBrokerUser = function(val) {
      private$broker_user <- val
    },
    getBrokerPassword = function() {
      return(private$broker_password)
    },
    setBrokerPassword = function(val) {
      private$broker_password <- val
    },
    getCustomProviderHeaders = function() {
      return(private$custom_provider_headers)
    },
    setCustomProviderHeaders = function(val) {
      private$custom_provider_headers <- val
    },
    getVerbose = function() {
      return(private$verbose)
    },
    setVerbose = function(val) {
      private$verbose <- val
    },
    getFormat = function() {
      return(private$format)
    },
    setFormat = function(val) {
      private$format <- val
    },
    getProcessTimeout = function() {
      return(private$process_timeout)
    },
    setProcessTimeout = function(val) {
      private$process_timeout <- val
    },
    getProcessIdleTimeout = function() {
      return(private$process_idle_timeout)
    },
    setProcessIdleTimeout = function(val) {
      private$process_idle_timeout <- val
    }
  ),
  private = list(
    provider_base_url = NA,
    provider_states_setup_url = NA,
    provider_name = NA,
    provider_version = NA,
    publish_results = FALSE,
    broker_uri = NA,
    broker_username = NA,
    broker_password = NA,
    custom_provider_headers = c(),
    verbose = FALSE,
    format = NA,
    process_timeout = 60,
    process_idle_timeout = 10
  )
)
