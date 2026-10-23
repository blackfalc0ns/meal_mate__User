import XCTest
@testable import Runner

class RunnerTests: XCTestCase {
    func testIceReceivedDuringIceServerFetchWaitsUntilPeerResetCompletes() {
        var preparation = NativeMediaPreparation()
        XCTAssertTrue(preparation.begin())
        XCTAssertTrue(preparation.isPreparing)
        XCTAssertFalse(preparation.isStarted)
        let candidate: [String: Any] = ["candidate": "candidate:early", "sdpMLineIndex": 0]
        // A pending ICE-server GET must not forward to the old/uninitialized media peer.
        XCTAssertFalse(preparation.receive(candidate, generation: 2, activeGeneration: 2))
        XCTAssertFalse(preparation.begin(), "Duplicate offer processing must not issue another ICE request")
        // Coordinator calls this only after media.answer has reset and created the new peer.
        let drained = preparation.peerStarted(generation: 2)
        XCTAssertEqual(drained.count, 1)
        XCTAssertEqual(drained.first?["candidate"] as? String, "candidate:early")
        XCTAssertFalse(preparation.isPreparing)
        XCTAssertTrue(preparation.isStarted)
        XCTAssertTrue(preparation.receive(["candidate": "candidate:late"], generation: 2, activeGeneration: 2))
        preparation.reset()
        XCTAssertTrue(preparation.peerStarted(generation: 2).isEmpty)
    }
    func testPendingNewerOfferCannotBeReplacedWhileIceFetchIsOutstanding() {
        // Snapshot still reflects N because N+1's ICE-server request has not completed.
        XCTAssertFalse(NativeMediaPreparation.acceptsOffer(generation: 4, snapshotGeneration: 4, pendingGeneration: 5))
        XCTAssertTrue(NativeMediaPreparation.acceptsOffer(generation: 5, snapshotGeneration: 4, pendingGeneration: 5))
        XCTAssertTrue(NativeMediaPreparation.acceptsOffer(generation: 6, snapshotGeneration: 4, pendingGeneration: 5))
        XCTAssertFalse(NativeMediaPreparation.acceptsOffer(generation: 3, snapshotGeneration: 4, pendingGeneration: nil))
    }
    func testPreparationDrainsOnlyItsNegotiationGeneration() {
        var preparation = NativeMediaPreparation()
        XCTAssertFalse(preparation.receive(["candidate": "old"], generation: 1, activeGeneration: 2))
        XCTAssertFalse(preparation.receive(["candidate": "current"], generation: 2, activeGeneration: 2))
        XCTAssertFalse(preparation.receive(["candidate": "future"], generation: 3, activeGeneration: 2))
        XCTAssertTrue(preparation.begin())
        XCTAssertEqual(preparation.peerStarted(generation: 2).compactMap { $0["candidate"] as? String }, ["current"])
        preparation.newOffer()
        XCTAssertTrue(preparation.begin())
        XCTAssertEqual(preparation.peerStarted(generation: 3).compactMap { $0["candidate"] as? String }, ["future"])
    }
    func testAnswerAcceptanceWaitsForRealMediaAndCallKitAudio() {
        let state = CallStateMachine()
        XCTAssertTrue(state.onIncomingRinging(callId: "call", lifecycleId: "life", micStatus: .granted))
        XCTAssertTrue(state.onUserAnswer(callId: "call", lifecycleId: "life", requestId: "answer"))
        XCTAssertTrue(state.onServerAccepted(callId: "call", lifecycleId: "life"))
        XCTAssertEqual(state.currentSnapshot.phase, .connecting)
        XCTAssertFalse(state.currentSnapshot.mediaTransportConnected)
        XCTAssertTrue(state.onMediaConnected(callId: "call", lifecycleId: "life", generation: 0))
        XCTAssertEqual(state.currentSnapshot.phase, .connecting)
        XCTAssertFalse(state.currentSnapshot.audioSessionActive)
        state.onAudioActivation(callId: "call", lifecycleId: "life", active: true)
        XCTAssertEqual(state.currentSnapshot.phase, .connected)
        state.onAudioActivation(callId: "call", lifecycleId: "life", active: false)
        XCTAssertEqual(state.currentSnapshot.phase, .reconnecting)
    }
    func testStaleLifecycleCannotEndOrMuteNewCall() {
        let state = CallStateMachine()
        state.onIncomingRinging(callId: "call", lifecycleId: "current")
        state.onCallEnded(callId: "call", lifecycleId: "stale")
        XCTAssertEqual(state.currentSnapshot.phase, .ringing)
        XCTAssertFalse(state.onMuteToggled(callId: "call", lifecycleId: "stale", requestId: "mute", muted: true))
        XCTAssertFalse(state.currentSnapshot.isMuted)
    }
    func testOldAndFutureMediaCallbacksCannotConnectCurrentGeneration() {
        let state = CallStateMachine()
        state.onIncomingRinging(callId: "call", lifecycleId: "life")
        state.onServerAccepted(callId: "call", lifecycleId: "life")
        state.onNegotiating(callId: "call", lifecycleId: "life", generation: 2)
        XCTAssertFalse(state.onMediaConnected(callId: "call", lifecycleId: "life", generation: 1))
        XCTAssertFalse(state.onMediaConnected(callId: "call", lifecycleId: "life", generation: 3))
        XCTAssertEqual(state.currentSnapshot.negotiationGeneration, 2)
    }
    func testTerminalCannotBeRevivedByLateCallback() {
        let state = CallStateMachine()
        state.onIncomingRinging(callId: "call", lifecycleId: "life")
        state.onCallEnded(callId: "call", lifecycleId: "life")
        XCTAssertFalse(state.onServerAccepted(callId: "call", lifecycleId: "life"))
        XCTAssertFalse(state.onMediaConnected(callId: "call", lifecycleId: "life", generation: 0))
        XCTAssertEqual(state.currentSnapshot.phase, .ended)
    }
    func testEnvelopeParsingPrefersAuthoritativeNestedSequence() {
        let data = NativeCallCoordinator.unwrap(["data": ["envelope": "{\"callId\":\"call\",\"sequence\":4,\"payload\":{\"sequence\":7,\"status\":\"Ended\"}}"]])
        XCTAssertEqual(data["callId"] as? String, "call")
        XCTAssertEqual(data["sequence"] as? Int, 7)
        XCTAssertEqual(data["status"] as? String, "Ended")
        XCTAssertEqual(NativeCallCoordinator.unwrap(["callId": "flat"])["callId"] as? String, "flat")
    }
    func testListenerMayReadAndReenterWithoutDeadlock() {
        let state = CallStateMachine()
        var revisions: [Int] = []
        state.addListener { snapshot in
            revisions.append(snapshot.revision)
            _ = state.currentSnapshot
        }
        state.onIncomingRinging(callId: "call", lifecycleId: "life")
        XCTAssertEqual(revisions, [1, 2])
    }
}
