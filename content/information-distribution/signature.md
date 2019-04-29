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

|    Field     |      Type      |                                                                 Description                                                                 |
|--------------|----------------|---------------------------------------------------------------------------------------------------------------------------------------------|
| `signature`  | `string`       | Signature generated from `signed` using the private key from the same pair as the public key announced in `signed`'s `signatory_key` field. |
| `signed`     | `SignedObject` | Object to be signed.                                                                                                                        |

Where:

* `SignedObject` is a map using the following structure:

| Parameter       |       Type       | Req. |                                                        Description                                                         |
|:----------------|:-----------------|:----:|:---------------------------------------------------------------------------------------------------------------------------|
| `sender`        | `string`         |  x   | User who sent the event. **Must** match the `sender` field of the original Matrix Event.                                   |
| `room_id`       | `string`         |  x   | Associated room ID. **Must** match the `room_id` field of the original Matrix Event.                                       |
| `type`          | `string`         |  x   | Type of the Matrix event. **Must** match `type` field of the original Matrix Event.                                        |
| `state_key`     | `string`         |  !   | State key of the event. **Must** match the `state_key` field of the original Matrix Event. Only required for state events. |
| `signatory`     | `string`         |      | The Matrix user ID who signed this data. If not present, defaults to the value defined in the `sender` field.              |
| `signatory_key` | `string`         |  x   | The public part of the key pair used for signing the event.                                                                |
| `algorithm`     | `string`         |  x   | Algorithm used for signing the content.                                                                                    |
| `content`       | `object`         |  x   | The content of the event to be signed.                                                                                     |

If the value of any field referring to a field of the original Matrix event
doesn't match, then the signature **must** be considered as invalid.

Example:

```json
{
    "content": {
        "signature": "0a1df56f1c3ab5b1",
        "signed": {
            "sender": "@acmenews:example.com",
            "room_id": "!LppXGlMuWgaYNuljUr:example.com",
            "type": "network.informo.article",
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
