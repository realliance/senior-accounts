FROM docker.io/ruby:3.0-alpine@sha256:9afcc885895358e84929c19ea53cb62ecc50daf93dcbd45de469f2e668d96e9a as builder
WORKDIR /usr/src
ENV RAILS_ENV production

RUN apk add --no-cache --update build-base postgresql-dev tzdata

COPY Gemfile* ./
RUN bundle config set --local without 'development test' && \
    bundle config set --local path './vendor' && \
    bundle install


FROM docker.io/ruby:3.0-alpine@sha256:9afcc885895358e84929c19ea53cb62ecc50daf93dcbd45de469f2e668d96e9a
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
