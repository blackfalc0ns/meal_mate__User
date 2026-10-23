package kw.mealmate.user2.calling
import org.junit.Assert.*
import org.junit.Test
class CallStateMachineTest {
 @Test fun duplicateInviteUpdatesCallerFromPushWithoutRestartingCall() {
  val state = CallStateMachine()
  state.onIncomingRinging("call", "life", callerDisplay = CallerDisplay("null", "Driver", null, null))
  assertFalse(state.onIncomingRinging("call", "other", callerDisplay = CallerDisplay("يحيي سواق", "مندوب التوصيل", null, null)))
  assertEquals("يحيي سواق", state.currentSnapshot.callerDisplay?.callerName)
  assertEquals("life", state.currentSnapshot.lifecycleId)
 }
 @Test fun staleLifecycleCannotEndCurrentCall() {
  val state = CallStateMachine(); state.onIncomingRinging("call", "new")
  state.onCallEnded("call", "old")
  assertEquals(CallPhase.RINGING, state.currentSnapshot.phase)
 }
 @Test fun terminalInviteCannotRevive() {
  val state = CallStateMachine(); state.onIncomingRinging("call", "life")
  state.onCallEnded("call", "life")
  assertFalse(state.onIncomingRinging("call", "life2"))
 }
 @Test fun endingCannotBeRevivedByLateAcceptance() {
  val state = CallStateMachine(); state.onIncomingRinging("call", "life")
  state.onCallEnding("call", "life")
  assertFalse(state.onServerAccepted("call", "life"))
 }
 @Test fun newGenerationRequiresFreshTransport() {
  val state=CallStateMachine(); state.onIncomingRinging("call","life")
  state.onServerAccepted("call","life"); state.onMediaConnected("call","life",0)
  state.onNegotiationGeneration(1)
  assertFalse(state.currentSnapshot.mediaTransportConnected)
  assertEquals(CallPhase.RECONNECTING,state.currentSnapshot.phase)
  assertFalse(state.onMediaConnected("call","life",0))
 }
 @Test fun repeatedAnswerRequestDoesNotStartSecondTransition() {
  val state=CallStateMachine(); state.onIncomingRinging("call","life")
  assertTrue(state.onUserAnswer("call","life","same-request"))
  assertFalse(state.onUserAnswer("call","life","same-request"))
 }
}
