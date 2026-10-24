import Foundation

public final class VoiceApiClient {
    private let baseUrl: String
    private let tokenProvider: () -> String?
    public init(baseUrl: String = "https://api.trymealmate.com", tokenProvider: @escaping () -> String? = { nil }) {
        self.baseUrl = baseUrl; self.tokenProvider = tokenProvider
    }
    private func request(path: String, method: String, body: [String: Any]? = nil, deviceSessionId: String?, controlProof: String?, retry: Bool = false, completion: @escaping (Data?, Int) -> Void) {
        guard let url = URL(string: baseUrl + path) else { completion(nil, 0); return }
        var request = URLRequest(url: url, timeoutInterval: 15)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = tokenProvider() { request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") }
        request.setValue(deviceSessionId, forHTTPHeaderField: "X-Voice-Device-Session")
        request.setValue(controlProof, forHTTPHeaderField: "X-Voice-Device-Proof")
        if let body = body { request.httpBody = try? JSONSerialization.data(withJSONObject: body) }
        let revision = VoiceSessionStore.shared.readSession()?.sessionRevision
        URLSession.shared.dataTask(with: request) { [weak self] data, response, _ in
            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            if status == 401, !retry, let self = self {
                VoiceSessionStore.shared.refreshCredentials { success in
                    guard success, VoiceSessionStore.shared.readSession()?.voiceDeviceSessionId == deviceSessionId else { completion(nil, 401); return }
                    self.request(path: path, method: method, body: body, deviceSessionId: deviceSessionId, controlProof: controlProof, retry: true, completion: completion)
                }
            } else {
                // Discard credentials from a request whose owner logged out or changed session.
                if let revision = revision, let current = VoiceSessionStore.shared.readSession(), current.sessionRevision >= revision, current.voiceDeviceSessionId == deviceSessionId { completion(data, status) }
                else { completion(nil, 0) }
            }
        }.resume()
    }
    private func post(_ callId: String, _ suffix: String, body: [String: Any]? = nil, deviceSessionId: String?, controlProof: String?, completion: @escaping (Bool) -> Void) {
        request(path: "/api/v2/voice-calls/\(callId)/\(suffix)", method: "POST", body: body, deviceSessionId: deviceSessionId, controlProof: controlProof) { _, status in completion((200...299).contains(status)) }
    }
    public func ringingAck(callId: String, deviceSessionId: String?, controlProof: String?, completion: @escaping (Bool) -> Void) { post(callId, "ringing-ack", deviceSessionId: deviceSessionId, controlProof: controlProof, completion: completion) }
    public func answer(callId: String, deviceSessionId: String?, controlProof: String?, completion: @escaping (Bool) -> Void) { post(callId, "answer", deviceSessionId: deviceSessionId, controlProof: controlProof, completion: completion) }
    public func reject(callId: String, deviceSessionId: String?, controlProof: String?, completion: @escaping (Bool) -> Void) { post(callId, "reject", deviceSessionId: deviceSessionId, controlProof: controlProof, completion: completion) }
    public func end(callId: String, deviceSessionId: String?, controlProof: String?, completion: @escaping (Bool) -> Void) { post(callId, "end", deviceSessionId: deviceSessionId, controlProof: controlProof, completion: completion) }
    public func reportConnecting(callId: String, generation: Int, deviceSessionId: String?, controlProof: String?, completion: @escaping (Bool) -> Void) { post(callId, "reports/connecting", body: ["generation": generation], deviceSessionId: deviceSessionId, controlProof: controlProof, completion: completion) }
    public func reportConnected(callId: String, generation: Int, deviceSessionId: String?, controlProof: String?, completion: @escaping (Bool) -> Void) { post(callId, "reports/connected", body: ["generation": generation], deviceSessionId: deviceSessionId, controlProof: controlProof, completion: completion) }
    public func heartbeat(callId: String, deviceSessionId: String?, controlProof: String?, completion: @escaping (Bool) -> Void) { post(callId, "heartbeat", deviceSessionId: deviceSessionId, controlProof: controlProof, completion: completion) }
    public func getIceServers(callId: String, deviceSessionId: String?, controlProof: String?, completion: @escaping (Data?) -> Void) {
        request(path: "/api/v2/voice-calls/\(callId)/ice-servers", method: "GET", deviceSessionId: deviceSessionId, controlProof: controlProof) { data, status in completion((200...299).contains(status) ? data : nil) }
    }
    public func getSnapshot(callId: String?, deviceSessionId: String, controlProof: String, completion: @escaping ([String: Any]?) -> Void) {
        let path = callId.map { "/api/v2/voice-calls/\($0)" } ?? "/api/v2/voice-calls/active"
        request(path: path, method: "GET", deviceSessionId: deviceSessionId, controlProof: controlProof) { data, status in
            if status == 404 || status == 204 { completion(["absent": true]); return }
            guard (200...299).contains(status), let data = data, let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { completion(nil); return }
            if json["data"] is NSNull { completion(["absent": true]); return }
            completion(json["data"] as? [String: Any] ?? json)
        }
    }
}
