== README

This app is to allow one Trello user to "follow" another trello user and see their cards and activity which are all publicly available via the Trello API. Additionaly the user can subscribe to receive a nightly report of the users cards and activities the day before.
This app developed to deploy on Heroku in mind. But, it may be deployed anywhere.

And a nightly cron:
User can subscribe via checkbox to receive nightly email reports. When nightly cron runs, user is sent a single email for each user they follow. That email contains the followed user's recent activity and cards.
For Heroku it feature required connect Heroku Sheduler add-on and configure run

```
rake reports:followers
```
every hour, it will send email at follower local time 1:00 AM.

Or daily at explicit time in your time zone if you wish:

```
rake reports:followers:all
```
See details: https://devcenter.heroku.com/articles/scheduler



