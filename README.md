My DCIM
================

This Ruby On Rails app is a tool built to effectively manage data center infrastructures.

![Tests](https://github.com/nanego/my-dcim/workflows/Tests/badge.svg)

## Installation steps
### Step 1. Dependencies
#####  1.1 PostgreSQL
##### 1.2 Git

### Step 2. Ruby Installation Using RVM

#### 2.1 Installing Ruby using RVM (development version)
Run the following commands to install stable version:

    curl -L https://get.rvm.io | bash -s stable

    source ~/.rvm/scripts/rvm

    rvm install 3.1.4

    rvm use 3.1.4 --default

#### 2.2 Installing Bundler
Bundler is a tool that allows you to install multiple gem versions, run this command to install bundler:

    gem install bundler

### Step 3. Configurations

#### 3.1 Clone Application Code
Clone project code from GitHub:
    
    git clone https://github.com/nanego/my-dcim


#### 3.2 Navigate to Project Directory

    cd my-dcim

#### 3.3 Installing Gems

    bundle install

#### 3.4 PDF configuration
Using following command in terminal to get path of wkhtmltopdf library path that is already installed on system.

    which wkhtmltopdf
Edit config/config.yml with your own application wkhtmltopdf path.

    wkhtmltopdf_path: YOUR_WKHTMLTOPDF_PATH

#### 3.5 SMTP configuration
Edit config/config.yml with your own application smtp settings.

     smtp_setting:
         address: smtp.gmail.com
         port: 587
         authentication: :plain
         enable_starttls_auto: true
         user_name: YOUR_EMAIL_HERE
         password: YOUR_PASSWORD_HERE

#### 3.6 Configuring Database
Copy config/database.yml.copy to config/database.yml and set your postgres username/password. After that run following command from terminal to create PostgreSQL database specified in database.yml file.

    rake db:create

#### 3.7 Tables schema and seeding

    rake db:migrate

Loading default values in database

    rake db:seed

### Step 4. Run

#### 4.1 Development Environment
Your application is ready to use.  Run rails server using following command:

    rails server

and use your application in browser by typing in url: localhost:3000

#### 4.2 Production Environment

You can also configure Apache, Nginx or any other web/application server of your choice to execute in production mode.

Contributing
------------

Here are some of the ways you can contribute:

### Report or fix Bugs

### Improve test coverage

As with any large and growing codebase, test coverage is not always as good as it could be. Help improving test coverage is always welcome and will help you learn how My-DCIM works.
    
### Refactor code

### Translate the project

### Build new features

1. Fork the Github repository
2. Create your feature branch (`git checkout -b my-awesome-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-awesome-feature`)
5. Create new Pull Request
