#!/usr/bin/env node
// @ts-check

const { appendFileSync } = require("fs")
const { stdout, stdin } = require("process")

function log(contents) {
  const logMessage = typeof contents === 'string' ? contents : JSON.stringify(contents)
  return appendFileSync('./log', "\n" + logMessage + "\n")
}

log("LSP Started")

function parseMessage(message) {
  log("Received")
  log(message)
  const parts = message.split('\r\n')
  const body = JSON.parse(parts[parts.length - 1])

  return body
}


function createResponse(message, result, error) {
  return {
    jsonrpc: "2.0",
    id: message.id,
    result,
    error
  }
}

const METHOD_NOT_FOUND = -32601

function handleMessage(message) {
  const isNotification = message.id === undefined

  if (isNotification) {
    // Notifications don't require a response
    return log(`Not responding to notification ${message.method}`)
  }

  switch (message.method) {
    case "initialize":
      return createResponse(message, {
        capabilities: {
          codeActionProvider: true,
          executeCommandProvider: {
            "commands": ["_example.doSomethingCool"]
          }
        },
        serverInfo: {
          name: "example-lsp",
          version: "0.0.1"
        }
      })

    case "textDocument/codeAction":
      return createResponse(message, [{
        title: "Do something cool",
        kind: "quickfix",
        command: "_example.doSomethingCool"
      }])

    default:
      return createResponse(message, undefined, {
        code: METHOD_NOT_FOUND,
        message: `Requested method not found in handler ${message.method}`
      })
  }

}

function sendResponse(result) {
  const content = JSON.stringify(result)
  const length = Buffer.byteLength(content, 'utf-8')

  const response = `Content-Length: ${length}\r\n\r\n${content}`

  log("Sending")
  log(response)
  stdout.write(response)
}

stdin.on('data', (d) => {
  const message = parseMessage(d.toString())

  const response = handleMessage(message)
  if (response) {
    sendResponse(response)
  }
})


process.on('exit', () => log('LSP process terminated'))
