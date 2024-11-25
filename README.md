
# Jimmy-Gym-Buddy-Finder-App

 
* Deployed application URL - https://jimmy-buddy-finder-f97708d96ef8.herokuapp.com/

* Code Climate URL - https://codeclimate.com/github/tamu-edu-students/jimmy-gym-buddy-finder

   

# Deployment Documentation for Jimmy - Gym Buddy Finder App

This guide will walk you through the process of deploying the Jimmy - Gym Buddy Finder Ruby on Rails app on the Heroku platform. It includes steps for setting up authentication, database, real-time chat, and image storage.

## Prerequisites

Before starting the deployment process, ensure you have the following:

- A Heroku account and Heroku CLI installed

- AWS account for S3 setup

- Local Rails development environment set up

  

## 1. Omniauth Authentication Setup

The app uses Omniauth for Google authentication. To configure Google OAuth:

1. Follow the Google OAuth setup documentation.

2. Make sure to create a Google Developer Console project, set up OAuth credentials, and configure the redirect URI to match your Heroku app's domain.

3. The required gems and corresponding configuration has been done already and can be found in `config/initializers/omniauth.rb`.

4. The following environment variables are to setup in Rails credentials in order for omniauth to work:
```yaml 
google: 
    client_id: <google-client-id> 
    client_secret: <google-client-secret>
```	

  

## 2. Heroku Application Setup

 
1. Log in to your Heroku account using the CLI:

	```bash
	heroku login
	```
2. Create a new Heroku app:
	
	```bash
	heroku create <app-name>
	```
	This will create a new Heroku app and automatically add the Heroku Git remote. 
3. Push your local project to Heroku:
	```bash
	git push heroku main
	```
## 3. PostgreSQL Setup on Heroku for Persistent Database.

We will use Heroku Postgres to set up the database for the app. 

1. You need to have a database provisioned for your application. Procure the following add-on and attach it to your heroku app - [Heroku Postgres](https://elements.heroku.com/addons/heroku-postgresql). (Choose the Essential-0 plan for minimal cost) 

2. This will automatically provision the PostgreSQL database and configure the connection. To verify the database connection, check the DATABASE_URL config variable:
	```bash
	heroku config:get DATABASE_URL
	```
3. Migrate the database:
	```bash
	heroku run rake db:migrate
	```

  
## 4. Redis Setup on Heroku for Using Real-Time Chat feature.

Redis will be used for enabling real-time chats with the help of WebSockets. We will use the Heroku Key-Value Store add-on to set up Redis. 

1. You need to have a Heroku Key-Value Store provisioned for your application. Procure the following add-on and attach it to your heroku app - [Heroku Key-Value Store](https://elements.heroku.com/addons/heroku-redis). (Choose the mini plan for minimal cost) 
2. Check the configuration for Redis:
	```bash
	heroku config:get REDIS_URL
	```
3. The corresponding configuration for Redis has been already added and can be found in `config/cable.yml` file. 

## 5. Amazon AWS S3 Bucket Setup for Storing Profile Images 

To store profile images, you'll need to create an Amazon S3 bucket. 

1. Follow the instructions to Create an S3 Bucket. 2. Once the bucket is created, obtain the following credentials from AWS: 
	- Access Key ID 
	- Secret Access Key 
2. The following environment variables are to setup in rails credentials in order for aws s3 bucket connection to happen: 
	```yaml 
		aws: 
			access_key_id: <aws-access-id> 
			secret_access_key: <aws-secret-key>
	```		

## 6. Verify and Monitor Your Deployment

To check your app's logs, use the following command:
```bash
heroku logs --tail
```

The **Jimmy - Gym Buddy Finder** app is now successfully deployed on Heroku with the necessary configurations for authentication, database, real-time chats, and image storage. Make sure to monitor and scale your app as needed using Heroku’s various add-ons and resources.