package kw.mealmate.user2.calling
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
import org.json.JSONObject
import java.net.HttpURLConnection
import java.net.URL

class VoiceApiClient(
 private val baseUrl: String = "https://api.trymealmate.com",
 private val tokenProvider: () -> String? = { null },
 private val sessionStore: VoiceSessionStore? = null
) {
 private val refreshLock = Mutex()
 suspend fun ringingAck(id:String,s:String?,p:String?) = post(id,"ringing-ack",s,p)
 suspend fun answer(id:String,s:String?,p:String?) = post(id,"answer",s,p)
 suspend fun reject(id:String,s:String?,p:String?) = post(id,"reject",s,p)
 suspend fun end(id:String,s:String?,p:String?) = post(id,"end",s,p)
 suspend fun reportConnecting(id:String,g:Int,s:String?,p:String?) = post(id,"reports/connecting",s,p,JSONObject().put("generation",g))
 suspend fun reportConnected(id:String,g:Int,s:String?,p:String?) = post(id,"reports/connected",s,p,JSONObject().put("generation",g))
 suspend fun heartbeat(id:String,s:String?,p:String?) = post(id,"heartbeat",s,p)
 suspend fun getIceServers(id:String,s:String?,p:String?) = request("GET","/api/v2/voice-calls/$id/ice-servers",s,p)
 suspend fun getCall(id:String,s:String?,p:String?) = request("GET","/api/v2/voice-calls/$id",s,p)
 suspend fun getActive(s:String?,p:String?) = request("GET","/api/v2/voice-calls/active",s,p)
 private suspend fun post(id:String,action:String,s:String?,p:String?,body:JSONObject?=null):Result<Unit> =
  request("POST","/api/v2/voice-calls/$id/$action",s,p,body?.toString()).map { Unit }
 private suspend fun request(method:String,path:String,s:String?,p:String?,body:String?=null):Result<String> = withContext(Dispatchers.IO) {
  runCatching {
   var token = tokenProvider()
   var response = execute(method,path,token,s,p,body)
   if(response.first == 401 && refreshJwt(token)) {
    token=tokenProvider(); response=execute(method,path,token,s,p,body)
   }
   check(response.first in 200..299) { "HTTP error ${response.first}" }
   response.second
  }
 }
 suspend fun refreshJwt(rejectedToken:String? = tokenProvider()):Boolean = refreshLock.withLock {
  val store = sessionStore ?: return@withLock false
  val before=store.readSession() ?: return@withLock false
  if(before.accessToken != rejectedToken) return@withLock true
  val refresh=before.refreshToken?.takeIf { it.isNotBlank() } ?: return@withLock false
  withContext(Dispatchers.IO) { runCatching {
   val response=execute("POST","/api/v1/auth/refresh",null,null,null,JSONObject().put("refreshToken",refresh).toString())
   if(response.first !in 200..299) return@runCatching false
   val root=JSONObject(response.second); val data=root.optJSONObject("data") ?: root
   val access=data.optString("accessToken")
   access.isNotBlank() && store.updateTokens(before.sessionRevision,access,data.optString("refreshToken",null))
  }.getOrDefault(false) }
 }
 private fun execute(method:String,path:String,token:String?,s:String?,p:String?,body:String?):Pair<Int,String> {
  val connection=URL("$baseUrl$path").openConnection() as HttpURLConnection
  try {
   connection.requestMethod=method; connection.connectTimeout=8000; connection.readTimeout=8000
   connection.setRequestProperty("Content-Type","application/json")
   token?.let { connection.setRequestProperty("Authorization","Bearer $it") }
   s?.let { connection.setRequestProperty("X-Voice-Device-Session",it) }
   p?.let { connection.setRequestProperty("X-Voice-Device-Proof",it) }
   if(method == "POST") { connection.doOutput=true; connection.outputStream.use { it.write((body ?: "{}").toByteArray()) } }
   val code=connection.responseCode
   val stream=if(code in 200..299) connection.inputStream else connection.errorStream
   return code to (stream?.bufferedReader()?.use { it.readText() }.orEmpty())
  } finally { connection.disconnect() }
 }
}
