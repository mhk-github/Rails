# README

## Initial Setup

These directories contain all files altered after the creation of this app by
the following commands:

1. rails new social\_networking_site
2. cd social\_networking_site
3. rails generate scaffold Member full_name:string website:string

## Notes

### Ruby version

3.0.2

### Rails version

6.1.4.1

### System dependencies

Nokogiri gem version 1.12.5

### Database creation

1. rails db:migrate
2. rails db:migrate RAILS_ENV=test

### Database initialization

1. rails db:seed
2. rails db:seed RAILS_ENV=test

## How to run the test suite

rails test:model

# Deployment instructions

A working site is contained in files *social_networking_site_no_node_module.zip* and *social_networking_site_node_modules.zip*. Unpack these files into a directory and start the site with the command "rails server". The site can be accessed at **http://localhost:3000/members** .
