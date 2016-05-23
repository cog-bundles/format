FROM ruby:2.3.1-alpine

RUN echo -n "Before: " && du -sh /

WORKDIR /bundle
COPY . $WORKDIR
RUN bundle install --path .bundle

RUN echo -n "After: " && du -sh /