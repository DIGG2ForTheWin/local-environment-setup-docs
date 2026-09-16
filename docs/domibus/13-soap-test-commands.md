# SOAP test commands

This chapter records the exact style of commands used to avoid inventing SOAP requests.

## Sample project path

```text
/home/xander/dl/sample-config/test/soapui/AS4-test-guide-soapui-project.xml
```

## Extract first Blue -> Red sendMessage request

The project was parsed with Python/ElementTree. The first request body associated with a `sendMessage` test step and containing a SOAP envelope was written to a standalone XML file.

The extracted file used in the successful test was:

```text
/home/xander/dl/blue-to-red-submit.xml
```

Before sending, the XML was parsed with ElementTree to verify it was well formed and searched for `${...}` placeholders.

## Blue -> Red submit

```bash
curl -sS \
  -D /home/xander/dl/blue-to-red-response.headers \
  -o /home/xander/dl/blue-to-red-response.xml \
  -w '\nHTTP %{http_code}\n' \
  -H 'Content-Type: application/soap+xml; charset=UTF-8; action="http://eu.domibus.wsplugin/WebServicePluginInterface/submitMessage"' \
  --data-binary @/home/xander/dl/blue-to-red-submit.xml \
  http://127.0.0.1:8080/domibus/services/wsplugin
```

Expected successful response shape:

```xml
<submitResponse>
  <messageID>...</messageID>
  <messageEntityID>...</messageEntityID>
</submitResponse>
```

Observed first values:

```text
MessageId: 331c0511-b145-11f1-98c5-000c29b65d5b@domibus.eu
MessageEntityID: 887799183390676475
```

## Extract pending/retrieve vendor requests

The exact approach used on Red was:

```bash
cd /home/xander/dl

python3 - <<'PY'
import xml.etree.ElementTree as ET

src = "/home/xander/dl/sample-config/test/soapui/AS4-test-guide-soapui-project.xml"
root = ET.parse(src).getroot()

wanted = {
    "checkIfMessageIsAvailable": "/home/xander/dl/red-list-pending.xml",
    "downloadMessage": "/home/xander/dl/red-retrieve-message.xml",
}

found = set()

for step in root.iter():
    name = step.get("name")
    if name not in wanted or name in found:
        continue

    for elem in step.iter():
        if elem.tag.endswith("request") and elem.text and "<soap:Envelope" in elem.text:
            with open(wanted[name], "w", encoding="utf-8") as f:
                f.write(elem.text.strip() + "\n")
            print(f"[PASS] Extracted {name} -> {wanted[name]}")
            found.add(name)
            break

for name in wanted:
    if name not in found:
        print(f"[FAIL] Could not find {name}")
PY
```

## Inspect SoapUI variables

```bash
grep -n '\${' /home/xander/dl/red-list-pending.xml || echo '[PASS] No variables'
grep -n '\${' /home/xander/dl/red-retrieve-message.xml || echo '[PASS] No variables'
```

The retrieve request contained:

```text
${ResponseParameter#messageID}
```

not `${messageID}`.

## Insert real MessageId

The successful pattern was:

```bash
MID='331c0511-b145-11f1-98c5-000c29b65d5b@domibus.eu'

python3 - <<PY
p = "/home/xander/dl/red-retrieve-message.xml"

with open(p, "r", encoding="utf-8") as f:
    s = f.read()

old = '\${ResponseParameter#messageID}'
new = "$MID"

if old not in s:
    raise SystemExit("[FAIL] Placeholder not found")

s = s.replace(old, new)

with open(p, "w", encoding="utf-8") as f:
    f.write(s)

print("[PASS] Message ID inserted")
PY
```

## Red listPendingMessages

```bash
curl -sS \
  -D /home/xander/dl/red-list-pending.headers \
  -o /home/xander/dl/red-list-pending-response.xml \
  -w '\nHTTP %{http_code}\n' \
  -H 'Content-Type: application/soap+xml; charset=UTF-8; action="http://eu.domibus.wsplugin/WebServicePluginInterface/listPendingMessages"' \
  --data-binary @/home/xander/dl/red-list-pending.xml \
  http://127.0.0.1:8080/domibus/services/wsplugin
```

Observed response contained the exact first MessageId.

## Red retrieveMessage

```bash
curl -sS \
  -D /home/xander/dl/red-retrieve.headers \
  -o /home/xander/dl/red-retrieve-response.xml \
  -w '\nHTTP %{http_code}\n' \
  -H 'Content-Type: application/soap+xml; charset=UTF-8; action="http://eu.domibus.wsplugin/WebServicePluginInterface/retrieveMessage"' \
  --data-binary @/home/xander/dl/red-retrieve-message.xml \
  http://127.0.0.1:8080/domibus/services/wsplugin
```

## Reverse request extraction

The reverse request came from the vendor `sendResponse` test step.

The resulting file was:

```text
/home/xander/dl/red-to-blue-submit.xml
```

It was checked for:

```text
PartyId
Service
Action
AgreementRef
Role
RefToMessageId
PartInfo
PayloadInfo
Body
```

Verified routing:

```text
From domibus-red
To domibus-blue
Service bdx:noprocess
Service type tc1
Action TC1Leg1
```

No unresolved `${...}` variables remained. ElementTree parsing succeeded.

## Red -> Blue submit

```bash
curl -sS \
  -D /home/xander/dl/red-to-blue-response.headers \
  -o /home/xander/dl/red-to-blue-response.xml \
  -w '\nHTTP %{http_code}\n' \
  -H 'Content-Type: application/soap+xml; charset=UTF-8; action="http://eu.domibus.wsplugin/WebServicePluginInterface/submitMessage"' \
  --data-binary @/home/xander/dl/red-to-blue-submit.xml \
  http://127.0.0.1:8080/domibus/services/wsplugin
```

Observed:

```text
HTTP 200
MessageId f0209410-b146-11f1-a7a7-000c298c283d@domibus.eu
MessageEntityID 887802313651713634
```

## Blue retrieval of reverse message

The same pending/retrieve vendor requests were extracted on Blue, the reverse MessageId was substituted into the retrieve request, and Blue returned the original payload.

## Message trace commands

Blue sender or receiver:

```bash
MID='<MESSAGE_ID>'
echo '=== MESSAGE TRACE ==='
sudo grep -F "$MID" /opt/domibus/logs/domibus.log | tail -100
```

Fallback across rotated files:

```bash
sudo grep -RFn "$MID" /opt/domibus/logs 2>/dev/null | tail -100
```

## Decode retrieval value

```bash
python3 - <<'PY'
import base64
import xml.etree.ElementTree as ET

p = "/home/xander/dl/red-retrieve-response.xml"
root = ET.parse(p).getroot()

for elem in root.iter():
    if elem.tag.endswith("value") and elem.text:
        print(base64.b64decode(elem.text).decode("utf-8"))
PY
```

The output was the original XML payload.

## Screenshot relationship to SOAP tests

The screenshot archive contains the sample-package inventory that established the exact SoapUI project source used later for request extraction. The actual `submitMessage`, `listPendingMessages` and `retrieveMessage` terminal exchanges happened later and are preserved in the text transcript rather than this screenshot ZIP.

![Sample ZIP containing AS4-test-guide-soapui-project.xml](../assets/screenshots/20260915-205643.png)

*This is the vendor project from which the later WS Plugin request envelopes were extracted.*

