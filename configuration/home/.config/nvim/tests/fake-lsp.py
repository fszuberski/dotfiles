import json
import sys


def send(message):
    body = json.dumps(message).encode("utf-8")
    sys.stdout.buffer.write(f"Content-Length: {len(body)}\r\n\r\n".encode() + body)
    sys.stdout.buffer.flush()


while True:
    headers = {}
    while True:
        line = sys.stdin.buffer.readline()
        if not line:
            sys.exit(0)
        if line == b"\r\n":
            break
        key, value = line.decode().split(":", 1)
        headers[key.lower()] = value.strip()
    message = json.loads(sys.stdin.buffer.read(int(headers["content-length"])))
    method = message.get("method")
    if method == "exit":
        break
    if "id" not in message:
        continue
    if method == "initialize":
        result = {"capabilities": {"textDocumentSync": 1, "documentFormattingProvider": True, "completionProvider": {}}}
    elif method == "textDocument/formatting":
        result = [{"range": {"start": {"line": 0, "character": 0}, "end": {"line": 0, "character": 16}}, "newText": "package formatted"}]
    else:
        result = None
    send({"jsonrpc": "2.0", "id": message["id"], "result": result})
