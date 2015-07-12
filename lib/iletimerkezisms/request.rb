# encoding: utf-8

require 'rest-client'
require 'crack/xml'

module IletimerkeziSMS
  class REQUEST
    def initialize(path, params)
      @params = params
      @api_base_url = "http://api.iletimerkezi.com/v1/#{path}"
    end

    def request
      begin
        resource = RestClient::Resource.new(@api_base_url, timeout: 30, open_timeout: 30)
        response = resource.post @params, content_type: :xml, accept: :xml
      rescue RestClient::ExceptionWithResponse => err
        response = err.response
      end
      return Crack::XML.parse(response.body)["response"]
    end
  end
end
