# SCSMSAPI.coffee
#
# version 0.1.0
# author https://github.com/katunch
# based on https://developer.swisscom.com/documentation/api/sms-messaging-api
#
# takes the following config object
#
# config = 
# 	sender: '41791234567'
# 	clientId: 'YOUR-ACCESS-TOKEN'


https 			= require 'https'
debug			= require('debug')('swisscom-sms-api')
{EventEmitter}	= require 'events'
Util			= require 'util'
url 			= require 'url'

class SCSMSAPI
	constructor: (@config) ->
		EventEmitter.call @

	Util.inherits SCSMSAPI, EventEmitter

	sendSMS: (recipient, message) ->
		debug "sending sms '#{message}' to recipient #{recipient}"
		@_sendRequest @_buildMessageRequestBody(recipient, message)

	_buildMessageRequestBody: (recipient, message) ->
		debug "build message body with recipient: '#{recipient}, message: '#{message}"
		requestData =
			outboundSMSMessageRequest:
				address: ["tel:#{recipient}"]
				senderAddress: "tel:+#{@config.sender}"
				senderName: "+#{@config.sender}"
				outboundSMSTextMessage:
					message: message

	_endpointUrl: ->
		debug "creating endpointUrl"
		sender = escape "tel:+#{@config.sender}"
		endpointUrl = url.parse "https://api.swisscom.com/v1/messaging/sms/outbound/#{sender}/requests"

	_sendRequest: (messageRequest) ->
		debug "sending request"
		self = @
		endpointUrl = @_endpointUrl()
		options = 
			hostname: endpointUrl.hostname
			port: endpointUrl.port
			path: endpointUrl.path
			method: 'POST'
			headers:
				'Content-Type':'application/json; charset=utf-8'
				'client_id':@config.clientId

		debug "request options: ", JSON.stringify(options)

		req = https.request options, (res) ->
			debug 'STATUS: ', res.statusCode
			debug 'HEADERS: ', JSON.stringify(res.headers)

			res.setEncoding 'utf8'
			responseData = '';
			res.on 'data', (chunk) ->
				responseData += chunk

			res.on 'end', ->
				debug "request ended with response: ", responseData
				self.emit 'end', responseData

		req.on 'error', (error) ->
			debug "request error: ", error
			self.emit 'error', error

		req.write JSON.stringify(messageRequest)
		debug "sending content: ", JSON.stringify(messageRequest)
		req.end()


exports = module.exports = SCSMSAPI