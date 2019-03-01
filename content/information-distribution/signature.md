---
title: "Signature"
weight: 4
---

Informo relies on cryptographic signatures in order to verify the integrity of
data shared across the federation. These signatures are generated using
asymmetric cryptography keys (`ed25519`, `hmac-sha256`, `hmac-sha512`, etc.),
which private key solely owned by the end user.


## Signed Matrix event

### Event data

Informo signed events are built using a common structure, inspired from [Matrix
`m.room.encrypted`
events](https://matrix.org/docs/spec/client_server/r0.4.0.html#m-room-encrypted):

|    Field     |      Type      |                                    Description                                     |
|--------------|----------------|------------------------------------------------------------------------------------|
| `algorithm`  | `string`       | Algorithm used for signing the content. 🔧 Define allowed algorithms               |
| `sender_key` | `string`       | The public part of the key used for signing the event                              |
| `device_id`  | `string`       | 🔧 Optional, ID of the sending device, may be used for Megolm                      |
| `session_id` | `string`       | 🔧 Optional, ID of the session used to encrypt the message, may be used for Megolm |
| `signature`  | `string`       | Generated signature                                                                |
| `signed`     | `SignedObject` | Object to be signed                                                                |

Where:

* `SignedObject` is a map using the following structure:

| Parameter          |       Type       | Req. |              Description               |
|:-------------------|:-----------------|:----:|:---------------------------------------|
| `signatory`        | `string`         |  x   | The matrix user ID of the sender.      |
| `content`          | `object`         |  x   | The content of the event to be signed. |

If the value of the `signatory` field does not match the user ID sending the
signed Matrix event, then the signature **must** be considered as invalid.

<!-- 🔧: Need to do some research on Megolm and Matrix APIs around encryption and key
management -->

Example:

```json
{
    "content": {
        "algorithm": "ed25519",
        "sender_key": "IlRMeOPX2e0MurIyfWEucYBRVOEEUMrOHqn/8mLqMjA",
        "signature": "0a1df56f1c3ab5b1",
        "signed": {
            "signatory": "@acmenews:example.com",
            "content": {
                // Event signed JSON data
            }
        }
    }
}
```

### Signing JSON data

Signing JSON data require some additional steps since the same JSON data can be
serialized in many different ways.

JSON objects are generally represented as hash maps, causing object content to
be ordered by their hash value, which can vary a lot between platforms and
implementations. JSON data can also contain an arbitrary number of whitespaces
as separators.

In order to produce consistent JSON strings, clients **must** convert the JSON
data into a [Canonical JSON
string](https://matrix.org/docs/spec/appendices.html#canonical-json), before
signing it and setting the event's `content.signature` field.
