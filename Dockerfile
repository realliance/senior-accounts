FROM docker.io/ruby:3.0-alpine@sha256:cbd984172d1c0f05656d3e416e65c3c72168eedecf9c1e6599fc1db615949f44 as builder
WORKDIR /usr/src
ENV RAILS_ENV production

RUN apk add --no-cache --update build-base postgresql-dev tzdata

ADD Gemfile* .
RUN bundle config set --local without 'development test' && \
    bundle config set --local path './vendor' && \
    bundle install


FROM docker.io/ruby:3.0-alpine@sha256:cbd984172d1c0f05656d3e416e65c3c72168eedecf9c1e6599fc1db615949f44
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
CMD ["bundle", "exec", "unicorn", "-p", "8080", "-c", "./config/unicorn.rb"]
