#!/usr/bin/env Rscript

callr::rscript("drip-entrypoint.R", stdout="/var/log/drip/stdout.log", stderr="/var/log/drip/stderr.log")

