# swisscom-sms-api
Node module to send SMS via the Swisscom SMS API

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

# Installation
	npm install swisscom-sms-api

# Debugging
The Swisscom SMS API uses [debug](https://www.npmjs.org/package/debug) for logging. Just set the `DEBUG` environment variable to `swisscom-*`

* Example using CoffeeScript: `DEBUG=swisscom-* coffee example.coffee`
* Example using Javascript: `DEBUG=swisscom-* node example.js`
