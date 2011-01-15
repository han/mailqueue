require 'stalker'

module MailQueue
  class Beanstalk
    
    def initialize(options = {})
      self.settings = {
        :pri => 65536,
        :delay => 0,
        :ttr => 120,
        :tube => 'email.send'
      }.merge!(options)
    end
    
    attr_accessor :settings

    
    def deliver!(mail)
      # render mail and push onto queue
      envelope_from = mail.return_path || mail.sender || mail.from_addrs.first
      if envelope_from.blank?
        raise ArgumentError.new('A sender (Return-Path, Sender or From) is required to send a message') 
      end
      
      destinations ||= mail.destinations if mail.respond_to?(:destinations) && mail.destinations
      if destinations.blank?
        raise ArgumentError.new('At least one recipient (To, Cc or Bcc) is required to send a message') 
      end

      message ||= mail.encoded if mail.respond_to?(:encoded)
      if message.blank?
        raise ArgumentError.new('Encoded content is required to send a message')
      end

      envelope = {
        :from => envelope_from,
        :destinations => destinations,
        :message => message
      }
      
      Stalker.enqueue(settings[:tube], envelope, settings)

      self
    end
    
  end
end