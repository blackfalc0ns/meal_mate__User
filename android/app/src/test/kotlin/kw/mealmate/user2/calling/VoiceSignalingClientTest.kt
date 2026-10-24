package kw.mealmate.user2.calling
import org.junit.Assert.*
import org.junit.Test
import org.json.JSONArray
import org.json.JSONObject
class VoiceSignalingClientTest {
 @Test fun positionalAndEnvelopeOffersShareWireContract() {
  val client=VoiceSignalingClient(); val generations=mutableListOf<Int>(); val sdps=mutableListOf<String>()
  client.onRtcOffer={id,p,_,g -> assertEquals("call",id); generations.add(g); sdps.add(p.getString("sdp")) }
  client.dispatch("rtc:offer",JSONArray().put("call").put(JSONObject().put("sdp","offer-a")).put("id1").put(3))
  client.dispatch("rtc:offer",JSONArray().put(JSONObject().put("callId","call").put("negotiationGeneration",4).put("payload",JSONObject().put("sdp","offer-b"))))
  assertEquals(listOf(3,4),generations); assertEquals(listOf("offer-a","offer-b"),sdps)
 }
 @Test fun outboundRtcRequiresConfirmedBinding() {
  val client=VoiceSignalingClient()
  assertFalse(client.sendAnswer("call","sdp","id",0))
  assertFalse(client.sendIceCandidate("call",JSONObject().put("candidate","ice"),"id",0))
 }
}
