web: bundle exec rails server -p $PORT
worker: QUEUE=work bundle exec rake environment resque:work
scheduler: bundle exec rake resque:scheduler
