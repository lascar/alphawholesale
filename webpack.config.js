"use strict";

var path = require('path');
var config = module.exports = {};

config.context = __dirname;

// Specify your entries, I store all my webpack managed JavaScript in
// app/webpack, as per my earlier requirements.
config.entry = {
  application: './app/webpacker/packs/application.js'
};

// This outputs an entry named 'foobar' into
// app/assets/javascripts/entries/foobar.js.
config.output = {
  path: path.join(__dirname, "app/webpacker/packs/src/js/"),
  filename: "[name].js"
}

// Use babel-loader for our *.js files.
config.module = {
  loaders: [
    { test: /\.js$/,
      exclude: /node_modules/,
      loader: "babel-loader" },
    { test: /\.(jpe?g|png|gif|woff|woff2|eot|ttf|svg)(\?[a-z0-9=.]+)?$/,
      loader: 'url-loader?limit=100000' }]
}
