# encoding: utf-8

require "iletimerkezisms/request"
require 'nokogiri'

module IletimerkeziSMS
  class REPORT
    def initialize(username, password)
      @username = username
      @password = password
    end

    def report(argv)
      argv = {
        page: 1,
        rowCount: 1000
        }.merge(argv)

      path = "get-report"

      xml_build = Nokogiri::XML::Builder.new do |xml|
        xml.request {
          xml.authentication {
            xml.username @username
            xml.password @password
          }
          xml.order{
            xml.id_ argv[:id]
            xml.page argv[:page]
            xml.rowCount argv[:rowCount]
          }
        }
      end
      r = REQUEST.new(path,xml_build.to_xml)
      return r.request
    end

    def balance
      path = "get-balance"
      xml_build = Nokogiri::XML::Builder.new do |xml|
        xml.request {
          xml.authentication {
            xml.username @username
            xml.password @password
          }
        }
      end
      r = REQUEST.new(path,xml_build.to_xml)
      return r.request
    end
  end
end
