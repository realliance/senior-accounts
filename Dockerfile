FROM docker.io/ruby:3.0-alpine@sha256:f2193eecf485fdd0d6e362af8d2b305fbbad58168f5d66770d15d88786a022e9 as builder
WORKDIR /usr/src
ENV RAILS_ENV production

RUN apk add --no-cache --update build-base postgresql-dev tzdata

ADD Gemfile* .
RUN bundle config set --local without 'development test' && \
    bundle config set --local path './vendor' && \
    bundle install


FROM docker.io/ruby:3.0-alpine@sha256:f2193eecf485fdd0d6e362af8d2b305fbbad58168f5d66770d15d88786a022e9
WORKDIR /usr/src
ENV RAILS_ENV production

RUN apk add --no-cache --update postgresql-libs tzdata

COPY --from=builder /usr/src/vendor /usr/src/vendor
ADD Gemfile* .
RUN bundle config set --local without 'development test' && \
    bundle config set --local path './vendor' && \
    bundle install

ADD . .
RUN mkdir tmp && \
    chown 1000:1000 tmp

EXPOSE 8080
CMD ["docker-start.sh"]
