# README

This app is to allow one Trello user to "follow" another trello user and see their cards and activity which are all publicly available via the Trello API.
It is based on trello [Organizations](http://help.trello.com/customer/portal/topics/403651-trello-organizations/articles) feature. It will to show your organizations and members.

Additionaly the user can subscribe to receive a nightly report of the users cards and activities the day before.

This app developed to deploy on Heroku in mind, but it may be deployed anywhere.

Configured [memcached](http://memcached.org/) (Heroku add-on) is strongly recommended!

## Nightly cron

User can subscribe via checkbox to receive nightly email reports. When nightly cron runs, user is sent a single email for each user they follow. That email contains the followed user's recent activity and cards.
For Heroku it feature required connect Heroku Sheduler add-on and configure run:
>rake reports:followers

every hour, it will send email at follower local time 1:00 AM.

Or daily at explicit time in your time zone if you wish:
> rake reports:followers[all]

Heroku Scheduler [details](https://devcenter.heroku.com/articles/scheduler).

## Demo

See [Live App](http://trello-track.herokuapp.com).

If you want to use it in the production, please deploy app in your instance.



