class UserMailer < ActionMailer::Base
  helper [:application, :members]

  default from: ENV['DEVELOPERS_EMAIL'].split(',').first

  default content_type: 'text/html',
          charset: 'utf-8'

  def no_action_email(action_hash)
    mail(to: ENV['DEVELOPERS_EMAIL'], subject: 'Trello Track: No action translation', body: action_hash.inspect).deliver
  end

  def followers_report(email, options = {})
    @members_info = options[:members_info]
    @card_boards = options[:card_boards]
    @card_lists = options[:card_lists]
    @members = options[:members]

    subject = I18n.t('user_mailer.subjects.followers_report')
    mail( to: email, subject: subject ).deliver
  end
end
