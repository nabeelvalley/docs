---
title: Simple Overview of the Web Authentication API
subtitle: 29 July 2025
---

The Web Authentication API is a public/private key based authentication mechanism that is built into modern browsers and enables us to easily develop authentication solutions on the web

It consists of a few simple APIs, namely `navigator.credentials.get` and `navigatior.credentials.create`. A simple example that uses these APIs can be seen below:

## Example

<div id="authn-example"></div>

<script>
let creds;

const createButton = document.createElement('button');
createButton.innerText = "Create Account";
createButton.onclick = async () => {
    const newCreds = await createCredentials();
    alert("Created credentials are" + JSON.stringify(newCreds));
    creds = newCreds;
};

const loginButton = document.createElement('button');
loginButton.innerText = "Create Account";
loginButton.onclick = async () => {
    if (!creds) {
        throw new Error("Credentials not created");
    }
    const gotCreds = await getCredentials(creds.rawId);
    alert("Loaded credentials are" + JSON.stringify(gotCreds));
};

document.querySelector('#authn-example').appendChild(createButton);
document.querySelector('#authn-example').appendChild(loginButton);

function getCredentials(id) {
    return navigator.credentials.get({
        publicKey: {
            challenge: new Uint8Array([117, 61, 252, 231, 191, 241 /* … */]),
            rpId: window.location.host,
            allowCredentials: [
                {
                    id,
                    type: "public-key",
                },
            ],
            userVerification: "required",
        }
    });
}

function createCredentials() {
    return navigator.credentials.create({
        publicKey: {
            challenge: new Uint8Array([117, 61, 252, 231, 191, 241 /* … */]),
            rp: { id: window.location.host, name: "Nabeel Credential Testing" },
            user: {
                id: new Uint8Array([79, 252, 83, 72, 214, 7, 89, 26]),
                name: "jamiedoe",
                displayName: "Jamie Doe",
            },
            pubKeyCredParams: [{ type: "public-key", alg: -7 }],
        },
    });
}

function sleep(ms = 2000) {
    return new Promise((res) => setTimeout(res, ms));
}
</script>


## Code

And the code that implements the above can be seen as follows

```ts
let creds: Credential | null

const createButton = document.createElement('button')
createButton.innerText = "Create Account"
createButton.onclick = async () => {
  const newCreds = await createCredentials()
  alert("Created credentials are" + JSON.stringify(newCreds))

  creds = newCreds
}

const loginButton = document.createElement('button')
loginButton.innerText = "Create Account"
loginButton.onclick = async () => {
  if (!creds) {
    throw new Error("Credentials not created")
  }

  const gotCreds = await getCredentials(creds.rawId)
  alert("Loaded credentials are" + JSON.stringify(gotCreds))
}

document.querySelector<HTMLDivElement>('#authn-example')!.appendChild(createButton)
document.querySelector<HTMLDivElement>('#authn-example')!.appendChild(loginButton)

function getCredentials(id: BufferSource) {
  return navigator.credentials.get({
    publicKey: {
      challenge: new Uint8Array([117, 61, 252, 231, 191, 241 /* … */]),
      rpId: window.location.host,
      allowCredentials: [
        {
          id,
          type: "public-key",
        },
      ],
      userVerification: "required",
    }
  })
}

function createCredentials() {
  return navigator.credentials.create({
    publicKey: {
      challenge: new Uint8Array([117, 61, 252, 231, 191, 241 /* … */]),
      rp: { id: window.location.host, name: "Nabeel Credential Testing" },
      user: {
        id: new Uint8Array([79, 252, 83, 72, 214, 7, 89, 26]),
        name: "jamiedoe",
        displayName: "Jamie Doe",
      },
      pubKeyCredParams: [{ type: "public-key", alg: -7 }],
    },
  });
}

function sleep(ms = 2000) {
  return new Promise((res) => setTimeout(res, ms))
}
```