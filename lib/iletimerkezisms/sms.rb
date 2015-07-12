# encoding: utf-8

require 'nokogiri'
require "iletimerkezisms/request"

module IletimerkeziSMS
	class SMS
		def initialize(username, password)
			@username = username
			@password = password
		end

		# Usage: sms = IletimerkeziSMS::SMS.new("5545967632","5173539")
		#        sms.send({sender: "ILETI MRKZI", message: "Lorem Ipsum ...",
		#				   				numbers: ["905xxxxxxxxx"," +90 5xx xxx xx xx", "5xxxxxxxxx"]})
		# Description: Single Message => Multi Number
		def send(argv)
			path = "send-sms"
			xml_build = Nokogiri::XML::Builder.new do |xlm|
				xlm.request {
					xlm.authentication {
						xlm.username @username
						xlm.password @password
					}
					xlm.order {
						xlm.sender argv[:sender]
						xlm.sendDateTime Time.now.strftime("%d/%m/%Y %H:%M")
						xlm.message {
							xlm.text argv[:message]
							xlm.receipents{
								argv[:numbers].each do |n|
									xlm.number n
								end
							}
						}
					}
				}
			end
			r = REQUEST.new(path,xml_build.to_xml)
			return r.request
		end

		# Usage: sms = IletimerkeziSMS::SMS.new("5545967632","5173539")
		#        sms.send({sender: "ILETI MRKZI",
		#				   					messages: [
		#							  			{text: "Message_one", numbers: ["905xxxxxxxxx"," +90 5xx xxx xx xx", "5xxxxxxxxx"]},
		#							  			{text: "Message_two", numbers: ["905xxxxxxxxx"," +90 5xx xxx xx xx"]},
		#							  			{text: "Message_there", numbers: ["905xxxxxxxxx"]}
		#							 			]
		# 				  			})
		# Description: Multi Message => Multi Number (Birden fazla farklı mesajı birden fazla farklı kişiye göndermeye yarar.)
		def multi_send(argv)
			path = "send-sms"
			xml_build = Nokogiri::XML::Builder.new do |xlm|
				xlm.request {
					xlm.authentication {
						xlm.username @username
						xlm.password @password
					}
					xlm.order {
						xlm.sender argv[:sender]
						xlm.sendDateTime Time.now.strftime("%d/%m/%Y %H:%M")
						argv[:messages].each do |message|
							xlm.message {
								xlm.text message[:text]
								xlm.receipents{
									message[:numbers].each do |n|
										xlm.number n
									end
								}
							}
						end
					}
				}
			end
			r = REQUEST.new(path,xml_build.to_xml)
			return r.request
		end

		# Usage: sms = IletimerkeziSMS::SMS.new("5545967632","5173539")
		#        sms.cancel("4152")
		# Description: Gönderilen sms paketini iptal etmeye yarar.
		def cancel(order_id)
			path = "cancel-order"
			xml_build = Nokogiri::XML::Builder.new do |xlm|
				xlm.request {
					xlm.authentication {
						xlm.username @username
						xlm.password @password
					}
					xlm.order {
						xlm.id order_id.to_s
					}
				}
			end
			r = REQUEST.new(path,xml_build.to_xml)
			return r.request
		end
	end
end
