#!/bin/sh

bundle exec rails db:migrate
bundle exec unicorn -p 8080 -c ./config/unicorn.rb
