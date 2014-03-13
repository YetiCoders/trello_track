class UserMailer < ActionMailer::Base
  default from: ENV['DEVELOPERS_EMAIL'].split(',').first

  default content_type: 'text/html',
          charset: 'utf-8'

  def no_action_email(action_hash)
    mail(to: ENV['DEVELOPERS_EMAIL'], subject: 'Trello Track: No action translation', body: action_hash.inspect).deliver
  end
end
