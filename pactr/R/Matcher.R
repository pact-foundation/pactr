######################################################################
#' Create the matcher object
#'
#' This is used as a DSL for matchers
#' 
#' @importFrom R6 R6Class 
#' @export
Matcher <- R6Class("Matcher",
                   public = list(
                     like = function(val) {
                       out <- data.frame(val, "Pact::SomethingLike")
                       names(out) = c("contents", "json_class")
                       out <- as.list(out[1,])
                       return(out)
                     },
                     somethingLike = function(val) {
                       return (self$like(val))
                     },
                     term = function(val, pattern) {
                       
                       matcher <- list(
                         "json_class" = 'Regexp',
                         'o' = 0,
                         's' = pattern
                       )
                       
                       data <- list(
                         'generate' = val,
                         'matcher' = matcher
                       )
                       
                       ret <- list(
                         'data' = data,
                         'json_class' = 'Pact::Term'
                       )
                       
                       return (ret)
                     },
                     regex = function(val, pattern) {
                      return(self::term(val, pattern))
                     }
                   ))
