#! /bin/bash
bundle exec rake db:migrate

if [[ $? != 0 ]]; then
  echo
  echo "== Failed to migrate. Running setup first."
  echo
  bundle exec rake db:setup
  bundle exec rake db:migrate
fi

bundle exec rake db:seed
bundle exec rake nb:make_products

# Execute the given or default command:
exec "$@"
