
# Jimmy-Gym-Buddy-Finder-App

 
* Deployed application URL - https://jimmy-buddy-finder-f97708d96ef8.herokuapp.com/

* Code Climate URL - https://codeclimate.com/github/tamu-edu-students/jimmy-gym-buddy-finder

**Note**: For CSCE-606 Project Verification, to skip Google Developer's Console setup for Omniauth and Amazon AWS S3 Bucket setup, please contact the team members and get the {master.key} beforehand.

# Development and Testing Documentation Jimmy - Gym Buddy Finder App

## Setup 
To get started with the project, follow these steps: 
1. **Clone the Repository** 
	```bash 
	git clone <repository-url> 
	cd <project-directory>
	```
2. **Install Dependencies.** Ensure you have Ruby and Bundler installed.
	```bash 
	gem install bundler 
	bundle install
	```
3. **Setup Database.** Set up the database by running:
	```bash 
	rails db:migrate
	```
	
4. **Omniauth Authentication Setup**

	The app uses Omniauth for Google authentication. To configure Google OAuth:

	 - Follow the Google OAuth setup documentation.
	 - Make sure to create a Google Developer Console project, set up OAuth credentials, and configure the redirect URI to match your Heroku app's domain.  
	 - The required gems and corresponding configuration has been done already and can be found in `config/initializers/omniauth.rb`.
     - The following environment variables are to setup in Rails credentials in order for omniauth to work:
		```yaml 
		google: 
	      client_id: <google-client-id> 
		  client_secret: <google-client-secret>
		```

5. **Setup Secrets** 
	- To add environment variables securely in Rails credentials, use the following command:
		```bash 
		EDITOR="vim" rails credentials:edit
		```
	- This command does the following:

		-   Opens the encrypted `config/credentials.yml.enc` file for editing.
		-   Allows you to add environment variables (e.g., API keys, secrets).
	- Once saved, Rails encrypts the file using the **`config/master.key`**. This `master.key` is essential to decrypt the credentials file at runtime. The `config/master.key` is **automatically generated** when you run `rails credentials:edit` for the first time.
	 
6. **Verify Setup.** Start the Rails server:
	```bash 
	rails server
	```
Visit `http://localhost:3000` in your browser to confirm the app is running.

# Running Tests

The project includes two types of test suites: **RSpec** and **Cucumber**. Follow the steps below to run the tests.

## 1. RSpec Tests

RSpec is used for unit and integration testing. 
To run the RSpec tests: 
```bash
bundle exec rspec
```

## 2. Cucumber Scenarios

Cucumber is used for behavior-driven development (BDD) and testing user scenarios. 
To run the Cucumber tests: 
```bash
bundle exec cucumber
```

# Deployment Documentation for Jimmy - Gym Buddy Finder App

This guide will walk you through the process of deploying the Jimmy - Gym Buddy Finder Ruby on Rails app on the Heroku platform. It includes steps for setting up database, real-time chat, and image storage.

## Prerequisites

Before starting the deployment process, ensure you have the following:

- A Heroku account and Heroku CLI installed

- AWS account for S3 setup

- Local Rails development environment set up

## 1. Amazon AWS S3 Bucket Setup for Storing Profile Images 

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
3. Follow the steps in [Setup Secrets](#Setup-Secrets) section to setup rails credentials for AWS secrets.

## 1. Heroku Application Setup

 
1. Log in to your Heroku account using the CLI:

	```bash
	heroku login
	```
2. Create a new Heroku app:
	
	```bash
	heroku create <app-name>
	```
	- This will create a new Heroku app on your Heroku account.
	- It also generates a new Heroku Git remote linked to the app.
3. Take generated remote URI and add it to git remote:
	```bash
	git remote add <remote-name> <remote-uri>
	```
4. Check the added Git remotes:
	```bash
	git remote -v
	```
	- This will list all remotes in your local repository.
	- Ensure the `heroku` remote is pointing to the correct Heroku app repository.
5. Set the Rails `master.key` on Heroku:
	The `master.key` is required to decrypt the `credentials.yml.enc` file during runtime. Add it to Heroku using the following command:
	```bash
	heroku config:set RAILS_MASTER_KEY=$(cat config/master.key) --remote <remote-name>
	```

6. Push your local project to Heroku:
	```bash
	git push <remote-name> main
	```


## 2. Add Deployment URL to Google Developer Console

After deploying your app to Heroku, you need to configure the OAuth redirect URL in the Google Developer Console to enable Google OmniAuth authentication.

#### **Steps:**

1.  Obtain your Heroku app's deployment URL:
    
    -   After deploying your app, Heroku generates a URL in the format:
        `https://<your-heroku-app-name>.herokuapp.com` 
        
2.  Add the URL to the Google Developer Console:
    -   Go to the **Google Cloud Console**.
    -   Navigate to **APIs & Services > Credentials**.
    -   Select your **OAuth 2.0 Client IDs**.
    -   Under the **Authorized redirect URIs** section, add the following:
        `https://<your-heroku-app-name>.herokuapp.com/auth/google_oauth2/callback`
  
	The deployed app will now use the configured redirect URL for Google OmniAuth authentication.

## 2. PostgreSQL Setup on Heroku for Persistent Database.

We will use Heroku Postgres to set up the database for the app. 

1. You need to have a database provisioned for your application. Procure the following add-on and attach it to your heroku app - [Heroku Postgres](https://elements.heroku.com/addons/heroku-postgresql). (Choose the Essential-0 plan for minimal cost) 

2. This will automatically provision the PostgreSQL database and configure the connection. To verify the database connection, check the DATABASE_URL config variable:
	```bash
	heroku config:get DATABASE_URL --remote <remote-name>
	```
3. Migrate the database:
	```bash
	heroku run rake db:migrate --remote <remote-name>
	```

  
## 3. Redis Setup on Heroku for Using Real-Time Chat feature.

Redis will be used for enabling real-time chats with the help of WebSockets. We will use the Heroku Key-Value Store add-on to set up Redis. 

1. You need to have a Heroku Key-Value Store provisioned for your application. Procure the following add-on and attach it to your heroku app - [Heroku Key-Value Store](https://elements.heroku.com/addons/heroku-redis). (Choose the mini plan for minimal cost) 
2. Check the configuration for Redis:
	```bash
	heroku config:get REDIS_URL --remote <remote-name>
	```
3. The corresponding configuration for Redis has been already added and can be found in `config/cable.yml` file. 
4. After deploying your app to Heroku, you need to set the correct Action Cable URL and allowed request origins in the `config/environments/production.erb` file for WebSocket connections.
	#### Steps:
	- Open the `config/environments/production.erb` file in your Rails app.
	- Update `config.action_cable.url` and `config.action_cable.allowed_request_origins` using the Heroku app URL.
	- Commit the changes the push the code to heroku remote.

## 5. Verify and Monitor Your Deployment

To check your app's logs, use the following command:
```bash
heroku logs --tail --remote <remote-name>
```

The **Jimmy - Gym Buddy Finder** app is now successfully deployed on Heroku with the necessary configurations for authentication, database, real-time chats, and image storage. Make sure to monitor and scale your app as needed using Heroku’s various add-ons and resources.

# Contact Information

| Name           | Email                  |
|-----------------|------------------------|
| Kushal Lahoti       | [kushal.1170234@tamu.edu](mailto:kushal.1170234@tamu.edu)  |
| Yash Phatak     | [ysphatak@tamu.edu](mailto:ysphatak@tamu.edu) |
| Mrunmay Deshmukh    | [mrunmayd@tamu.edu](mailto:mrunmayd@tamu.edu)   |
| Barry Liu  | [barry89130663@tamu.edu](mailto:barry89130663@tamu.edu)  |`
| Wei-Chien Cheng  | [wccheng@tamu.edu](mailto:wccheng@tamu.edu)   |
| Chuan-Hsin Wang   | [chuanhsin0110@tamu.edu](mailto:chuanhsin0110@tamu.edu)     |
| Kuan-Ru Huang    | [randy103104@tamu.edu](mailto:randy103104@tamu.edu)   |
