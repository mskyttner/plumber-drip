#! make

all:
	init build up

init:
	test -d drip || git clone --depth=1 https://github.com/siegerts/drip

build:
	# uses recent docker ce (with buildx)
	# builds rstudio/plumber extended w drip
	docker build --load -t siegerts/plumber-dripdrop .

test-default:
	docker run --rm siegerts/plumber-dripdrop

up:
	docker-compose up -d
	sleep 3
	firefox http://localhost:8000/ &

