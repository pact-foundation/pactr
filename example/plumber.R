
#' Say hello to Bob
#' @get /hello/Bob
#' @serializer contentType list(type="application/json")
function(){
  # json serialization can be a funny thing
  body <- list()
  body[["message"]] = "Hello, Bob"
  return(jsonlite::toJSON(body, auto_unbox = TRUE))
}

#' home
#' @get /
function(){
  return("Say hello")
}