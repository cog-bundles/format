FROM alpine:3.4

# Install basic dependencies
RUN apk -U add ca-certificates ruby ruby-json && \
    rm -f /var/cache/apk/*

# Setup bundle user and directory
RUN adduser -h /home/bundle -D bundle && \
    mkdir -p /home/bundle && \
    chown -R bundle /home/bundle

# Copy over the Gemfile and install gems
WORKDIR /home/bundle
COPY Gemfile Gemfile.lock /home/bundle/

RUN apk add -U ruby-bundler && \
    su bundle -c 'bundle install --standalone --without="development test"' && \
    apk del ruby-bundler && \
    rm -f /var/cache/apk/*

# Copy rest of code
COPY . /home/bundle

# Drop privileges
USER bundle
