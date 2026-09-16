# Glossary

**Access Point** — A gateway participating in eDelivery/AS4 communication. Blue and Red are the two Access Points in this lab.

**ACKNOWLEDGED** — Sender-side state indicating the expected AS4 receipt was received and validated.

**AS4** — A standardized profile of ebMS3 for secure/reliable B2B messaging.

**Backend** — The application side that submits messages to Domibus or retrieves received messages.

**ConversationId** — Identifier used to associate related messages with a business conversation.

**Domibus** — The AS4/eDelivery gateway software used in this lab.

**ebMS3** — ebXML Messaging Services version 3, the basis for AS4.

**eDelivery** — An interoperability building block/model for secure document exchange through compatible access points.

**JDBC** — Java Database Connectivity. Domibus uses JDBC to connect to MySQL.

**JKS** — Java KeyStore format used by the baseline keystore/truststore.

**Keystore** — Store containing local private-key/certificate material.

**MessageEntityID** — Domibus internal entity/database ID associated with a message.

**MessageId** — AS4 message identifier used for end-to-end tracing.

**MSH** — Message Service Handler, the AS4-facing Domibus endpoint.

**PMode** — Processing Mode, the policy/configuration describing how a message class should be exchanged.

**Payload** — The actual business content transported by AS4.

**RECEIVED** — Receiver-side Domibus state indicating an inbound UserMessage was accepted/persisted.

**Receipt** — AS4 SignalMessage returned by the receiver to acknowledge processing according to the profile.

**SEND_ENQUEUED** — Sender-side state indicating backend submission was accepted and queued.

**SOAP** — XML messaging protocol used by the WS Plugin and AS4 envelopes.

**Truststore** — Store containing certificates trusted for remote parties.

**WS Plugin** — Domibus backend-facing SOAP interface used in this lab for submission/retrieval.

## Visual examples

![Domibus Administration Console](assets/screenshots/20260915-211602.png)

![PMode XML](assets/screenshots/20260915-213325.png)

![Keystore/truststore](assets/screenshots/20260915-213142.png)

