FROM ruby:2.7-alpine

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"

RUN gem install bundler:2.1.2
ADD Gemfile* $APP_HOME/
RUN bundle install
ADD . $APP_HOME
