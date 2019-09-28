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
                         download = function(fileName, tempFilePath) {
                           uri = paste0('https://github.com/pact-foundation/pact-ruby-standalone/releases/download/v', private$pactRubyStandaloneVersion , "/" , fileName);
                           download.file (uri, paste0(tempFilePath,"/",fileName))
                         }
                       ),
                       private = list(
                         pactRubyStandaloneVersion = '1.54.4'
                       )
)
