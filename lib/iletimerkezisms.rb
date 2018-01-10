# encoding: utf-8

require File.expand_path('../iletimerkezisms/sms', __FILE__)
require File.expand_path('../iletimerkezisms/report', __FILE__)
require File.expand_path('../iletimerkezisms/request', __FILE__)

module IletimerkeziSMS
  # argv: {api_gateway: true, sender: "ILETI MRKZI", message: "Lorem Ipsum ...",
  #        numbers: ["905xxxxxxxxx"," +90 5xx xxx xx xx", "5xxxxxxxxx"]
  #   }
  # Varsayılan api_gateway false. 
  # ap_gateway true ise kpublic, ksecret ile authentication; false ise username, password
  def self.send(username, password, argv = {})
    argv = {
      api_gateway: false
    }.merge(argv)

    sms = SMS.new(username, password)

    if argv[:api_gateway]
      sms.send_via_gateway(argv)
    else
      sms.send_via_http(argv)
    end
    #sms.send(argv)
  end

  # argv: {sender: "ILETI MRKZI",
  #    messages: [
  #         {text: "Message_one", numbers: ["905xxxxxxxxx"," +90 5xx xxx xx xx", "5xxxxxxxxx"]},
  #         {text: "Message_two", numbers: ["905xxxxxxxxx"," +90 5xx xxx xx xx"]},
  #         {text: "Message_there", numbers: ["905xxxxxxxxx"]}
  #         ]
  #     }
  def self.multi_send(username, password, argv)
    argv = {
      api_gateway: false
    }.merge(argv)

    sms = SMS.new(username, password)

    if argv[:api_gateway]
      sms.multi_send_via_gateway(argv)
    else
      sms.multi_send_via_http(argv)
    end
  end

  def self.cancel(username, password, order_id, api_gateway = false)
    sms = SMS.new(username, password)
    if api_gateway
      sms.cancel_via_gateway(order_id)
    else
      sms.cancel_via_http(order_id)
    end
  end

  def self.balance(username, password, api_gateway = false)
    sms = REPORT.new(username, password)
    if api_gateway
      sms.balance_via_gateway
    else
      sms.balance_via_http
    end
  end

  # argv:
  def self.report(username, password, argv)
    argv = {
      api_gateway: false
    }.merge(argv)
    sms = REPORT.new(username, password)
    if argv[:api_gateway]
      sms.report_via_gateway(argv)
    else
      sms.report_via_http(argv)
    end
    #sms.report(argv)
  end
end
