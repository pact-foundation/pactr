######################################################################
# Class to download and install Ruby
#
#' @export
InstallerWindows <- R6Class(
  "InstallerWindows",
  public = list(
    isEligible = function() {
      os = Sys.info()['sysname']
      if (os == 'Windows') {
        return (TRUE)
        
      }
      return (FALSE)
      
    },
    install = function(destinationDir) {
      if (!file.exists(paste0(destinationDir, "/", "pact"))) {
        fileName <-
          paste0('pact-',
                 private$pactRubyStandaloneVersion,
                 '-win32.zip')
        
        tempFilePath <-
          paste0(tempdir(), "/", fileName)
        private$download(fileName, tempFilePath)
        private$extract(tempFilePath, destinationDir)
        private$deleteCompressed(tempFilePath)
      }
      
      scripts = PactScripts$new(
        paste0(destinationDir, "/pact/bin/pact-mock-service.bat"),
        paste0(destinationDir, "/pact/bin/pact-stub-service.bat"),
        paste0(destinationDir, "/pact/bin/pact-provider-verifier.bat"),
        paste0(destinationDir, "/pact/bin/pact-message.bat")
      )
      
      return (scripts)
    }
  ),
  private = list(
    pactRubyStandaloneVersion = '1.54.4',
    download = function(fileName, tempFilePath) {
      uri <-
        paste0(
          'https://github.com/pact-foundation/pact-ruby-standalone/releases/download/v',
          private$pactRubyStandaloneVersion ,
          "/" ,
          fileName
        )
      
      download.file (uri, tempFilePath)
    },
    extract = function(sourceFile, destinationDir) {
      unzip(sourceFile, exdir = destinationDir)
    },
    deleteCompressed = function(filePath) {
      file.remove(filePath)
    }
    
  )
)
