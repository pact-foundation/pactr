library(pactr)


test_that("Test getUri in MockServerConfig", {
  t1 <- MockServerConfig$new()
  expect_equal(as.character(t1$getUri()), "http://127.0.0.1:80")

  t1$setSecure(TRUE)
  t1$setHost("localhost")
  expect_equal(as.character(t1$getUri()), "https://localhost:80")

  t1$setHost("google.com")$setPort(8080)$setSecure(FALSE)
  expect_equal(as.character(t1$getUri()), "http://google.com:8080")
})


