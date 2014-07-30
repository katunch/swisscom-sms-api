# SCSMSAPI.coffee
#
# version 0.2.0
# author https://github.com/katunch
# based on https://developer.swisscom.com/documentation/api/sms-messaging-api
#
# takes the following config object
#
# config = 
# 	sender: '+41791234567'
# 	clientId: 'PLACE-YOUR-CONSUMER-KEY-HERE'


https 			= require 'https'
debug			= require('debug')('swisscom-sms-api')
{EventEmitter}	= require 'events'
Util			= require 'util'
url 			= require 'url'
async			= require 'async'

class SCSMSAPI
	constructor: (@config) ->
		EventEmitter.call @

	Util.inherits SCSMSAPI, EventEmitter

	send: (recipient, message) ->
		debug "sending sms '#{message}' to recipient #{recipient}"
		tasks = [
					(callback) =>
						@_sendRequest @_buildMessageRequestBody(recipient, message), callback
				]

		async.parallel tasks, (error, results) => 
			if error is not null
				@emit 'error', error
			else
			 	@emit 'sent'


	_buildMessageRequestBody: (recipient, message) ->
		debug "build message body with recipient: '#{recipient}, message: '#{message}"
		requestData =
			outboundSMSMessageRequest:
				address: ["tel:#{recipient}"]
				senderAddress: "tel:#{@config.sender}"
				senderName: "#{@config.sender}"
				outboundSMSTextMessage:
					message: message

	_endpointUrl: ->
		debug "creating endpointUrl"
		sender = escape "tel:#{@config.sender}"
		endpointUrl = url.parse "https://api.swisscom.com/v1/messaging/sms/outbound/#{sender}/requests"

	_sendRequest: (messageRequest, cb) ->
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
				self._parseDeliveryInfo responseData
				cb?(null)

		req.on 'error', (error) ->
			debug "request error: ", error
			self.emit 'error', error
			cb?(error,null)

		req.write JSON.stringify(messageRequest)
		debug "sending content: ", JSON.stringify(messageRequest)
		req.end()

	_parseDeliveryInfo: (response) ->
		responseObject = JSON.parse response
		deliveryInfo = responseObject['outboundSMSMessageRequest']['deliveryInfoList']['deliveryInfo']
		debug 'deliveryInfo', deliveryInfo

		@_emitDeliveryStatus deliveryStatus for deliveryStatus in deliveryInfo

	_emitDeliveryStatus: (deliveryStatus) ->
		@emit 'deliveryStatus', deliveryStatus
		

exports = module.exports = SCSMSAPI