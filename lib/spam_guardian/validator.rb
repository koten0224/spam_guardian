require 'active_support'
require 'active_support/core_ext'
require 'net/http'
require 'json'
require 'spam_guardian/email_check'
require 'spam_guardian/ip_check'
require 'spam_guardian/client'
module SpamGuardian
  Validator = Struct.new(:ip_or_email) do

    def valid?
      return unless ip_or_email.is_a?(String) && key.present?
      validate!
      @valid
    end

    def validate!
      return if @validated
      @response = Client.new.get(params)
      @valid = @response[key].fetch('frequency', 0).to_i.zero?
      @validated = true
    end

    def params
      { key => ip_or_email }
    end

    def key
      @key ||= begin
        if EmailCheck.new(ip_or_email).valid?
          'email'
        elsif IpCheck.new(ip_or_email).valid?
          'ip'
        else
          'username'
        end
      end
    end
  end
end
