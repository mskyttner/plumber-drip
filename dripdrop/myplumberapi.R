#* @get /
function(res) {
	res$status <- 302
	res$setHeader("Location", "/__docs__/")
}

#* @get /counter
function(req){
  count <- 0
  if (!is.null(req$session$counter)){
    count <- as.numeric(req$session$counter)
  }
  req$session$counter <- count + 1
  return(paste0("This is visit #", count))
}

#* @get /serverinfo
function() {
	list(
		R_sessionInfo = as.character(sessionInfo()),
		plumber_desc = as.character(packageDescription("plumber")),
		plumber_apis = plumber::available_apis(),
		dripdrop_dir = Sys.getenv("DRIPDROP_DIR"),
		dripdrop_files = dir(Sys.getenv("DRIPDROP_DIR")),
		drip_ver = system("drip version", intern = TRUE),
		env = as.character(Sys.getenv()),
		free_mem = system("free -m", intern = TRUE),
		free_disk = system("df -h", intern = TRUE),
		ps_zombies = system("ps aux | grep '<defunct>'", intern = TRUE)
		
	)
}

#* @get /apis
function() {
	plumber::available_apis()
}


#* @get /log/stdout
function() {
	readLines("/var/log/drip/stdout.log")
}

#* @get /log/stderr
function() {
	readLines("/var/log/drip/stderr.log")
}

