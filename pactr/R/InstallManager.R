######################################################################
# Managing classes to install Ruby
#
#' @export
InstallManager <- R6Class("InstallManager",
                       public = list(
                         install = function() {
                             downloader = private$getDownloader()
                             downloader$install(destinationDir)
                         },
                         setDestinationDir = function (dir) {
                            private$destinationDir = dir
                         },
                         uninstall = function() {
                            unlink(private$destinationDir, recursive=TRUE)
                         }
                        ),
                        private = list(
                            destinationDir='/../../../..',

                            getDownloader = function() {
                                linux <- InstallerLinux$new()
                                if (linux$isEligible() == TRUE) {
                                    return (linux)
                                }
                                else {
                                    stop("Only Linux installer has been built so far",call.=FALSE)
                                }
                            }
                        )
)