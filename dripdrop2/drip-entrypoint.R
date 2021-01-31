#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)

# get pr reference from entrypoint
source("entrypoint-plumber.R", local = TRUE)

# determine which port to use (check env and arg)
port <- 8000L  # default
if (Sys.getenv("DRIPDROP_PORT") != "") port <- as.integer(Sys.getenv("DRIPDROP_PORT"))
if (length(args) >=1) port <- as.integer(args[1])
listening <- as.integer(system("ss -tulpnH | awk '{print $5}' | cut -d: -f 2", intern = TRUE))
message("Ports already in use are: ")
print(listening)
if (port %in% listening) stop("The port ", port, " is already in use!")
stopifnot(is.integer(port))
stopifnot(port > 1 && port < 65535)

# print routes
pr()

# run it
plumber::pr_run(pr, host = "0.0.0.0", port = port)

