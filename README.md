# temporarymail
temp mail nim library temporarymail.cc
# Example
```nim
import asyncdispatch, temporarymail, json
let data = waitFor generate_email()
echo data["data"]["address"].getStr
```
# Launch (your script)
```
nim c -d:ssl -r  your_app.nim
```
