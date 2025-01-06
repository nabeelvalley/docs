console.log("i am still here2");

self.addEventListener("install", () => console.log("installed"));

self.addEventListener("activate", () => console.log("activated"));

self.addEventListener("fetch", (event) => {
  console.log(event.request.url);

  if (event.request.url.includes("placeholder")) {
    const url = new URL(event.request.url);

    const height = url.searchParams.get("height") || 200;
    const width = url.searchParams.get("width") || 500;

    console.log("image requested");
    event.respondWith(
      fetch(
        `https://placehold.co/${height}x${width}?text=This image does not exist`
      )
    );
  }
});