FROM alpine:3.3

RUN apk -U add ca-certificates ruby ruby-bundler ruby-dev ruby-io-console \
               ruby-builder ruby-irb ruby-rdoc ruby-json

WORKDIR /bundle
COPY . $WORKDIR
RUN bundle install --path .bundle
