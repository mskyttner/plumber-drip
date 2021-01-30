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
		drip_ver = system("drip version", intern = TRUE)
	)
}

#* @get /
function(res) {
   res$status <- 302
   res$setHeader("Location", "/__docs__/")
}




