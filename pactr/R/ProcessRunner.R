######################################################################
# Wrapper for all the Ruby Pact Scripts to call
#
#' @export
ProcessRunner <- R6Class(
  "ProcessRunner",
  public = list(
    initialize = function(command, argments) {
      private$exit_code <- -1
      private$command <- command
      private$argments <- argments
    },
    getExitCode = function() {
      if (is.na(private$process)) {
        warning("Process has not been set")
      }
      return(private$exit_code)
    },
    runBlocking = function(timeout = -1) {
      #processx library
      p <-
        process$new(
          cmd = private$command,
          args = private$argments,
          echo_cmd = TRUE
        )
      private$process = p
      
      p$wait(timeout)
      private$exit_code = p$get_exit_status()
    },
    runNonBlocking = function() {
      p <- process$new(
        cmd = private$command,
        args = private$argments,
        echo_cmd = TRUE
      )
      private$process = p
    },
    run = function(blocking = false) {
      if (blocking) {
        self$runBlocking()
      } else {
        self$runNonBlocking()
      }
    },
    stop = function() {
      pid = private$process$get_pid()
      print(paste0("Stopping Process Id: ", pid))
      
      private$process$kill()
      
      if (private$process$is_alive()) {
        stop(paste0("Error while killing process: ", pid))
      }
    }
  ),
  private = list(
    exit_code = -1,
    command = NA,
    argments = list(),
    process = NA
  )
)
