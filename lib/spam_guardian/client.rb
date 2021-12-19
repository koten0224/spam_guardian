require 'active_support'
require 'active_support/core_ext'
require 'net/http'
require 'json'
module SpamGuardian
  class Client
    class_attribute :base_url, default: "https://api.stopforumspam.org/api", instance_writer: false

    attr_reader :uri
    def initialize
      @uri = URI(base_url)
    end

    def get(params)
      uri.query = "json&" + URI.encode_www_form(params)
      JSON.parse(Net::HTTP.get(uri))
    end
  end
end