FROM ruby:2.3-slim
MAINTAINER Martin Stabenfeldt <martin@stabenfeldt.net>

RUN apt-get update && apt-get install -qq -y --no-install-recommends \
      build-essential nodejs libpq-dev vim

ENV INSTALL_PATH /numbers

RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

COPY Gemfile Gemfile.lock ./

RUN bundle install --binstubs

COPY . .

RUN bundle exec rake RAILS_ENV=production DATABASE_URL=postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@127.0.0.1/numbers ACTION_CABLE_ALLOWED_REQUEST_ORIGINS=foo,bar SECRET_TOKEN=dummytoken assets:precompile

VOLUME ["$INSTALL_PATH/public"]

CMD puma -C config/puma.rb
