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

## INSTALATION

* Fill your config/database.yml to insure that you have a postgres user with
  read/write/create
* <code>bundle exec rake db:drop &&  bundle exec rake db:create &&  bundle exec rake db:migrate &&  bundle exec rake db:seed &&  bundle exec rake nb:make_products</code>

You will obtain 3 users (broker1, supplier1, customer1, password 'milu2000') and a list of fake products

based on 'config/locales/products/fr.yml'

## DEBUG

With pry-debug, so for a breakpoint you need to put 'binding-pry' in your code

and write 'next' to jump to the next line

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

## TESTING

It is a work in progress, because it serves me for exploring.

I try this :

* all the 'routes' are covered whith each of the user nature (anonymous, customer,

supplier, broker).

* the negative situations are explored with controller test (not authentificated,

not enough permission, failed parameter)

* the positive situations are explored with feature test (behaviour likewise with

capybara syntax, highly simplified thanks to the 'resilient' nature of the application).

## REFACTORING

It is too a wip.

I use reek allthrough i am not so strict.

And bullet to try to get ride of misuse of activerecord.
