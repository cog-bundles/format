FROM alpine:3.4

RUN apk -U add ca-certificates ruby ruby-bundler ruby-json

# Setup bundle user and directory
RUN adduser -h /home/bundle -D bundle && \
    mkdir -p /home/bundle && \
    chown -R bundle /home/bundle

# Copy over the Gemfile and install gems
WORKDIR /home/bundle
COPY Gemfile Gemfile.lock /home/bundle/
RUN su bundle -c 'bundle install --standalone --without="development test"'

# Copy rest of code
COPY . /home/bundle

# Drop privileges
USER bundle
