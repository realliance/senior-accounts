FROM docker.io/ruby:3.0-alpine@sha256:a4ed1c4962712e46934373082eabe42c4dad531d7f53eaff23fabe8a599165db as builder
WORKDIR /usr/src
ENV RAILS_ENV production

RUN apk add --no-cache --update build-base postgresql-dev tzdata

ADD Gemfile* ./
RUN bundle config set --local without 'development test' && \
    bundle config set --local path './vendor' && \
    bundle install


FROM docker.io/ruby:3.0-alpine@sha256:a4ed1c4962712e46934373082eabe42c4dad531d7f53eaff23fabe8a599165db
ARG RELEASE
WORKDIR /usr/src
ENV RAILS_ENV production
ENV RELEASE $RELEASE

RUN apk add --no-cache --update postgresql-libs tzdata

COPY --from=builder /usr/src/vendor /usr/src/vendor
ADD Gemfile* ./
RUN bundle config set --local without 'development test' && \
    bundle config set --local path './vendor' && \
    bundle install

ADD . .
RUN mkdir tmp && \
    chown 1000:1000 tmp

EXPOSE 8080
CMD ["bundle", "exec", "unicorn", "-p", "8080", "-c", "./config/unicorn.rb"]
