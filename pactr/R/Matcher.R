######################################################################
# Create the matcher object
#
# This is used as a DSL for matchers
#' @export
Matcher <- R6Class("Matcher",
                   public = list(
                     somethingLike = function(val)
                     {
                       out = c(contents = val,
                               json_class = "Pact::SomethingLike")
                       
                       return(out)
                     }
                   ))
