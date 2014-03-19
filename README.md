# README

This app is to allow one Trello user to "follow" another trello user and see their cards and activity which are all publicly available via the Trello API.

It is based on trello [Organizations](http://help.trello.com/customer/portal/topics/403651-trello-organizations/articles) feature. It will to show your organizations and members.

Additionaly the user can subscribe to receive a nightly report of the users cards and activities the day before.

This app developed to deploy on Heroku in mind, but it may be deployed anywhere.

Configured [memcached](http://memcached.org/) (Heroku add-on MemCachier or another) is strongly recommended!

## Email reports

User can subscribe via checkbox to receive nightly email reports. When nightly cron runs, user is sent a single email for each user they follow. That email contains the followed user's recent activity and cards.

For Heroku it feature required connect Heroku Sheduler add-on and configure every hour run:

`rake reports:followers`

It will send email to each follower at his local time 1:00 AM.

Or daily at explicit time in your time zone if you wish:

`rake reports:followers[all]`

Heroku Scheduler [details](https://devcenter.heroku.com/articles/scheduler).

Also, for email sending Heroku app should be connected to SendGrid add-on or another.

## Demo

See [Live App](http://trello-track.herokuapp.com).

If you want to use it in the production, please deploy app in your instance.


[![Code Climate](https://codeclimate.com/github/YetiCoders/trello_track.png)](https://codeclimate.com/github/YetiCoders/trello_track)

## Authors

Author of the idea: *Robert Graff*

Contributors: [YetiCoders team](http://yeticoders.com) - *Evgenia Vorobjeva*, *Svetogor Malyugin*, *Alexander Oryol*
