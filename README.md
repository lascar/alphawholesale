# README

For wholesale online.

A Broker is as a man on the middle; everything occurs with his approval.

A Supplier can place an offer, or respond to a request (todo).

A Customer can command, or put a request (todo).

A Complete Product can have a size, an aspect, a packaging, a size or a calibre.

An Offer has a complete product, price for supplier and a price for customer; in the middle... the broker.

* Ruby version
ruby 2.6.5

* System dependencies
rails 6.0.2.1

* Database
postgresql
Redis server 5.0.5 (https://www.hugeserver.com/kb/install-redis-4-debian-9-stretch/ for install on debian)

## UPGRADE TO RAILS 6

It was write in rails 5.2 and used 'delayed_job_active_record' but now it use sidekiq because of the problems with this gem

It use rspec 4 because the 3 has given problems too


## INSTALATION IN DEVELOPMENT

* For your config/database.yml the db user, password and database must be informed in secret.yml.enc (see SECRET_YML_ENC_EXAMPLE.md)

* <code> bundle exec rake db:create &&  bundle exec rake db:migrate && bundle exec rake db:seed &&  bundle exec rake nb:make_products && bundle exec rake db:seed</code>

* For use of the webpack server in dev you have to run in a console apart <code>./bin/webpack-dev-server</code>.

You will obtain 3 users (broker1, supplier1, customer1, password 'password83')

and a list of fake products and 3 offers the second time seed is run.

The products are based on 'config/locales/products/en.yml' (<code>rake nb:make_products</code>).

For production you have to change this list accordingly to his simple syntax.

If you want to add a product, simply add it in the file (product, variety, aspect and/or packaging);
the task is idempotent, no problem.

So you can login as customer or supplier, do not forget to attach product before

doing an offer or order.

You can login as broker at /brokers/sign_in and approve the offer or the order

If you want some examples of attached product, you can run

<code>rails products:make_attached_products_list_examples</code>

You will obtains 8 attached products build on the 2 first products of config/locals/products/en.yml

## RESILIENT NATURE

No inference are made (we try...) upon the media employed by the user (screen or not, size

of screen, help with webreader or not).

Bootstrap 4 is amazing (thanks to the flexboxes) at that.

Javascript is use only for the client's comfort, if javascript is not activated,
the application still works!

## TODO

Customer can put a request. Supplier can respond to a request.

## DOCKER

Todo actualize docker

The application is 'dokerized'. It is using docker-compose.

There is 3 containers :

* the 'app', the ruby on rails application

* the 'db', the database

* the 'web', the nginx that lisen to the 80 port

* TODO redis/sidekiq

But you need an .env file (or better parameter in the command line) to inform

<code>RAILS_MASTER_KEY=<long-hash>
POSTGRES_PASSWORD=<string>
POSTGRES_DB=<string>
RAILS_ENV=<development or production>
RACK_ENV=<development or production>
NODE_ENV=<development or production>
WEBPACKER_DEV_SERVER_HOST=127.0.0.1
DEVICE_SECRET_KEY=<very long hash>
DEVICE_MAIL_SENDER=<the mail sender>
DEVICE_PEPPER=<very long hash>
</code>

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

I use reek allthrough I am not so strict.

And bullet to try to get ride of misuse of activerecord.

## FRONT END WITH WEBPACK

It uses webpack instead of sproket (the migration is reflected in the git log).

The stylesheets need a refactorization before to go one with front end; a wip too ;)

## CREDENTIALS

Rails credentials new system is used so en .gitignore, master.key.

For master.key, for docker it is in ENV and for development in the config/master.key

(generate the first run of credentials:edit).

## JOB AND MAILS

Of course, a wip!

It use sidekiq

For now, just in case a supplier is approved a job is run that sends a mail.

All the mail config is expect in config/credentials.yml

````
mail:                                                                           
  development:                                                                  
    HOST: localhost                                                             
    HOST_PORT: 3000                                                             
    ADDRESS: "smtp.gmail.com"                                                   
    PORT: 587                                                                   
    USER_NAME: "pascal.carrie@gmail.com"                                        
    PASSWORD: "uuuurynruwgrdaaa"                                                
    AUTHENTICATION: "plain"                                                     
    ENABLE_STARTTLS_AUTO: true                                                  
  production:                                                                   
    HOST: wholesale.lascar.me                                                   
    HOST_PORT: 80                                                               
    ADDRESS: "smtp.gmail.com"                                                   
    PORT: 587                                                                   
    USER_NAME: "pascal.carrie@gmail.com"                                        
    PASSWORD: "telohascreido!"                                                       
    AUTHENTICATION: "plain"                                                     
    ENABLE_STARTTLS_AUTO: true
````
If you use a mecanism like '2-Step Verification' in gmail, you need to create an application password:

https://support.google.com/accounts/answer/185833
