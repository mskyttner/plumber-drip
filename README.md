# plumber-dripdrop

Container with R, plumber and drip, for live deployments of Plumber APIs. When developing Plumber APIs, mount a local directory in a container DRIPDROP_DIR and watch "live reload" changes drip by drop for example at http://localhost:8000. 

## Requirements

Needs docker (recent CE version with buildx) and make - for building.

Needs docker-compose `make up`.

## Usage

Use the Makefile targets:

		make build
		make test-default
		make up

Edit files in ./dripdrop and watch changes in the browser at http://localhost:8000/

## Issues / questions

When developing with plumber files located locally in the DRIPDROP_DIR, changes are expected to immediately drip (live deploy/reload) in the plumber server.

A few observations and questions:

- The default plumber example used (bundled in the plumber R package) does not run pr$run() which drip expects?
- It seems drip needs to run in the present directory for the entrypoint.R used in the example? For details, try to change the `drip --dir` parameter with first changing present working directory.
- Reloads sometimes cause plumber to halt, while the drip process continues. Even if using "restart: always" on the container, won't help because drip is still fine (doesn't trap the plumber execution halting). Could the exit status of plumber execution (if execution halts) be propagated somehow so that drip can restart it if needed? If a live change causes a defunct R process - can it be automatically garbage collected? Sometimes when this execution halt happens it seems there might be a port clash?

		server_1  | createTcpServer: address already in use
		server_1  | Error in initialize(...) : Failed to create server
		server_1  | Calls: <Anonymous> ... <Anonymous> -> startServer -> <Anonymous> -> initialize
		server_1  | Execution halted
- Log file from drip?


