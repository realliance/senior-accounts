FROM docker.io/ruby:3.0-alpine@sha256:cb8ed35a9c6765f2a53bbc7feaa1969e48cd856276013de35724ba9372b800d0 as builder
WORKDIR /usr/src
ENV RAILS_ENV production

RUN apk add --no-cache --update build-base postgresql-dev tzdata

COPY Gemfile* ./
RUN bundle config set --local without 'development test' && \
    bundle config set --local path './vendor' && \
    bundle install


FROM docker.io/ruby:3.0-alpine@sha256:cb8ed35a9c6765f2a53bbc7feaa1969e48cd856276013de35724ba9372b800d0
ARG RELEASE
WORKDIR /usr/src
ENV RAILS_ENV production
ENV RELEASE $RELEASE

RUN apk add --no-cache --update postgresql-libs tzdata

COPY --from=builder /usr/src/vendor /usr/src/vendor
COPY Gemfile* ./
RUN bundle config set --local without 'development test' && \
    bundle config set --local path './vendor' && \
    bundle install

COPY . .
RUN mkdir tmp && \
    chown 1000:1000 tmp

EXPOSE 8080
CMD ["bundle", "exec", "unicorn", "-p", "8080", "-c", "./config/unicorn.rb"]
