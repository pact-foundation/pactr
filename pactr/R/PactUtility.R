######################################################################
#' Encapsulate some helper functions
#' 
#' @importFrom R6 R6Class 
#' @export
PactUtility <- R6Class(
  "PactUtility",
  public = list(
    CheckR6ClassType = function(r6Obj, className) {
      if (!is.R6(r6Obj)) {
        return(FALSE)
      }
      
      classes = class(r6Obj)
      
      if (is.element(className, classes)) {
        return(TRUE)
      }
      
      return(FALSE)
    },
    EnforceR6ClassType = function(r6Obj, className) {
      if (self$CheckR6ClassType(r6Obj, className) == FALSE) {
        stop(sprintf("'%s' must be %s", class(r6Obj), className), call. = FALSE)
      }
    }
  )
)
