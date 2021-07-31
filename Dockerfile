FROM ruby:3.0.2-buster

ARG RAILS_ENV
RUN echo "Running Dockerfile with the environment: ${RAILS_ENV}"

WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle config set with ${RAILS_ENV}
RUN bundle install

EXPOSE 3000

COPY . .

CMD ["rails", "server", "-b", "0.0.0.0"]