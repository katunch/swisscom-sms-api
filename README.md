# swisscom-sms-api
Node module to send SMS via the [Swisscom SMS API](https://developer.swisscom.com/documentation/api/sms-messaging-api).

# Swisscom Developer Account
1. Register on the [Swisscom Developer Portal](https://developer.swisscom.ch).
2. Generate your API key [here](https://developer.swisscom.com/api/keys).

# Usage (CoffeeScript)

```coffee-script
#
# example.coffee
#

SMSApi 		= require 'swisscom-sms-api'

config = 
	smsApi:
		sender: '+41791234567'
		clientId: 'YOUR-CONSUMER-KEY-HERE'

sms = 
	recipient: '+41791234567'
	messageText: 'hello world'

gateway = new SMSApi config.smsApi

gateway.on 'sent', ()->
	console.log 'all messages sent'

gateway.on 'error', (error) ->
	console.log 'an error occurred: ', error

gateway.on 'deliveryStatus', (status) ->
	consoloe log 'this is a status for each recipient', status

gateway.send sms.recipient, sms.messageText

```
Run `coffee example.coffee` from your command line.

# Usage (Javascript)
```javascript
//
// example.js
//
var SMSApi, config, gateway, sms;

SMSApi = require('swisscom-sms-api');

config = {
  smsApi: {
    sender: '+41791234567',
    clientId: 'YOUR-CONSUMER-KEY-HERE'
  }
};

sms = {
  recipient: '+41791234567',
  messageText: 'hello world'
};

gateway = new SMSApi(config.smsApi);

gateway.on('sent', function() {
  return console.log('all messages sent');
});

gateway.on('error', function(error) {
  return console.log('an error occurred: ', error);
});

gateway.on('deliveryStatus', function(status) {
  return console.log('deliveryStatus: ', status);
});

gateway.send(sms.recipient, sms.messageText);

```
Run `node example.js` from your command line.

#Delivery Status
Please refer to the [API Documentation](https://developer.swisscom.com/documentation/api/sms-messaging-api).
There are two known delivery status which the service returns:

1. *DeliveredToNetwork* - means the sms is deliverd to the mobile network and will be delivered to the recipient as soon as possible.
2. *DeliveryImpossible* - means the delivery to the mobile network is not possible. An unknown recipient number can be a reason.

# Installation
	npm install swisscom-sms-api

# Debugging
The Swisscom SMS API uses [debug](https://www.npmjs.org/package/debug) for logging. Just set the `DEBUG` environment variable to `swisscom-*`

* Example using CoffeeScript: `DEBUG=swisscom-* coffee example.coffee`
* Example using Javascript: `DEBUG=swisscom-* node example.js`

# Issues
* [Sender number is displayed incorrectly](https://github.com/katunch/swisscom-sms-api/issues/1) - This is an API issue and not the fault of the node module.

