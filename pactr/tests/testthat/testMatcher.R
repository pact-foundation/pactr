library(pactr)


test_that("Test Structure of the somethingLike function", {
  test1 <- Matcher$new();
  out1 <- test1$somethingLike("wow")
  expect_equal(as.character(out1["contents"]), "wow")
  expect_equal(as.character(out1["json_class"]), "Pact::SomethingLike")
})


