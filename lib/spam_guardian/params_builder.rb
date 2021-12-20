require 'active_support'
require 'active_support/core_ext'
require 'spam_guardian/email_check'
require 'spam_guardian/ip_check'
require 'spam_guardian/value_check'
module SpamGuardian
  class ParamsBuilder < ActiveSupport::HashWithIndifferentAccess
    # Support string
    # support nth array 
    # Support nth array of string
    # Support nth array of hash of string
    # Support nth array of hash of array
    # Support hash of string
    # Support hash of array of string
    ALLOWED_KEYS = %i(email ip username).freeze
    attr_reader :temp_params
    def initialize(params={})
      super Hash.new { |hash, key| hash[key] = [] }
      case params
      when String
        self[parse_key(params)] << params
      when Array
        parse_array(params)
      when Hash
        parse_hash(params)
      else
        raise FormatError.new("Invalid format.")
      end
    end

    private
    def validate_hash_keys!(hash)
      hash.each_key do |key|
        raise FormatError.new("#{key}: invalid key.") unless key.to_sym.in?(ALLOWED_KEYS)
      end
    end

    def parse_key(string)
      if EmailCheck.new(string).valid?
        'email'
      elsif IpCheck.new(string).valid?
        'ip'
      else
        'username'
      end
    end

    def parse_array(array)
      array.flatten.each do |value|
        case value
        when String
          self[parse_key(value)] << value
        when Hash
          parse_hash(value)
        else
          raise FormatError.new("Invalid format.")
        end
      end
    end

    def parse_hash(hash)
      validate_hash_keys!(hash)
      hash.each do |key, value|
        case value
        when String
          self[key] << value
        when Array
          raise FormatError.new("Invalid format.") unless ValueCheck.new(Array).sub_class(String).check(value)
          self[key].concat(value)
        else
          raise FormatError.new("Invalid format.")
        end
      end
    end
  end
end