# Voice Calls v2 - Customer App Complete Plan

## Latest backend clarification — overrides older display/source guidance

This section is authoritative for the new display endpoint and clarified integration values. No separate backend attachment is required to implement these items.

### Call display data

- Use `GET /api/v2/voice-calls/{callId}/display` with JWT and `Accept-Language: ar|en`. Voice-device headers are not required.
- Only call participants are authorized. Other callers receive generic 404; do not interpret it as permission to try another endpoint.
- Response JSON fields:

```json
{
  "callId": "<uuid>",
  "tripStopId": "<uuid>",
  "driverName": "<string>",
  "driverImageUrl": "<relative URL or null>",
  "driverRole": "<localized string>",
  "vehicleType": "<string>",
  "plateNumber": "<string>",
  "deliveryAddress": "<string>",
  "deliveryZone": "<string>",
  "orderCode": "<string>",
  "mealSummary": "<string>",
  "slotLabel": "<string>",
  "boxCount": 1,
  "stopStatus": "PickedUp"
}
```

- Add a defensive nullable response DTO, mapper, display entity, existing ApiServices method, remote-data-source/repository method, display use case, and ViewModel intent/state fields according to this repository's conventions.
- Fetch after the current callId is known. Do not delay native incoming-call reporting/ringing while waiting for display HTTP. Initially show localized generic copy and update safely when display arrives.
- Reject late display responses if callId/account/language changed or the call ended. Display failure must not end a working call or prevent answering.
- driverRole is already localized by backend; do not translate that returned string again. driverName, deliveryZone and mealSummary use server bilingual fallback.
- driverImageUrl is relative: resolve against the existing configured base URL using URI resolution. Null/missing image uses the existing placeholder. Do not log address or cache private display data across accounts.
- deliveryAddress falls back to deliveryZone on old records. No active driver assignment can yield empty driverName and null image; retain a generic localized fallback.
- stopStatus is a technical code, not display copy. No phone number is returned.
- On language change, request display again with the new Accept-Language and guard against old-language responses.
- Do not use live-tracking as fallback for call display: backend explicitly reports that its ownership check is not yet fixed. Use the participant-authorized display endpoint.
- Tests: complete/missing/null DTO fields, relative image resolution, generic fallback, 404/timeout without disrupting media, late call/account/language responses, language refresh, and no telephone exposure.

### Confirmed mobile integration values

- Backend base URL: `https://maelmate.runasp.net`; reuse repository configuration, never hardcode it in feature classes. User reports deployment is complete; verify v2 availability as an integration check rather than assume the older document's unpublished status still applies.
- FCM registration: `PUT /api/v1/customers/me/device-tokens` now returns HTTP 200 with `{"fcmDeviceTokenId":"<guid>"}`. Replace any void/204-only response contract with a DTO and map/persist the owned registry ID appropriately. Preserve the existing request body contract.
- Re-registering the same FCM token returns the same registry ID, so an ambiguous token-registration response can be recovered using the same token. Voice devices/register is separate and rotates the voice session; do not repeat it with every reconnect.
- Firebase project expected by backend: `mealmate-bd5b3` for both apps. Check existing mobile Firebase configuration before changing anything; never add service-account JSON or server signing keys to either app.
- iOS requires both FCM registry ID for cleanup and PushKit apnsVoipToken for incoming. Pass both in devices/register; there is no separate voice-token endpoint.
- SignalR JWT query parameter accepted by backend is `access_token`; let the SDK access-token callback manage authentication and redact URLs. controlProof is only a BindDeviceSession argument. RTC envelope includes messageId, callId, negotiationGeneration, senderDeviceSessionId, sentAtUtc, payload. Backend hub receive limit is 400 KB; SDP/candidate limits still apply independently.
- ICE credentials default TTL is 3600 seconds; honor actual expiresAtUtc/ttlSeconds. URLs may include STUN, TURN UDP/TCP and TURN TLS TCP. Default TURN ports are 3478 and 5349; consume actual returned URLs, not these defaults as hardcoded client configuration.
- The new reply still shows capabilityVersion=1 in an example while the v2 contract requires 2. This is not resolved by the reply: keep 2 as the contract implementation value and document verification with backend if registration/capability fails. Do not silently downgrade on 403.

### Correction to auth/session recovery instructions

- Earlier shorthand “401/403 register then retry” must not be followed indiscriminately. 401 uses existing JWT refresh first; 403 can mean a foreign account, non-winning device, revoked session or permission denial. Reconcile authoritative state and classify the cause before any registration.
- Never rotate an active call's device session just to retry answer/end/ICE; rotation invalidates old control ownership. Recover only when supported by authoritative state, otherwise cleanly surface the failure.
- Register renewal is automatic when application execution is available, not a guaranteed always-running background timer. An expired voice route may prevent push delivery; do not promise an expired session will be renewed by an incoming push.

## Goal
تنفيذ استقبال المكالمات داخل `lib/features/calling` مع الحفاظ على architecture والـUI الحالية.

## Contract
- Base: `/api/v2/voice-calls`; JWT Bearer، camelCase، UTC/UUID.
- Register: `POST /devices/register` body installationId, platform, capabilityVersion=2, fcmDeviceTokenId?, apnsVoipToken?؛ response deviceSessionId, controlProof, expiresAtUtc. Revoke: `POST /devices/{deviceSessionId}/revoke` = 204.
- Customer controls: `POST /{callId}/ringing-ack`, `/{callId}/answer`, `/{callId}/reject`, `/{callId}/end`.
- Reads: `GET /active` (204/empty=null)، `GET /{callId}`، `GET /history/{tripStopId}?page=1&pageSize=20`، `GET /{callId}/events?afterSequence=0`.
- Media: `GET /{callId}/ice-servers`، POST reports/connecting، reports/connected، heartbeat.
- Control/ICE headers: Authorization + X-Voice-Device-Session + X-Voice-Device-Proof.
- Snapshot: callId, tripStopId, protocolVersion, sequence, status, endReason?, startedAtUtc, acceptedAtUtc?, connectedAtUtc?, endedAtUtc?, durationSeconds?, deadlineAtUtc?, winningDeviceSessionId?, localParticipantRole. Statuses Created/Ringing/Accepted/Connecting/Active/Rejected/Cancelled/Missed/Failed/Ended.
- Event metadata: eventId, protocolVersion, callId, sequence, eventType, occurredAtUtc؛ events لا تعيد SDP/ICE.
- Errors: 400 validation، 401 refresh JWT، 403 auth/session/proof، 404، 409 reconcile، 422 domain، 429 respect retry-after، 503 V2 disabled.

## Steps
1. اقرأ AGENTS وقواعد UI/Backend، راجع calling والـfake data والـroutes وApiServices/Auth/refresh/push/native، وحدد tripStopId ومصدر بيانات السواق/العنوان.
2. حافظ على Dio/Retrofit/DI/ApiResult/safeApiCall. أضف نسخًا متوافقة من SignalR وflutter_webrtc وflutter_callkit_incoming فقط؛ لا HTTP stack ثانية.
3. أنشئ داخل calling nullable DTOs، requests، mappers، entities، repositories، data sources، use cases، وViewModel/State/Events للـcontract أعلاه.
4. سجّل FCM وخذ fcmDeviceTokenId الحقيقي، ثم register device. خزّن session/proof/expiry في secure storage. جدّد JWT بالـRefresh Token والـvoice session عند launch/resume/before expiry؛ 401/403 = register مرة ثم retry آمن مرة. Logout = revoke/clear.
5. SignalR `/hubs/voice-call-v2`: JWT ثم `BindDeviceSession(deviceSessionId, controlProof)` قبل RTC. events: bound/call:event/rtc:offer/answer/ice. وحّد Push وSignalR؛ dedupe eventId وطبّق snapshot sequence، واعمل active/events reconciliation بعد reconnect.
6. Android: FCM data-only عالي الأولوية، parse data.envelope JSON. iOS: PushKit VoIP envelope وCallKit. استخدم flutter_callkit_incoming للرنين والـaccept/decline/timeout/end، وأرسل ringing-ack بعد بدء الرنين الفعلي فقط.
7. بعد answer اجلب ICE؛ WebRTC كطرف مستقبل: استقبل Offer، Answer، queue ICE المبكر، dedupe messageId/generation، connecting ثم connected بعد media الحقيقي، heartbeat، mute/speaker، cleanup كامل.
8. اربط UI الحالية بالـintents بدون redesign. استخدم order data للاسم/الصورة/العنوان فقط، وfallback مترجمًا؛ لا تعرض/تخزن رقمًا.

## Security, failures, review
- لا logs للـJWT/proof/tokens/phone/SDP/ICE/TURN؛ لا proof في URL؛ لا raw DTOs في UI.
- لا provider acceptance بدل ringing-ack، لا stale/expired incoming، لا RTC قبل bind، ولا media لجهاز answered-elsewhere.
- اختبر mapping/nullability/204/status/sequence/dedupe/expiry/session/JWT/CallKit/reconnect/cleanup.
- شغّل format/analyze/tests، ثم أجهزة حقيقية Android foreground/background/terminated وiOS PushKit/CallKit، جهازين، network loss، صوت ثنائي الاتجاه وTURN.
- بعد التنفيذ راجع كل بند هنا ولا تعتبر Active دليلًا على الصوت.

## Mobile prerequisites that must be confirmed before implementation
- Confirm with backend the single accepted `capabilityVersion` (the handoff example shows 1 while the v2 contract requires 2); use that value in both apps.
- Confirm staging `baseUrl` and that `VoiceCalls__V2Enabled=true`; treat 503 as environment configuration, not a UI success.
- Confirm the FCM token endpoint returns the owned registry GUID `fcmDeviceTokenId` with HTTP 200; never substitute the raw Firebase token.
- Confirm iOS PushKit token is accepted in `apnsVoipToken` during the same device registration and that the customer bundle VoIP topic/environment is configured.
- Confirm the SignalR hub path, access-token callback format, event names, argument order, envelope casing, and the exact snapshot/status values before generating client serialization.
- Confirm ICE response contains usable STUN/TURN URLs and temporary username/password/expiry; the mobile app must consume them without any shared secret.
- Confirm the staging Coturn certificate setting does not advertise unusable `turns:` URLs; the app must handle the returned URL list rather than hardcode transports.
- Confirm server clock/deadline behavior for ring expiry, setup lease, heartbeat cadence, and terminal cleanup so native UI timers match server authority.
- Confirm real customer/driver test accounts and a `tripStopId` are available before device acceptance; Postman success does not prove Push, CallKit, or audio.

## Backend handoff addendum (mandatory details)
- Android incoming is FCM data-only, high priority: `data.type` plus `data.envelope` as a JSON string. TTL is bounded by ring deadline; terminal/answered cleanup has at most 60 seconds retention. iOS incoming is direct APNs HTTP/2 VoIP with `apns-push-type: voip`, priority 10, exact `<bundleId>.voip` topic and ring expiration; iOS terminal cleanup uses FCM background APNs.
- Provider acceptance, hub enqueue, and push receipt are never device ringing acknowledgment. Send `ringing-ack` only when native ringing actually starts. Unknown event types must not crash; reconcile snapshot.
- Lifecycle envelope fields are `eventId, protocolVersion, callId, sequence, eventType, occurredAtUtc, sentAtUtc, expiresAtUtc?, payload`. Envelope sequence is committed event order; payload.sequence is authoritative snapshot order and may be newer.
- `winningDeviceSessionId` identifies the winning customer device. Other customer devices stop native UI and never start media. A delayed incoming event with terminal payload or expired deadline must not open UI.
- SignalR invocations are `SendOffer(callId,{type:"offer",sdp},messageId,generation)`, `SendAnswer(...)`, and `SendIceCandidate(callId,{candidate,sdpMid?,sdpMLineIndex?,usernameFragment?},messageId,generation)`. messageId is non-empty UUID; generation >= 0; candidate is non-empty; SDP <= 65,536 UTF-8 bytes and candidate <= 4,096 bytes. Cache early ICE until remote description; ignore old generations.
- Only winning, owned, unrevoked, unexpired device sessions may exchange RTC. Do not send proof in a URL. Reconnect requires a fresh bind and REST reconciliation; RTC replay is not provided by events.
- Setup lease is independent per peer; heartbeat from one peer cannot keep the missing peer alive. Suggested heartbeat is every 10 seconds during Accepted/Connecting/Active; setup deadline is not extended by heartbeat.
- ICE response contains temporary STUN/TURN credentials. Never ship TURN shared secret. Confirm real media using WebRTC connection state and getStats/selected candidate; Active alone is not audible proof.
- Snapshot does not contain driver name/photo/address/phone. Read authorized order/trip data for display and use a localized generic fallback; never invent data.
- Reconcile after reconnect with /active, /{callId}, and /events?afterSequence=..., applying monotonic snapshot sequence and stopping native UI/media on authoritative terminal state.
- Validate all ProblemDetails without assuming `code` exists. Handle 401 refresh, 403 session/proof, 409 reconcile-before-retry, 429 retry metadata, and 503 feature disabled. Never retry answer/reject/end blindly.
- Release gate requires physical Android foreground/background/terminated, iOS PushKit/CallKit, two customer devices, token/session rotation, stale-event cleanup, two-way audio, forced TURN relay, network loss/reconnect, Arabic/English RTL/LTR, accessibility, and no secret/phone/SDP/ICE logging.
