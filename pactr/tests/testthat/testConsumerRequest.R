library(pactr)


test_that("Test setters in Consumer Request", {
  c1 <- ConsumerRequest$new("myPath")
  expect_equal(as.character(c1$getPath()), "myPath")
})


