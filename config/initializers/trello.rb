require 'trello'

if Rails.env.development? || Rails.env.test?
  module Trello
    class Client
      def invoke_verb_with_bench(*args)
        start = Time.now
        invoke_verb_without_bench(*args)
      ensure
        Rails.logger.info "[trello] #{args[0].to_s.upcase} #{args[1]} (#{((Time.now - start).to_f * 1000.0).to_i} msec)"
      end
      alias_method_chain :invoke_verb, :bench
    end
  end
end
