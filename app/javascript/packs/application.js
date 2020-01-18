/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery3
//= require popper
import {} from 'jquery-ujs'
import './src/js/alphawholesale.js'
import './src/js/brokers.js'
import './src/js/offers.js'
import './src/js/products.js'
import './src/js/suppliers.js'
import './src/js/welcome.js'

import '@fortawesome/fontawesome-free/js/fontawesome'
import '@fortawesome/fontawesome-free/js/solid'
import '@fortawesome/fontawesome-free/js/regular'
import '@fortawesome/fontawesome-free/js/brands'
import 'bootstrap/dist/js/bootstrap';
import Turbolinks from 'turbolinks';

Turbolinks.start();
import { library, dom } from "@fortawesome/fontawesome-svg-core";
import { faCheck } from "@fortawesome/free-solid-svg-icons/faCheck";

library.add(faCheck);
dom.watch();

import './src/images'
