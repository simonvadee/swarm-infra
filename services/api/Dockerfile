# cache dependencies
FROM golang:1.12-alpine as cache

RUN adduser -D -g '' no-one
RUN apk update && apk add --no-cache git ca-certificates tzdata && update-ca-certificates

WORKDIR /api

COPY go.mod .
COPY go.sum .

RUN go mod download

# build go binary
FROM cache as builder

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o /go/bin/api

# final image
FROM scratch
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /go/bin/api /go/bin/api

USER no-one

ENTRYPOINT ["/go/bin/api"]