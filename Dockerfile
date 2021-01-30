FROM golang AS builder
WORKDIR /go/src/github.com/siegerts/drip
COPY drip ./
RUN go build -o drip
RUN go install .

FROM rstudio/plumber  
# get drip binary from previous stage
COPY --from=builder /go/bin/drip /usr/local/bin
RUN apt-get update -y && apt-get install tini

# update to use latest plumber R package
RUN R -e "install.packages('devtools')"
RUN R -e "devtools::install_github('rstudio/plumber')"

# set up default drip drop directory and set log file locations
ENTRYPOINT ["tini", "--"]
ENV DRIPDROP_DIR=/usr/local/lib/R/site-library/plumber/plumber/12-entrypoint

RUN mkdir -p /var/log/drip && \
	touch /var/log/drip/access.log /var/log/drip/error.log /var/log/drip/all.log && \
	ln -sf /dev/stdout /var/log/drip/access.log && \
	ln -sf /dev/stderr /var/log/drip/error.log && \
	ln -sf /proc/1/fd/1 /var/log/drip/all.log
#CMD ["bash", "-c", "cd ${DRIPDROP_DIR} && drip watch --routes --showHost 2>&1 | tee /var/drip/all.log"]
CMD ["bash", "-c", "cd ${DRIPDROP_DIR} && drip watch --routes --showHost"]
