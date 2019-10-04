######################################################################
# Class to download and install Ruby
#
#' @export
InstallerLinux <- R6Class("InstallerLinux",
                       public = list(
                         isEligible = function() {
                           os = Sys.info()['sysname']
                           if (os == 'Linux') {
                             return (TRUE);
                           }
                           return (FALSE);
                         },
                         install = function(destinationDir) {
                              if (!file.exists(paste0(destinationDir,"/","pact"))) {
                                fileName <- paste0('pact-', private$pactRubyStandaloneVersion,'-linux-x86_64.tar.gz');
                                tempFilePath <- paste0(tempdir(), "/", fileName)
                                private$download(fileName,tempFilePath)
                                private$extract(tempFilePath,destinationDir)
                                private$deleteCompressed(tempFilePath)
                              }

                              scripts = PactScripts$new(
                                paste0(destinationDir,"/pact/bin/pact-mock-service"),
                                paste0(destinationDir,"/pact/bin/pact-stub-service"),
                                paste0(destinationDir,"/pact/bin/pact-provider-verifier"),
                                paste0(destinationDir,"/pact/bin/pact-message")
                              )

                              return (scripts)
                        }
                       ),
                       private = list(
                         pactRubyStandaloneVersion = '1.54.4',
                         download = function(fileName, tempFilePath) {
                           uri <- paste0('https://github.com/pact-foundation/pact-ruby-standalone/releases/download/v', private$pactRubyStandaloneVersion , "/" , fileName);
                           download.file (uri,tempFilePath)
                         },
                         extract = function(sourceFile, destinationDir) {
                           untar(sourceFile,exdir=destinationDir)
                         },
                         deleteCompressed = function(filePath) {
                           file.remove(filePath)
                         }

                       )
)
