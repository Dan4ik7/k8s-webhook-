#
# Build stage
#
FROM golang:1.22-alpine as go-builder

WORKDIR /github-deploy

COPY . .

RUN apk add --no-cache curl gcc musl-dev && \
    CGO_ENABLED=0 GOOS=linux go build -v -a -installsuffix cgo -o github-deploy . && \
    rm -rf /var/cache/apk/*

#
# Runtime stage
#
FROM alpine:latest

WORKDIR /app

RUN apk --no-cache add ca-certificates bash curl

COPY --from=go-builder /github-deploy/github-deploy /github-deploy

ENTRYPOINT [ "/github-deploy" ]
