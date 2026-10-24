import Foundation
import Security

public struct VoiceSessionData {
    public let sessionRevision: Int
    public let accountId: String
    public let voiceDeviceSessionId: String
    public let controlProof: String
    public let accessToken: String?
    public let refreshToken: String?
    public let expiresAtUtc: String?

    public init(
        sessionRevision: Int,
        accountId: String,
        voiceDeviceSessionId: String,
        controlProof: String,
        accessToken: String? = nil,
        refreshToken: String? = nil,
        expiresAtUtc: String? = nil
    ) {
        self.sessionRevision = sessionRevision
        self.accountId = accountId
        self.voiceDeviceSessionId = voiceDeviceSessionId
        self.controlProof = controlProof
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresAtUtc = expiresAtUtc
    }
}

public final class VoiceSessionStore {
    public static let shared = VoiceSessionStore()

    private let service = "kw.mealmate.user.voicesession"
    private let lock = NSRecursiveLock()
    private let userDefaults = UserDefaults.standard
    private let revisionKey = "kw.mealmate.voice_session_revision"

    public func readSession() -> VoiceSessionData? {
        lock.lock()
        defer { lock.unlock() }

        guard let data = loadKeychainData(account: "session_payload"),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let accountId = json["accountId"] as? String,
              let voiceDeviceSessionId = json["voiceDeviceSessionId"] as? String,
              let controlProof = json["controlProof"] as? String else {
            return nil
        }

        let revision = userDefaults.integer(forKey: revisionKey)
        return VoiceSessionData(
            sessionRevision: revision,
            accountId: accountId,
            voiceDeviceSessionId: voiceDeviceSessionId,
            controlProof: controlProof,
            accessToken: json["accessToken"] as? String,
            refreshToken: json["refreshToken"] as? String,
            expiresAtUtc: json["expiresAtUtc"] as? String
        )
    }

    public func readAccessToken() -> String? {
        return readSession()?.accessToken
    }

    public func installSession(expectedRevision: Int, data: VoiceSessionData) -> (success: Bool, newRevision: Int) {
        lock.lock()
        defer { lock.unlock() }

        let currentRev = userDefaults.integer(forKey: revisionKey)
        if expectedRevision != 0 && expectedRevision != currentRev {
            return (false, currentRev)
        }

        let newRev = currentRev + 1
        var json: [String: Any] = [
            "accountId": data.accountId,
            "voiceDeviceSessionId": data.voiceDeviceSessionId,
            "controlProof": data.controlProof
        ]
        if let token = data.accessToken { json["accessToken"] = token }
        if let refresh = data.refreshToken { json["refreshToken"] = refresh }
        if let exp = data.expiresAtUtc { json["expiresAtUtc"] = exp }

        if let raw = try? JSONSerialization.data(withJSONObject: json) {
            saveKeychainData(raw, account: "session_payload")
            userDefaults.set(newRev, forKey: revisionKey)
            return (true, newRev)
        }

        return (false, currentRev)
    }

    public func refreshSession(expectedRevision: Int, newAccessToken: String) -> (success: Bool, newRevision: Int) {
        lock.lock()
        defer { lock.unlock() }

        let currentRev = userDefaults.integer(forKey: revisionKey)
        if expectedRevision != currentRev {
            return (false, currentRev)
        }

        guard let existingData = loadKeychainData(account: "session_payload"),
              var json = (try? JSONSerialization.jsonObject(with: existingData)) as? [String: Any] else {
            return (false, currentRev)
        }

        json["accessToken"] = newAccessToken
        let newRev = currentRev + 1
        if let raw = try? JSONSerialization.data(withJSONObject: json) {
            saveKeychainData(raw, account: "session_payload")
            userDefaults.set(newRev, forKey: revisionKey)
            return (true, newRev)
        }

        return (false, currentRev)
    }

    public func clearSession(expectedRevision: Int) -> (success: Bool, newRevision: Int) {
        lock.lock()
        defer { lock.unlock() }

        let currentRev = userDefaults.integer(forKey: revisionKey)
        guard expectedRevision == 0 || expectedRevision == currentRev else { return (false, currentRev) }
        let newRev = currentRev + 1

        deleteKeychainData(account: "session_payload")
        userDefaults.set(newRev, forKey: revisionKey)
        return (true, newRev)
    }

    private var refreshWaiters: [(Bool) -> Void] = []
    private var isRefreshing = false
    public func refreshCredentials(completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            self.refreshWaiters.append(completion)
            guard !self.isRefreshing else { return }
            guard let old = self.readSession(), let refresh = old.refreshToken, !refresh.isEmpty,
                  let url = URL(string: "https://api.trymealmate.com/api/v1/auth/refresh") else { self.finishRefresh(false); return }
            self.isRefreshing = true
            var request = URLRequest(url: url, timeoutInterval: 15)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: ["refreshToken": refresh])
            URLSession.shared.dataTask(with: request) { data, response, _ in
                DispatchQueue.main.async {
                    guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode), let data = data,
                          let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { self.finishRefresh(false); return }
                    let payload = json["data"] as? [String: Any] ?? json
                    guard let access = payload["accessToken"] as? String, !access.isEmpty else { self.finishRefresh(false); return }
                    let updated = VoiceSessionData(sessionRevision: old.sessionRevision, accountId: old.accountId, voiceDeviceSessionId: old.voiceDeviceSessionId,
                        controlProof: old.controlProof, accessToken: access, refreshToken: payload["refreshToken"] as? String ?? old.refreshToken,
                        expiresAtUtc: payload["accessTokenExpiresAtUtc"] as? String ?? old.expiresAtUtc)
                    self.finishRefresh(self.installSession(expectedRevision: old.sessionRevision, data: updated).success)
                }
            }.resume()
        }
    }
    private func finishRefresh(_ success: Bool) {
        isRefreshing = false
        let waiters = refreshWaiters; refreshWaiters.removeAll()
        waiters.forEach { $0(success) }
    }

    public func getMetadata() -> [String: Any] {
        lock.lock()
        defer { lock.unlock() }

        let session = readSession()
        let revision = userDefaults.integer(forKey: revisionKey)
        return [
            "sessionRevision": revision,
            "hasSession": session != nil,
            "voiceDeviceSessionId": session?.voiceDeviceSessionId ?? "",
            "accountId": session?.accountId ?? "",
            "apnsVoipToken": userDefaults.string(forKey: "voice.apnsVoipToken") ?? ""
        ]
    }

    private func saveKeychainData(_ data: Data, account: String) {
        deleteKeychainData(account: account)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        ]
        SecItemAdd(query as CFDictionary, nil)
    }

    private func loadKeychainData(account: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: kCFBooleanTrue as Any,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if status == errSecSuccess {
            return item as? Data
        }
        return nil
    }

    private func deleteKeychainData(account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)
    }
}
