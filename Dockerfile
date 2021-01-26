FROM docker.io/ruby:3.0-alpine@sha256:adb9ba9a0b0011cbf4561e6b173e5a2e345b4d6514cbcd178375b58eaa3252c1 as builder
WORKDIR /usr/src
ENV RAILS_ENV production

RUN apk add --no-cache --update build-base postgresql-dev tzdata

ADD Gemfile* .
RUN bundle config set --local without 'development test' && \
    bundle config set --local path './vendor' && \
    bundle install


FROM docker.io/ruby:3.0-alpine@sha256:adb9ba9a0b0011cbf4561e6b173e5a2e345b4d6514cbcd178375b58eaa3252c1
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
