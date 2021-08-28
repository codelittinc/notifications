![CI](https://github.com/codelittinc/rails-api-base-project/workflows/CI/badge.svg)

Notifications API
=================

![](slack.png)

The goal of this application is to create a simple way to send message notifications to messaging platforms easy!

## How to run the application

### Requirements

[Install docker](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04) and docker-compose

### Steps

#### Setting up the project
1. git clone git@github.com:codelittinc/notifications.git
2. inside the project folder run `sh bin/dev`

You are now in the docker console

3. run: `bundle install`
4. run: `rails db:setup`
5. run the server: rails s -b\`hostname -i\`
6. access the admin panel on your browser: `http://localhost:3000/admin`

#### Configuring your first Slack provider

1. Access `http://localhost:3000/admin/provider_credential/new`
2. Set the Access Key that you get from your Slack app
3. Set the Team that you get from your Slack app
4. Set the Application Key that you'll use to identify this provider. It will be used as an authentication key as well
5. Set the name of your team (currently used for internal management only)

#### Trying it out:

**Listing the Slack users:**

curl --location --request GET 'http://localhost:4000/users' --header 'Authorization: <APPLICATION_KEY>'

**Sending messages:**

curl --location --request POST 'http://localhost:4000/channel-messages' \
--header 'Content-Type: application/json' \
--header 'Authorization: <APPLICATION_KEY>' \
--data-raw '{
	"channel": "feed-test-automations",
	"message": ":roadrunner: I'\''m working!"
}'
