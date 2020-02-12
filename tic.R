# install dependencies ---------------------------------------------------------

get_stage("install") %>%
  add_step(step_run_code(remotes::install_deps(dependencies = TRUE)))

# init deployment --------------------------------------------------------------

get_stage("deploy") %>%
  add_step(step_add_to_known_hosts("github.com")) %>%
  add_step(step_install_ssh_keys()) %>%
  add_step(step_setup_push_deploy(path = "bookdown/_book",
                                  branch = "gh-pages", orphan = TRUE)) %>%

  # render all output formats ----------------------------------------------------

add_code_step(
  withr::with_dir("bookdown/", {
    bookdown::render_book(input = "index.Rmd", output_format = "all",
                          envir = new.env())
  })) %>%

  # deploy ---------------------------------------------------------------------

  add_step(step_do_push_deploy(path = "bookdown/_book"))
