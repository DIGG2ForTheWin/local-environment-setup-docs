# AS4 validation

## Who plays which role

There is no separate backend application in this lab. **The `curl` commands on each VM *are* the backend.** They call the local Domibus WS Plugin (`http://127.0.0.1:8080/domibus/services/wsplugin`) exactly as a real business application would, to submit, list and download messages. Domibus-to-Domibus traffic (the AS4 part) goes between the two MSH URLs on the VMnet3 network.

```text
curl on Blue --(WS Plugin SOAP)--> Blue Domibus ==(AS4 over 192.168.50.x)==> Red Domibus <--(WS Plugin SOAP)-- curl on Red
```

## Validation standard

The baseline required proof of backend submission, PMode matching, payload persistence, certificate selection, signing, encryption, remote delivery, receipt generation, sender reliability validation, sender/receiver state, pending-message listing and backend payload retrieval in both directions.

## WS Plugin WSDL

Blue downloaded:

```bash
curl -fsS \
  'http://127.0.0.1:8080/domibus/services/wsplugin?wsdl' \
  -o /home/xander/dl/wsplugin-blue.wsdl
```

Observed size:

```text
~46 KB
```

Target namespace:

```text
http://eu.domibus.wsplugin/
```

Binding:

```text
SOAP 1.2
```

## Operations observed

```text
submitMessage
retrieveMessage
getMessageErrorsWithAccessPointRole
listPendingMessages
markMessageAsDownloaded
rePushFailedMessages
getMessageErrors
getStatus
getStatusWithAccessPointRole
listPushFailedMessages
```

## Sample files

```text
~/dl/sample-config/conf/pmodes/domibus-gw-sample-pmode-blue.xml
~/dl/sample-config/conf/pmodes/domibus-gw-sample-pmode-red.xml
~/dl/sample-config/test/soapui/AS4-test-guide-soapui-project.xml
```

The sample project used `No Authorization` for WS Plugin requests.

## Why SoapUI itself was not used

The project XML was treated as a source of known-good request envelopes. Python `xml.etree.ElementTree` extracted those envelopes, avoiding a runtime dependency on SoapUI.

## Blue -> Red request

Vendor `sendMessage` fields:

```text
From PartyId: domibus-blue
From type: urn:oasis:names:tc:ebcore:partyid-type:unregistered
To PartyId: domibus-red
To type: urn:oasis:names:tc:ebcore:partyid-type:unregistered
Service: bdx:noprocess
Service type: tc1
Action: TC1Leg1
Payload href: cid:message
```

No unresolved `${...}` variables existed in this first request.

Extracted file:

```text
/home/xander/dl/blue-to-red-submit.xml
```

The XML was validated with ElementTree.

## Submit SOAP action

```text
http://eu.domibus.wsplugin/WebServicePluginInterface/submitMessage
```

## First curl failure

The first attempt used a mangled/escaped `~` path and did not send a request. Absolute paths were used afterward.

## Canonical Blue submission

```bash
curl -sS \
  -D /home/xander/dl/blue-to-red-response.headers \
  -o /home/xander/dl/blue-to-red-response.xml \
  -w '\nHTTP %{http_code}\n' \
  -H 'Content-Type: application/soap+xml; charset=UTF-8; action="http://eu.domibus.wsplugin/WebServicePluginInterface/submitMessage"' \
  --data-binary @/home/xander/dl/blue-to-red-submit.xml \
  http://127.0.0.1:8080/domibus/services/wsplugin
```

Result:

```text
HTTP 200
```

## Blue -> Red IDs

Message:

```text
331c0511-b145-11f1-98c5-000c29b65d5b@domibus.eu
```

Blue entity:

```text
887799183390676475
```

Red entity:

```text
887799205223657931
```

Conversation:

```text
332db852-b145-11f1-98c5-000c29b65d5b@domibus.eu
```

## Blue sender evidence

Logs showed, in sequence:

```text
blue_gw matched from domibus-blue
red_gw matched from domibus-red
testService1 matched bdx:noprocess/type tc1
tc1Action matched TC1Leg1
pushTestcase1tc1Action selected
MessageProfile validated
eDeliveryPropertySet validated
backendWSPlugin enabled
PAYLOAD_SUBMITTED
filesystem payload manager initialized
PAYLOAD_PROCESSED
59-byte payload saved
payload compressed
SEND_ENQUEUED
message submitted
submission SUCCESS
rsa security profile
red_gw selected for encryption
red_gw certificate valid
blue_gw selected for signing
blue_gw certificate valid
SOAP 1.2
reliability check SUCCESS
SEND_ENQUEUED -> ACKNOWLEDGED
MESSAGE_STATUS_CHANGE
MESSAGE_SEND_SUCCESS
payload data cleared
receipt received SUCCESS PUSH
message sent SUCCESS PUSH
```

Blue dashboard:

```text
ACKNOWLEDGED
```

## Red receiver evidence

Red logs showed:

```text
blue_gw sender matched
red_gw receiver matched
service/action/leg matched
incoming rsa profile
blue_gw/red_gw certificate lookup
message exchange configuration matched
receipt generated SUCCESS
nonRepudiation=true
PUSH processing
payload decompression-on-read configured
payload/profile validation
filesystem payload persistence
59-byte payload received
RECEIVED
MESSAGE_RECEIVED
WS Plugin delivery event
message persisted in DB
message received SUCCESS PUSH
signal response generated
MESSAGE_RESPONSE_SENT
```

Red dashboard:

```text
RECEIVED
```

## Red listPendingMessages

Vendor step:

```text
checkIfMessageIsAvailable
```

was extracted as:

```text
red-list-pending.xml
```

SOAP action:

```text
http://eu.domibus.wsplugin/WebServicePluginInterface/listPendingMessages
```

Response contained the exact message ID.

## Red retrieveMessage

Vendor step:

```text
downloadMessage
```

was extracted as:

```text
red-retrieve-message.xml
```

The first replacement attempt assumed `${messageID}`. Inspection showed the real placeholder was:

```text
${ResponseParameter#messageID}
```

That exact placeholder was replaced with the message ID.

SOAP action:

```text
http://eu.domibus.wsplugin/WebServicePluginInterface/retrieveMessage
```

## Retrieved Blue -> Red payload

Metadata:

```text
MessageId: 331c0511-b145-11f1-98c5-000c29b65d5b@domibus.eu
From: domibus-blue
To: domibus-red
Service: bdx:noprocess
Type: tc1
Action: TC1Leg1
PayloadId: cid:message
ContentType: text/xml
```

Filename:

```text
062db1df-aa6f-49a9-9623-edeb3f4b24a5.payload
```

Base64:

```text
PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPGhlbGxvPndvcmxkPC9oZWxsbz4=
```

Decoded:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<hello>world</hello>
```

## Reverse request

Vendor step:

```text
sendResponse
```

was extracted on Red. Verified fields:

```text
From domibus-red
To domibus-blue
Service bdx:noprocess
Type tc1
Action TC1Leg1
```

No unresolved SoapUI variables remained. XML validation passed.

## Red -> Blue submission

Result:

```text
HTTP 200
```

Message:

```text
f0209410-b146-11f1-a7a7-000c298c283d@domibus.eu
```

Red entity:

```text
887802313651713634
```

Blue entity:

```text
887802330217584117
```

Conversation:

```text
f021f3a1-b146-11f1-a7a7-000c298c283d@domibus.eu
```

## Red sender evidence

```text
red_gw sender match
blue_gw receiver match
service/action/leg match
payload valid
SEND_ENQUEUED
rsa profile
blue_gw encryption certificate
red_gw signing certificate
certificates valid
reliability check SUCCESS
SEND_ENQUEUED -> ACKNOWLEDGED
MESSAGE_SEND_SUCCESS
receipt SUCCESS
message sent SUCCESS PUSH
```

Red dashboard:

```text
ACKNOWLEDGED
```

## Blue receiver evidence

```text
red_gw -> blue_gw match
incoming rsa
certificates found
receipt generated SUCCESS
payload persisted
59 bytes
RECEIVED
MESSAGE_RECEIVED
WS Plugin notified
DB persistence
message received SUCCESS PUSH
signal response sent
```

Blue dashboard:

```text
RECEIVED
```

## Blue backend retrieval

Blue listed the reverse message as pending and retrieved it.

Filename:

```text
0cd9843c-2d64-4b9f-aa6d-ae5c8e3e7f03.payload
```

Decoded payload:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<hello>world</hello>
```

## Final proven path

```text
backend
-> WS Plugin
-> local Domibus
-> PMode match
-> persistence
-> signing
-> encryption
-> remote MSH
-> remote verification
-> remote persistence
-> receipt
-> sender reliability validation
-> ACKNOWLEDGED
-> RECEIVED
-> listPendingMessages
-> retrieveMessage
-> original payload recovered
```

The path was proven in both directions.

## Screenshot relationship to AS4 validation

This screenshot bundle mainly covers infrastructure, Domibus bring-up, PMode preparation and admin recovery immediately before the later bidirectional AS4 tests. It therefore supplies evidence for the prerequisites of the AS4 exchange—especially the PMode endpoints, certificates, WS Plugin availability and running Domibus process—but the later `ACKNOWLEDGED`/`RECEIVED` exchange logs were captured primarily as terminal text in the conversation rather than in this particular ZIP.

![PMode endpoints immediately before exchange testing](../assets/screenshots/20260915-213818.png)

![Domibus process/log state before message tests](../assets/screenshots/20260915-212944.png)

