# README

To run this application you have to copy file config/application.example.yml to config/application.yml and set there your DATABASE connection credentials

It is possible to run import via rake taks:
rake products:import:csv

Imported items are available via API:

GET /products

GET /products?page=2

GET /products?page=2&per_page=10
