# plumber-dripdrop

Container with R, plumber and drip, for live deployments of Plumber APIs. Using a container can provide nice reproducible and clean execution environment for testing and developing Plumber API.

What is [drip](https://github.com/siegerts/drip/)? It is a neat go binary that triggers Rscript to run a [Plumber API](https://github.com/rstudio/plumber). 

When developing Plumber APIs, mount a local directory in a container DRIPDROP_DIR and watch "live reload" changes appear drip by drop for example at http://localhost:8000. 

# Building

These tools are needed for building and running locally:

- `make`
- `docker` is used (recent CE version with buildx) when running `make` - for multistage building.
- `docker-compose` is used in `make up`.

## Usage

Use the Makefile targets:

		# run all steps
		make 

		# or specific targets
		make build
		make test-default
		make up

Then edit plumber files in the ./dripdrop directory and watch changes appear in the browser at http://localhost:8000/

## Issues

When developing with plumber files located locally in the DRIPDROP_DIR, changes are expected to immediately drip (live deploy/reload) in the plumber dripdrop server.

A few observations and questions:

- The default plumber example used (bundled in the plumber R package) does not run pr$run() which drip expects?
- It seems drip needs to run in the present directory for the entrypoint.R used in the example? For details, try to change the `drip --dir` parameter with first changing present working directory.
- Reloads sometimes cause plumber to halt, while the drip process continues to run. Even if using "restart: always" at the container level, it won't help because drip is still fine (doesn't trap the plumber execution halting in the child process). Could the exit status of plumber execution (if execution halts) be propagated somehow so that drip can restart it if needed? Or if a live change causes a defunct R process - can it be automatically garbage collected so drip can try to recover? Sometimes when this execution halt happens it seems there might be a port clash involved?

		server_1  | createTcpServer: address already in use
		server_1  | Error in initialize(...) : Failed to create server
		server_1  | Calls: <Anonymous> ... <Anonymous> -> startServer -> <Anonymous> -> initialize
		server_1  | Execution halted
- It would be nice with a log file from drip stored on disk at /var/log/drip?



