FROM ruby:2.3.1-alpine

# Setup cog user
RUN adduser -h /home/cog -D cog && \
    mkdir -p /home/cog

WORKDIR /home/cog
COPY . $WORKDIR
RUN bundle install --path .bundle
