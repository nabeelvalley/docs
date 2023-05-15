---
published: true
title: WebRTC
subtitle: Real-time Communication with WebRTC
---

[From this CodeLab](https://codelabs.developers.google.com/codelabs/webrtc-web/#0)

# Getting the Code

The code can be found [here](https://github.com/googlecodelabs/webrtc-web)

```bash
git clone https://github.com/googlecodelabs/webrtc-web
```

# Running the Website

Run the application in the 'work' directory using an HTTP server

# Stream video from webcam

In the `index.html` file add a `video` element as well as links to the relevant `css` and `js` files

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Realtime communication with WebRTC</title>

    <link rel="stylesheet" href="css/main.css" />
  </head>

  <body>
    <h1>Realtime communication with WebRTC</h1>

    <video autoplay playsinline></video>

    <script src="js/main.js"></script>
  </body>
</html>
```

In the `main.js` file add the following

```js
'use strict'

// On this codelab, you will be streaming only video (video: true).
const mediaStreamConstraints = {
  video: true,
}

// Video element where stream will be placed.
const localVideo = document.querySelector('video')

// Local stream that will be reproduced on the video.
let localStream

// Handles success by adding the MediaStream to the video element.
function gotLocalMediaStream(mediaStream) {
  localStream = mediaStream
  localVideo.srcObject = mediaStream
}

// Handles error by logging a message to the console with the error message.
function handleLocalMediaStreamError(error) {
  console.log('navigator.getUserMedia error: ', error)
}

// Initializes media stream.
navigator.mediaDevices
  .getUserMedia(mediaStreamConstraints)
  .then(gotLocalMediaStream)
  .catch(handleLocalMediaStreamError)
```

The `getUserMedia` function requests access to the `mediaStreamConstraints` object that it is given, and in turn (after requesting access from the user) will return a MediaStream object which can be used by a media object

Thereafter we use the `gotLocalMediaStream` and `handleLocalMediaStreamError` functions to set the video `srcObject` or respond to errors respectively

The `constraints` object can consist of different properties, such as:

```js
const hdConstraints = {
  video: {
    width: {
      min: 1280,
    },
    height: {
      min: 720,
    },
  },
}
```

More specific information on that can be found [here](https://w3c.github.io/mediacapture-main/getusermedia.html#media-track-constraints)

While we're playing around with the `video` element you can also simply flip the content on your webcam to mirror itself with the CSS property `transform: rotateY(180deg)` and just generally play around with the `filter` property

Also if you do not make use of `autoplay` on the video you will only see a single frame

More examples of constraints [here](https://webrtc.github.io/samples/src/content/peerconnection/constraints/)

# Streaming Video with RTCPeerConnection

We will now update the application to consist of a `local` and `remote` video in which the page will connect to itself

Add a second video element as well as some buttons for controlling the content to the HTML. Also add the `adapter.js` file which is a WebRTC shim for simpler compatability between browsers

`index.html`

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Realtime communication with WebRTC</title>
    <link rel="stylesheet" href="css/main.css" />
  </head>

  <body>
    <h1>Realtime communication with WebRTC</h1>

    <video id="localVideo" autoplay playsinline></video>
    <video id="remoteVideo" autoplay playsinline></video>

    <div>
      <button id="startButton">Start</button>
      <button id="callButton">Call</button>
      <button id="hangupButton">Hang Up</button>
    </div>

    <script src="https://webrtc.github.io/adapter/adapter-latest.js"></script>
    <script src="js/main.js"></script>
  </body>
</html>
```

`main.js`

```js
'use strict'

// Set up media stream constant and parameters.

// In this codelab, you will be streaming video only: "video: true".
// Audio will not be streamed because it is set to "audio: false" by default.
const mediaStreamConstraints = {
  video: true,
}

// Set up to exchange only video.
const offerOptions = {
  offerToReceiveVideo: 1,
}

// Define initial start time of the call (defined as connection between peers).
let startTime = null

// Define peer connections, streams and video elements.
const localVideo = document.getElementById('localVideo')
const remoteVideo = document.getElementById('remoteVideo')

let localStream
let remoteStream

let localPeerConnection
let remotePeerConnection

// Define MediaStreams callbacks.

// Sets the MediaStream as the video element src.
function gotLocalMediaStream(mediaStream) {
  localVideo.srcObject = mediaStream
  localStream = mediaStream
  trace('Received local stream.')
  callButton.disabled = false // Enable call button.
}

// Handles error by logging a message to the console.
function handleLocalMediaStreamError(error) {
  trace(`navigator.getUserMedia error: ${error.toString()}.`)
}

// Handles remote MediaStream success by adding it as the remoteVideo src.
function gotRemoteMediaStream(event) {
  const mediaStream = event.stream
  remoteVideo.srcObject = mediaStream
  remoteStream = mediaStream
  trace('Remote peer connection received remote stream.')
}

// Add behavior for video streams.

// Logs a message with the id and size of a video element.
function logVideoLoaded(event) {
  const video = event.target
  trace(
    `${video.id} videoWidth: ${video.videoWidth}px, ` +
      `videoHeight: ${video.videoHeight}px.`
  )
}

// Logs a message with the id and size of a video element.
// This event is fired when video begins streaming.
function logResizedVideo(event) {
  logVideoLoaded(event)

  if (startTime) {
    const elapsedTime = window.performance.now() - startTime
    startTime = null
    trace(`Setup time: ${elapsedTime.toFixed(3)}ms.`)
  }
}

localVideo.addEventListener('loadedmetadata', logVideoLoaded)
remoteVideo.addEventListener('loadedmetadata', logVideoLoaded)
remoteVideo.addEventListener('onresize', logResizedVideo)

// Define RTC peer connection behavior.

// Connects with new peer candidate.
function handleConnection(event) {
  const peerConnection = event.target
  const iceCandidate = event.candidate

  if (iceCandidate) {
    const newIceCandidate = new RTCIceCandidate(iceCandidate)
    const otherPeer = getOtherPeer(peerConnection)

    otherPeer
      .addIceCandidate(newIceCandidate)
      .then(() => {
        handleConnectionSuccess(peerConnection)
      })
      .catch((error) => {
        handleConnectionFailure(peerConnection, error)
      })

    trace(
      `${getPeerName(peerConnection)} ICE candidate:\n` +
        `${event.candidate.candidate}.`
    )
  }
}

// Logs that the connection succeeded.
function handleConnectionSuccess(peerConnection) {
  trace(`${getPeerName(peerConnection)} addIceCandidate success.`)
}

// Logs that the connection failed.
function handleConnectionFailure(peerConnection, error) {
  trace(
    `${getPeerName(peerConnection)} failed to add ICE Candidate:\n` +
      `${error.toString()}.`
  )
}

// Logs changes to the connection state.
function handleConnectionChange(event) {
  const peerConnection = event.target
  console.log('ICE state change event: ', event)
  trace(
    `${getPeerName(peerConnection)} ICE state: ` +
      `${peerConnection.iceConnectionState}.`
  )
}

// Logs error when setting session description fails.
function setSessionDescriptionError(error) {
  trace(`Failed to create session description: ${error.toString()}.`)
}

// Logs success when setting session description.
function setDescriptionSuccess(peerConnection, functionName) {
  const peerName = getPeerName(peerConnection)
  trace(`${peerName} ${functionName} complete.`)
}

// Logs success when localDescription is set.
function setLocalDescriptionSuccess(peerConnection) {
  setDescriptionSuccess(peerConnection, 'setLocalDescription')
}

// Logs success when remoteDescription is set.
function setRemoteDescriptionSuccess(peerConnection) {
  setDescriptionSuccess(peerConnection, 'setRemoteDescription')
}

// Logs offer creation and sets peer connection session descriptions.
function createdOffer(description) {
  trace(`Offer from localPeerConnection:\n${description.sdp}`)

  trace('localPeerConnection setLocalDescription start.')
  localPeerConnection
    .setLocalDescription(description)
    .then(() => {
      setLocalDescriptionSuccess(localPeerConnection)
    })
    .catch(setSessionDescriptionError)

  trace('remotePeerConnection setRemoteDescription start.')
  remotePeerConnection
    .setRemoteDescription(description)
    .then(() => {
      setRemoteDescriptionSuccess(remotePeerConnection)
    })
    .catch(setSessionDescriptionError)

  trace('remotePeerConnection createAnswer start.')
  remotePeerConnection
    .createAnswer()
    .then(createdAnswer)
    .catch(setSessionDescriptionError)
}

// Logs answer to offer creation and sets peer connection session descriptions.
function createdAnswer(description) {
  trace(`Answer from remotePeerConnection:\n${description.sdp}.`)

  trace('remotePeerConnection setLocalDescription start.')
  remotePeerConnection
    .setLocalDescription(description)
    .then(() => {
      setLocalDescriptionSuccess(remotePeerConnection)
    })
    .catch(setSessionDescriptionError)

  trace('localPeerConnection setRemoteDescription start.')
  localPeerConnection
    .setRemoteDescription(description)
    .then(() => {
      setRemoteDescriptionSuccess(localPeerConnection)
    })
    .catch(setSessionDescriptionError)
}

// Define and add behavior to buttons.

// Define action buttons.
const startButton = document.getElementById('startButton')
const callButton = document.getElementById('callButton')
const hangupButton = document.getElementById('hangupButton')

// Set up initial action buttons status: disable call and hangup.
callButton.disabled = true
hangupButton.disabled = true

// Handles start button action: creates local MediaStream.
function startAction() {
  startButton.disabled = true
  navigator.mediaDevices
    .getUserMedia(mediaStreamConstraints)
    .then(gotLocalMediaStream)
    .catch(handleLocalMediaStreamError)
  trace('Requesting local stream.')
}

// Handles call button action: creates peer connection.
function callAction() {
  callButton.disabled = true
  hangupButton.disabled = false

  trace('Starting call.')
  startTime = window.performance.now()

  // Get local media stream tracks.
  const videoTracks = localStream.getVideoTracks()
  const audioTracks = localStream.getAudioTracks()
  if (videoTracks.length > 0) {
    trace(`Using video device: ${videoTracks[0].label}.`)
  }
  if (audioTracks.length > 0) {
    trace(`Using audio device: ${audioTracks[0].label}.`)
  }

  const servers = null // Allows for RTC server configuration.

  // Create peer connections and add behavior.
  localPeerConnection = new RTCPeerConnection(servers)
  trace('Created local peer connection object localPeerConnection.')

  localPeerConnection.addEventListener('icecandidate', handleConnection)
  localPeerConnection.addEventListener(
    'iceconnectionstatechange',
    handleConnectionChange
  )

  remotePeerConnection = new RTCPeerConnection(servers)
  trace('Created remote peer connection object remotePeerConnection.')

  remotePeerConnection.addEventListener('icecandidate', handleConnection)
  remotePeerConnection.addEventListener(
    'iceconnectionstatechange',
    handleConnectionChange
  )
  remotePeerConnection.addEventListener('addstream', gotRemoteMediaStream)

  // Add local stream to connection and create offer to connect.
  localPeerConnection.addStream(localStream)
  trace('Added local stream to localPeerConnection.')

  trace('localPeerConnection createOffer start.')
  localPeerConnection
    .createOffer(offerOptions)
    .then(createdOffer)
    .catch(setSessionDescriptionError)
}

// Handles hangup action: ends up call, closes connections and resets peers.
function hangupAction() {
  localPeerConnection.close()
  remotePeerConnection.close()
  localPeerConnection = null
  remotePeerConnection = null
  hangupButton.disabled = true
  callButton.disabled = false
  trace('Ending call.')
}

// Add click event handlers for buttons.
startButton.addEventListener('click', startAction)
callButton.addEventListener('click', callAction)
hangupButton.addEventListener('click', hangupAction)

// Define helper functions.

// Gets the "other" peer connection.
function getOtherPeer(peerConnection) {
  return peerConnection === localPeerConnection
    ? remotePeerConnection
    : localPeerConnection
}

// Gets the name of a certain peer connection.
function getPeerName(peerConnection) {
  return peerConnection === localPeerConnection
    ? 'localPeerConnection'
    : 'remotePeerConnection'
}

// Logs an action (text) and the time when it happened on the console.
function trace(text) {
  text = text.trim()
  const now = (window.performance.now() / 1000).toFixed(3)

  console.log(now, text)
}
```
