require 'active_support'
require 'active_support/core_ext'
require 'net/http'
require 'json'
require 'spam_guardian/email_check'
require 'spam_guardian/ip_check'
require 'spam_guardian/client'
module SpamGuardian
  class Validator
    attr_reader :params, :spams, :response
    def initialize(object)
      @params = ParamsBuilder.new(object)
      @spams = []
    end

    def valid?
      validate!
      spams.count.zero?
    end

    def validate!
      return if @validated
      @response = Client.new.get(params)
      params.each_key do |key|
        case response[key]
        when Hash
          validate_response(response[key])
        when Array
          response[key].each do |hash|
            validate_response(hash)
          end
        end
      end
      @validated = true
    end

    def validate_response(response)
      unless response.fetch('frequency', 0).to_i.zero?
        spams << response.fetch('value', '')
      end
    end
  end
end
