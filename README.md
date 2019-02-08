# README

For wholesale online.

A Broker is as a man on the middle; everything occurs with his approval.

A Supplier can place an offer, or respond to a tender.

A Customer can command, or put out a tender.

A Product can have a size, an aspect or a packaging.

An Offer has a price for supplier and a price for customer; in the middle... the broker.

* Ruby version
ruby 2.5.3p105

* System dependencies
rails 5.2.1

* Database
postgresql

## INSTALATION IN DEVELOPMENT

* Fill your config/database.yml to insure that you have a postgres user with
  read/write/create
* <code>bundle exec rake db:drop &&  bundle exec rake db:create &&  bundle exec rake db:migrate && bundle exec rake db:seed &&  bundle exec rake nb:make_products && bundle exec rake db:seed</code>

* For use of the webpack server in dev you have to run in a console apart <code>./bin/webpack-dev-server</code>.

You will obtain 3 users (broker1, supplier1, customer1, password 'milu2000')

and a list of fake products and 3 offers the second time seed is run.

The products are based on 'config/locales/products/fr.yml' (<code>rake nb:make_products</code>).

So you can login as customer or supplier, do not forget to attach product before

doing an offer or order.

You can login as broker at /brokers/sign_in and approve the offer or the order

## DEBUG

With pry-byebug, so for a breakpoint you need to put 'binding-pry' in your code

and write 'next' to jump to the next line.

And pry-rescue to open pry on exception (come handy with rspec)

## RESILIENT NATURE

No inference are made (we try...) upon the media employed by the user (screen or not, size

of screen, help with webreader or not).

Bootstrap 4 is amazing (thanks to the flexboxes) at that.

## TODO

Customer can put a tender. Supplier can respond to a tender.

## DOCKER

The application is 'dokerized'. It is using docker-compose.

There is 3 containers :

* the 'app', the ruby on rails application

* the 'db', the database

* the 'web', the nginx that lisen to the 80 port
,
But you need an .env file (or better parameter in the command line) to inform

<code>RAILS_MASTER_KEY=<long-hash>
POSTGRES_PASSWORD=<string same as in database.yml>
POSTGRES_DB=<string same as in database.yml>
RAILS_ENV=<development or production>
RACK_ENV=<development or production>
NODE_ENV=<development or production>
WEBPACKER_DEV_SERVER_HOST=127.0.0.1
DEVICE_SECRET_KEY=<very long hash>
DEVICE_MAIL_SENDER=<the mail sender>
DEVICE_PEPPER=<very long hash>

## TESTING

It is a work in progress, because it serves me for exploring.

I try this :

* all the 'routes' are covered with each of the user natures (anonymous, customer,

supplier, broker).

* the negative situations are explored with controller test (not authentificated,

not enough permission, failed parameter)

* the positive situations are explored with feature test (behaviour likewise with

capybara syntax, highly simplified thanks to the 'resilient' nature of the application).

## REFACTORING

It is too a wip.

I use reek allthrough i am not so strict.

And bullet to try to get ride of misuse of activerecord.

## FRONT END WITH WEBPACK

It uses webpack instead of sproket (the migration is reflected in the git log).

The stylesheets need a refactorization before to go one with front end; a wip too ;)

For the use of icon-flag-css, the directory app/webpack/flags has been copied from node_modules/flag-icon-css/flags/;

webpack is not good to look for relative path. If somebody has a better solution, please email me!

## TESTING

It is a work in progress, because it serves me for exploring.

I try this :

* all the 'routes' are covered with each of the user natures (anonymous, customer,

supplier, broker).

* the negative situations are explored with controller test (not authentificated,

not enough permission, failed parameter)

* the positive situations are explored with feature test (behaviour likewise with

capybara syntax, highly simplified thanks to the 'resilient' nature of the application).

## REFACTORING

It is too a wip.

I use reek allthrough i am not so strict.

And bullet to try to get ride of misuse of activerecord.

## FRONT END WITH WEBPACK

It uses webpack instead of sproket (the migration is reflected in the git log).

The stylesheets need a refactorization before to go one with front end; a wip too ;)

For the use of icon-flag-css, the directory app/webpack/flags has been copied from node_modules/flag-icon-css/flags/;

webpack is not good to look for relative path. If somebody has a better solution, please email me!
