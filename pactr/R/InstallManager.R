######################################################################
# Managing classes to install Ruby
#
#' @export
InstallManager <- R6Class(
  "InstallManager",
  public = list(
    install = function() {
      downloader = private$getDownloader()
      scripts <- downloader$install(private$destinationDir)
      return(scripts)
    },
    setDestinationDir = function (dir) {
      private$destinationDir = dir
    },
    uninstall = function() {
      unlink(private$destinationDir, recursive = TRUE)
    }
  ),
  private = list(
    destinationDir = '/../../../..',
    
    getDownloader = function() {
      linux <- InstallerLinux$new()
      if (linux$isEligible() == TRUE) {
        return (linux)
      }
      
      windows <- InstallerWindows$new() 
      if (windows$isEligible() == TRUE) {
        return (windows)
      }
      
      # to do: support Mac OS
      stop("OS installer could not be found", call. = FALSE)
    }
  )
)