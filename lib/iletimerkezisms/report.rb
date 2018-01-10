# encoding: utf-8

require "iletimerkezisms/request"
require 'nokogiri'

module IletimerkeziSMS
  class REPORT
    def initialize(username, password)
      @username = username
      @password = password
    end

    def report_via_http(argv)
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

    def report_via_gateway(argv)
      argv = {
        page: 1,
        rowCount: 1000
        }.merge(argv)

        path = "get-report"

        digest = OpenSSL::Digest.new('sha256')
        hcmac = OpenSSL::HMAC.hexdigest(digest, @password, @username)

        xml_build = Nokogiri::XML::Builder.new do |xml|
          xml.request {
            xml.authentication {
              xlm.key @username
              xlm.hash_ hcmac
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

    def balance_via_http
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

    def balance_via_gateway
      digest = OpenSSL::Digest.new('sha256')
      hcmac = OpenSSL::HMAC.hexdigest(digest, @password, @username)
      path = "get-balance"
      xml_build = Nokogiri::XML::Builder.new do |xlm|
        xlm.request {
          xlm.authentication {
            xlm.key @username
            xlm.hash_ hcmac
          }
        }
      end
      r = REQUEST.new(path,xml_build.to_xml)
      return r.request
    end
  end
end
