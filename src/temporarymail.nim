import asyncdispatch, httpclient, json, strutils
const api = "https://temporarymail.com/api"
var secretKey=""
var headers = newHttpHeaders({
    "Connection": "keep-alive",
    "user-agent": "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Mobile Safari/537.3",
    "Host": "temporarymail.com",
    "Content-Type": "application/json",
    "accept": "application/json"
})

proc get_domains*(): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  client.headers = headers 
  try:
    let response = await client.get(api & "/?action=getDomains")
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()

proc generate_email*(): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  client.headers = headers 
  try:
    let response = await client.get(api & "/?action=requestEmailAccess&key=&value=random")
    let body = await response.body
    let json = parseJson(body)
    secretKey= json["secretKey"].getStr()
    result = json
  finally:
    client.close()

proc get_messages*(): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  client.headers = headers 
  try:
    let response = await client.get(api & "/?action=checkInbox&value=" & secretKey)
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()
