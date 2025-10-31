import asyncdispatch, httpclient, json, strutils

var token: string = ""
const api = "https://temporarymail.cc/"

proc create_headers(): HttpHeaders =
  result = newHttpHeaders({
    "Connection": "keep-alive",
    "Host": "temporarymail.cc",
    "Content-Type": "application/json",
    "accept": "application/json, text/plain, */*"
  })
  if token != "":
    result["Authorization"] = token

proc init_token(): Future[void] {.async.} =
  let client = newAsyncHttpClient()
  try:
    client.headers = create_headers()
    let response = await client.post(api & "init", body ="")
    let body = await response.body
    token = parseJson(body)["data"]["token"].getStr
  finally:
    client.close()

proc generate_email*(): Future[JsonNode] {.async.} =
  await init_token()
  let client = newAsyncHttpClient()
  try:
    client.headers = create_headers()
    let response = await client.post(api & "api/generate", body ="")
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()

proc get_messages*(): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  try:
    client.headers = create_headers()
    let response = await client.get(api & "api/emails")
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()
