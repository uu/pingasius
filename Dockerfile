FROM alpine:3.21 AS builder
RUN apk add --no-cache --update shards crystal make libxml2-dev zlib-dev openssl-dev xz-dev xz-static libxml2-static zlib-static openssl-libs-static
WORKDIR /pingasius
COPY . /pingasius
RUN make

FROM alpine:3.21 AS runner
RUN apk add --no-cache --update whois nmap nmap-scripts iputils-ping bind-tools
COPY --from=builder /pingasius/bin/pingasius /bin/pingasius
CMD /bin/pingasius
