const originDirectory = '/docs'
const destination = {
  hostname: "yamasolutions.github.io/integral/",
  subdirectory: "/docs/",
  assetsPathnames: ["/js/", "/css/", "/img/"]
}

async function handleRequest(request) {
  // returns an empty string or a path if one exists
  const formatPath = (url) => {
    const pruned = url.pathname.split("/").filter(part => part)
    return pruned && pruned.length > 1 ? `${pruned.join("/")}` : ""
  }

  const parsedUrl = new URL(request.url)
  const requestMatches = match => new RegExp(match).test(parsedUrl.pathname)

  if (requestMatches(originDirectory)) {
    console.log("this is a request for a destination document", parsedUrl.pathname)
    const targetPath = formatPath(parsedUrl)

    return fetch(`https://${destination.hostname}/${parsedUrl.pathname}`)

  } else if (destination.assetsPathnames.some(requestMatches)) {
    console.log("this is a request for destination assets", parsedUrl.pathname)
    const assetUrl = request.url.replace(parsedUrl.hostname, destination.hostname);

    return fetch(assetUrl)
  } else {
    console.log("Request passed directly through worker: ", parsedUrl.host, parsedUrl.pathname)
    return fetch(request)
  }
}

addEventListener("fetch", event => {
  event.respondWith(handleRequest(event.request))
})
