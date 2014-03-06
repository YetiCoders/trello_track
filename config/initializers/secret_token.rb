# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
TrelloTrack::Application.config.secret_key_base = ENV['SECRET_TOKEN']
  'b994194a4cb016daebbaa76c844dfb73f8110873531f13811a9df2ca38200124b1b75ff389d8e91a7a727c430b529e14d149ec6855c06d41de4f0d69b6fdc362'
