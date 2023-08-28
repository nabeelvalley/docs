---
published: true
title: Play Watson Text-to-Speech via XHR
---

---
published: true
title: Play Watson Text-to-Speech via XHR
---

# Play the Audio

In order to play audio from the result of an XHR request we can make use of the following code (in this case using the IBM Watson Text to Speech Service), this will make the request, store the response audio as a `Blob`, assign that to an Audio Element, and then play the audio.

We will need to have the following in our HTML

```html
<audio id="myAudioElement" />
```

And then the necessary Javascript to get the audio source set on the element

```js
var data = null
var xhr = new XMLHttpRequest()
xhr.withCredentials = true
xhr.responseType = 'blob'
xhr.addEventListener('readystatechange', function () {
  if (this.readyState === 4) {
    //console.log(this.responseText);
  }
})
xhr.onload = function (evt) {
  var binaryData = []
  binaryData.push(xhr.response)
  var blob = new Blob(binaryData, { type: 'audio/mp3' })
  var objectUrl = window.URL.createObjectURL(
    new Blob(binaryData, { type: 'application/zip' })
  )
  console.log(objectUrl)
  var audioElement = document.getElementById('myAudioElement')
  audioElement.src = objectUrl
  audioElement.play()
}
xhr.open(
  'GET',
  `speech/text-to-speech/api/v1/voices/en-GB_KateVoice/synthesize?text=${text}`
)
xhr.setRequestHeader('Accept', 'audio/mp3')
xhr.setRequestHeader('Authorization', 'Basic XXXXXXXXXXXXXXXXXXXXXXXXXXX')
xhr.setRequestHeader('cache-control', 'no-cache')
xhr.send(data)
```

Note that we may get blocked by CORS, in order to prevent this we can make use of an Express Proxy on the server side (or really any kind of proxy) which will serve our site files from a `public` folder, and proxy requests to `/speech` to `https://stream.watsonplatform.net/`

```js
const express = require('express')
var proxy = require('express-http-proxy')

const app = express()

app.use(express.static('public'))
app.use('/speech', proxy('https://stream.watsonplatform.net/'))
```

It may be possible to make the request on the server as well and simply pass the binary forward, however I have not gotten that to work as yet
