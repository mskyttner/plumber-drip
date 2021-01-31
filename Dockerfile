FROM golang AS builder
#COPY drip ./
RUN go get -d github.com/siegerts/drip
WORKDIR /go/src/github.com/siegerts/drip
RUN go build -o drip
RUN go install .

FROM rstudio/plumber  
# get drip binary from previous stage
COPY --from=builder /go/bin/drip /usr/local/bin

# add zombie reaper tini and ss
RUN apt-get update -y && \
	apt-get install -y tini iproute2

# update to use latest plumber R package
RUN R -e "install.packages('devtools')"
RUN R -e "devtools::install_github('rstudio/plumber')"
RUN R -e "install.packages(c('progressr', 'furrr'))"

# set up default drip drop directory and set log file locations
ENTRYPOINT ["tini", "--"]
ENV DRIPDROP_DIR=/usr/local/lib/R/site-library/plumber/plumber/12-entrypoint
RUN mkdir -p /var/log/drip && cd /var/log/drip && touch stdout.log stderr.log
CMD ["bash", "-c", "cd ${DRIPDROP_DIR} && drip watch --routes --showHost"]

