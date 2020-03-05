######################################################################
# Wrapper for all the Ruby Pact Scripts to call
#
#' @export
ProcessRunner <- R6Class(
  "ProcessRunner",
  public = list(
    initialize = function(command, argments, process_x_args = list()) {
      private$exit_code <- -1
      private$command <- command
      private$argments <- argments
      private$process_x_args <- process_x_args
    },
    getExitCode = function() {
      if (is.na(private$process)) {
        warning("Process has not been set")
      }
      return(private$exit_code)
    },
    runBlocking = function(timeout = -1) {
      private$process <- private$buildProcess()
      
      # echo to the screen the output
      if(private$getProcessXArg('stdout', NULL)=="|") {
        print("Waiting to read all output lines from process ...")
        cat(private$process$read_all_output_lines(), sep="\n")
      } else {
        private$process$wait(timeout)
      }
      
      private$exit_code = private$process$get_exit_status()
      return(private$process)
    },
    runNonBlocking = function() {
      private$process = private$buildProcess()
      pid = private$process$get_pid()
      print(paste0("Running Process Id: ", pid))
      return(private$process)
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
      
      private$process$kill_true()
      
      if (private$process$is_alive()) {
        stop(paste0("Error while killing process: ", pid))
      }
    }
  ),
  private = list(
    exit_code = -1,
    command = NA,
    argments = c(),
    process_x_args = list(),
    process = NA,
    getProcessXArg = function(name, default) {
      if (hasName(private$process_x_args, name))
        return(private$process_x_args[[name]])
      else
        return(default)
    },
    buildProcess = function() {
      stdout <- private$getProcessXArg('stdout', NULL)
      stderr <- private$getProcessXArg('stderr', NULL)
      
      p <- processx::process$new(
        command = private$command,
        args = private$argments,
        echo_cmd = TRUE,
        stdout = stdout,
        stderr = stderr
      )
      return(p)
    }
  )
)
