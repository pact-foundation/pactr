library(pactr)


test_that("Test that pact is valid", {
  # provider stood up in testthat.R
  config <- pactr::PactVerifierConfig$new();
  config$setProviderName("someProvider");
  config$setProviderBaseUrl("http://localhost:8000");
  config$setProviderVersion("1.0.0");

  base_dir = paste0(getwd(), "/../../")
  pact_install_dir = paste0(base_dir, "../pact-bin");
  verifier <- pactr::PactVerifier$new(config, install_pact_dir=pact_install_dir);
  process_x_args = list("stdout" = "|",
                        "stderr" = paste0(base_dir,"../example/logs/provider_validation_stderr.log"))

  # needs to be run after consumer
  exit_code <- verifier$verifyFiles(c(paste0(base_dir,"../output/someconsumer-someprovider.json")), process_x_args)
  expect_equal(as.integer(exit_code), 0)
})


