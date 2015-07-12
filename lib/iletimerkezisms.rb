# encoding: utf-8

require File.expand_path('../iletimerkezisms/sms', __FILE__)
require File.expand_path('../iletimerkezisms/report', __FILE__)
require File.expand_path('../iletimerkezisms/request', __FILE__)

module IletimerkeziSMS
	# argv: {sender: "ILETI MRKZI", message: "Lorem Ipsum ...",
	# 		 	 numbers: ["905xxxxxxxxx"," +90 5xx xxx xx xx", "5xxxxxxxxx"]
	#		}
	def self.send(username, password, argv)
		sms = SMS.new(username, password)
		sms.send(argv)
	end

	# argv: {sender: "ILETI MRKZI",
	#	 	 messages: [
	#					{text: "Message_one", numbers: ["905xxxxxxxxx"," +90 5xx xxx xx xx", "5xxxxxxxxx"]},
	#					{text: "Message_two", numbers: ["905xxxxxxxxx"," +90 5xx xxx xx xx"]},
	#					{text: "Message_there", numbers: ["905xxxxxxxxx"]}
	#				  ]
	#   	}
	def self.multi_send(username, password, argv)
		sms = SMS.new(username, password)
		sms.multi_send(argv)
	end

	def self.cancel(username, password, order_id)
		sms = SMS.new(username, password)
		sms.cancel(order_id)
	end

	def self.balance(username, password)
		sms = REPORT.new(username, password)
		sms.balance
	end

	# argv:
	def self.report(username, password, argv)
		sms = REPORT.new(username, password)
		sms.report(argv)
	end
end
