# README

## Initial Setup

These directories contain all files altered after the creation of this app by
the following commands:

1. rails new social\_networking_site
2. cd social\_networking_site
3. rails generate scaffold Member full_name:string website:string

## Notes

### Ruby Version

3.0.2

### Rails Version

6.1.4.1

### System Dependencies

Nokogiri gem version 1.12.5

### Database Creation

1. rails db:migrate
2. rails db:migrate RAILS_ENV=test

### Database Initialization

1. rails db:seed
2. rails db:seed RAILS_ENV=test

### How To Run The Test Suite

rails test:model

### Deployment Instructions

A working site is contained in files *social_networking_site_no_node_module.zip* and *social_networking_site_node_modules.zip*. Unpack these files into a directory and start the site with the command "rails server". The site can be accessed at **http://localhost:3000/members** .
