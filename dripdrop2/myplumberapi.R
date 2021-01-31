library(progressr)
library(furrr)

plan(multisession, workers = 2)

# from https://davisvaughan.github.io/furrr/articles/articles/progress.html
my_pkg_fn <- function(x, sleepiness = 0.5) {
  p <- progressor(steps = length(x))
  
  future_map(x, ~{
    p()
    Sys.sleep(sleepiness)
    sum(.x)
  })
}

my_task <- function(data, speed) {
  if (missing(data))
    data <- replicate(n = 10, runif(20), simplify = FALSE)
  if (missing(speed))
    speed <- 1
  result <- NULL
  progressr::with_progress(result <- my_pkg_fn(data, speed))
  return(result)
}

#* @get /longrunningresult 
function () {
  my_task()
}

# try to use task queue from 
source("https://raw.githubusercontent.com/r-lib/callr/811a02f604de2cf03264f6b35ce9ec8a412f2581/vignettes/taskq.R")

q <- task_q$new() # queue for long running calculations
sec <- as.difftime(30, units = "secs")  # timeout

#* @get /tasks/start
function() {
  q$push(my_task, list(speed = 2))
  q$push(my_task, list(speed = 0.5))
}

#* @get /tasks/result
function() {
  while (!q$is_idle()) {
    res <- q$pop(sec)
    print(res)
  }
  res$result
  #res$error
  #res$error$parent$trace
}

#* @get /tasks/status
function() {
  list(
    done = as.character(q$get_num_done()),
    running = as.character(q$get_num_running()),
    waiting = as.character(q$get_num_waiting()),
    idle = as.character(q$is_idle()),
    ls = q$list_tasks()[ ,1:3]
  )
}

