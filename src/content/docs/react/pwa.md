[[toc]]

# Automatically

The PWA can be built automatically using the [**PWABuilder**](https://www.pwabuilder.com)

# Manually

To build our app as a PWA we will need to do the following:

1. In the `index.js` file, make the last line:

```js
serviceWorker.register()
```

2. In the `serviceWorker.js` file, replace the `register` function with the following which will register our service worker file that will be created in the next step

```js
export function register(config) {
  if ('serviceWorker' in navigator) {
    // Use the window load event to keep the page load performant
    window.addEventListener('load', () => {
      navigator.serviceWorker.register('/sw.js')
    })
  }
}
```

3. Create a new file called `sw.js` in the `public` directory with the following content

```js
importScripts(
  'https://storage.googleapis.com/workbox-cdn/releases/3.5.0/workbox-sw.js'
)

if (workbox) {
  console.log(`Yay! Workbox is loaded 🎉`)

  workbox.precaching.precacheAndRoute([])

  workbox.routing.registerRoute(
    /\.(?:ico|png|gif|jpg|js|css|html|svg)$/,
    workbox.strategies.cacheFirst({
      cacheName: 'static-cache',
      plugins: [
        new workbox.expiration.Plugin({
          maxEntries: 50,
          maxAgeSeconds: 30 * 24 * 60 * 60 // 30 Days
        })
      ]
    })
  )

  workbox.routing.registerRoute(
    /api\/times.*/,
    workbox.strategies.cacheFirst({
      cacheName: 'times-cache',
      plugins: [
        new workbox.expiration.Plugin({
          maxEntries: 50,
          maxAgeSeconds: 10 * 24 * 60 * 60
        })
      ]
    })
  )

  workbox.routing.registerRoute(
    /api\/index.*/,
    workbox.strategies.cacheFirst({
      cacheName: 'index-cache',
      plugins: [
        new workbox.expiration.Plugin({
          maxEntries: 50,
          maxAgeSeconds: 10 * 24 * 60 * 60
        })
      ]
    })
  )

  // Cache the Google Fonts stylesheets with a stale-while-revalidate strategy.

  workbox.routing.registerRoute(
    /^https:\/\/fonts\.googleapis\.com/,
    workbox.strategies.staleWhileRevalidate({
      cacheName: 'google-fonts-stylesheets'
    })
  )

  // Cache the underlying font files with a cache-first strategy for 1 year.
  workbox.routing.registerRoute(
    /^https:\/\/fonts\.gstatic\.com/,
    workbox.strategies.cacheFirst({
      cacheName: 'google-fonts-webfonts',
      plugins: [
        new workbox.cacheableResponse.Plugin({
          statuses: [0, 200]
        }),
        new workbox.expiration.Plugin({
          maxAgeSeconds: 60 * 60 * 24 * 365,
          maxEntries: 30
        })
      ]
    })
  )
} else {
  console.log(`Boo! Workbox didn't load 😬`)
}
```

This will cache all static resources and network requests to the specified endpoints

And **TADA**, you're done
