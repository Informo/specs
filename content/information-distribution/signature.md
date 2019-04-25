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

|    Field     |      Type      |     Description     |
|--------------|----------------|---------------------|
| `signature`  | `string`       | Generated signature |
| `signed`     | `SignedObject` | Object to be signed |

Where:

* `SignedObject` is a map using the following structure:

| Parameter       |       Type       | Req. |                                                  Description                                                  |
|:----------------|:-----------------|:----:|:--------------------------------------------------------------------------------------------------------------|
| `sender`        | `string`         |  x   | User who sent the event. **Must** match the Matrix user ID of who sent the event.                             |
| `room_id`       | `string`         |  x   | Associated room ID. **Must** match the room ID where the event has been sent.                                 |
| `state_key`     | `string`         |  !   | State key of the event. Required if the event is a state event.                                               |
| `signatory`     | `string`         |      | The Matrix user ID who signed this data. If not present, defaults to the value defined in the `sender` field. |
| `signatory_key` | `string`         |  x   | The public part of the key used for signing the event.                                                        |
| `algorithm`     | `string`         |  x   | Algorithm used for signing the content.                                                                       |
| `content`       | `object`         |  x   | The content of the event to be signed.                                                                        |

If the value of the `sender` field does not match the user ID sending the signed
Matrix event, or if the `room_id` does not match the room where the event is
sent, then the signature **must** be considered as invalid.

Example:

```json
{
    "content": {
        "signature": "0a1df56f1c3ab5b1",
        "signed": {
            "sender": "@acmenews:example.com",
            "room_id": "!LppXGlMuWgaYNuljUr:example.com",
            "signatory": "@acmenews:example.com", // can be omitted
            "signatory_key": "IlRMeOPX2e0MurIyfWEucYBRVOEEUMrOHqn/8mLqMjA",
            "algorithm": "ed25519",
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
