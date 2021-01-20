FROM ruby:3.0-alpine as builder

WORKDIR /usr/src

RUN apk add --no-cache --update build-base postgresql-dev tzdata

ENV RAILS_ENV production

ADD Gemfile .
ADD Gemfile.lock .
RUN bundle config set --local without 'development test' && \
    bundle config set --local path './vendor' && \
    bundle install

FROM ruby:3.0-alpine

RUN apk add --no-cache --update postgresql-libs tzdata

WORKDIR /usr/src/vendor

COPY --from=builder /usr/src/vendor .

WORKDIR /usr/src

ADD . .

RUN bundle config set --local without 'development test' && \
    bundle config set --local path './vendor' && \
    bundle install

ENV RAILS_ENV production

EXPOSE 8080
CMD ["bundle", "exec", "unicorn", "-p", "8080", "-c", "./config/unicorn.rb"]
