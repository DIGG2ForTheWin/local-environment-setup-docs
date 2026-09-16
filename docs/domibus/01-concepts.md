# Concepts

## Why this stack exists

Organizations often need to exchange business documents across organizational boundaries with stronger guarantees than ordinary HTTP gives them by itself. Typical requirements include sender identity, message integrity, encryption, receipts, unique message identifiers, retry behavior, deterministic routing and auditable state.

This is the problem space addressed by eDelivery, ebMS3, AS4 and Domibus.

## Domibus

Domibus is an implementation of the eDelivery AS4 messaging model. A Domibus installation acts as a messaging gateway, usually called an **Access Point**.

A backend application submits a business message to Domibus. Domibus then performs the messaging work:

1. validate the request against a PMode;
2. persist the message;
3. sign the AS4 message;
4. encrypt it for the remote gateway;
5. send it to the remote MSH;
6. let the remote gateway verify and decrypt it;
7. persist the payload on the remote side;
8. generate an AS4 receipt;
9. process that receipt on the sender;
10. update the sender to `ACKNOWLEDGED`;
11. expose the received message to the receiving backend;
12. allow the backend to retrieve the original payload.

This exact end-to-end flow was proven in both directions in the lab.

## eDelivery

eDelivery is an interoperability model/building block for secure electronic document exchange through compatible access points.

## ebMS3

ebMS3 means **ebXML Messaging Services version 3**. AS4 is a practical profile of ebMS3.

## AS4

AS4 is a SOAP-based B2B messaging profile. In this lab the important features are:

- SOAP 1.2;
- a unique `MessageId`;
- sender and receiver `PartyId` values;
- service and action routing;
- payload metadata;
- message signing;
- message encryption;
- receipts;
- reliability checks;
- PUSH processing.

## Access Point

An Access Point is an AS4 gateway. This lab contains two:

```text
Blue
Red
```

Each has its own VM, Domibus instance, MySQL DB, private key, payload store, PMode and service lifecycle.

## MSH

MSH means **Message Service Handler**. It is the AS4-facing endpoint one Domibus instance uses to communicate with another.

Blue:

```text
http://192.168.50.10:8080/domibus/services/msh
```

Red:

```text
http://192.168.50.20:8080/domibus/services/msh
```

A GET returning HTTP 200 is only a reachability check; real AS4 success requires an actual message and receipt.

## Backend

The backend is the application side of the gateway. In production it could be an ERP, document platform, integration service or custom application.

In this lab the backend role was simulated with direct SOAP calls to the Domibus WS Plugin using `curl`.

## WS Plugin

The WS Plugin is Domibus's backend-facing SOAP interface.

Endpoint:

```text
http://127.0.0.1:8080/domibus/services/wsplugin
```

WSDL:

```text
http://127.0.0.1:8080/domibus/services/wsplugin?wsdl
```

Observed operations:

- `submitMessage`
- `retrieveMessage`
- `listPendingMessages`
- `getStatus`
- `getStatusWithAccessPointRole`
- `getMessageErrors`
- `getMessageErrorsWithAccessPointRole`
- `markMessageAsDownloaded`
- `listPushFailedMessages`
- `rePushFailedMessages`

The vendor sample project used `No Authorization` for these WS Plugin calls.

## PMode

PMode means **Processing Mode**. It tells Domibus how a class of AS4 messages should be exchanged.

It captures items such as:

- sender;
- receiver;
- endpoint;
- service;
- action;
- security profile;
- certificate choice;
- PUSH/PULL behavior;
- payload profile;
- reliability behavior.

The working sample request used:

```text
Service: bdx:noprocess
Service type: tc1
Action: TC1Leg1
```

Domibus mapped these to internal PMode objects:

```text
service: testService1
action: tc1Action
leg: pushTestcase1tc1Action
```

## Party IDs versus PMode party names

The SOAP requests used vendor PartyIds:

```text
domibus-blue
domibus-red
```

The local PMode party names were:

```text
blue_gw
red_gw
```

Live logs proved the mapping. Blue-to-Red logs contained:

```text
Sender Party id [blue_gw] found for value [domibus-blue]
Receiver Party id [red_gw] found for value [domibus-red]
```

The reverse message showed the mirror mapping.

## MessageId

The AS4 `MessageId` is the primary trace value for a message across both gateways.

Both proven messages and their IDs are listed in [Raw observed values](20-raw-values.md#blue-red-message).

## MessageEntityID

Domibus also assigns an internal database entity ID to each message on each gateway. It is different from the AS4 `MessageId`, and the same message has a different entity ID on the sender and on the receiver.

## ConversationId

Groups related messages into one business conversation. In this lab each test message started its own conversation.

## Payload

Validated payload:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<hello>world</hello>
```

Observed metadata:

```text
CID: cid:message
Content-Type: text/xml
Size: 59 bytes
```

## Receipt

The receiver generates an AS4 SignalMessage receipt. The lab logs showed:

```text
Message receipt generated [SUCCESS] with nonRepudiation value [true]
```

The sender then logged:

```text
Reliability check was successful
Message receipt received [SUCCESS] [PUSH]
```

and the outgoing status became:

```text
ACKNOWLEDGED
```

## Important message states

### SEND_ENQUEUED

The local Domibus accepted the backend submission and queued it for sending.

### ACKNOWLEDGED

The sender received and validated the expected AS4 receipt.

### RECEIVED

The receiving Domibus accepted and persisted the inbound UserMessage.

### Pending for backend

The WS Plugin can return the received message through `listPendingMessages` until the backend consumes it.

### Retrieved

`retrieveMessage` returns the actual message metadata and payload to the backend.

## Why backend retrieval was required

`ACKNOWLEDGED` proves sender-side transport/receipt success. `RECEIVED` proves receiver-side persistence. `retrieveMessage` proves the business content can actually be consumed. All three were required for the final baseline.

## Screenshot-derived context

The screenshots show the conceptual layers in their real implementation rather than only as definitions: VMware creates the isolated transport network, Domibus runs inside Tomcat, MySQL stores message metadata, JKS files provide cryptographic identity, and PMode XML maps parties/services/actions to endpoints. The Admin Console screenshot also shows the operator-facing Domibus web application used to inspect and manage the gateway.

### Screenshot evidence

![Domibus Administration Console login page](../assets/screenshots/20260915-211602.png)

*The Domibus Administration Console exposed by the Blue gateway.*

![Blue PMode endpoint verification](../assets/screenshots/20260915-213818.png)

*The real PMode being checked for Blue/Red MSH endpoint values and XML well-formedness.*

