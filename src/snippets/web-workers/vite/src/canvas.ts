export function animate(canvas: HTMLCanvasElement | OffscreenCanvas) {
  const ctx = canvas.getContext('2d')!

  let curr = 0
  const run = (dt: number) => {
    curr += dt / 10000

    const aspect = canvas.width / canvas.height

    const w = (curr * aspect) % canvas.width
    const h = curr % canvas.height

    ctx.fillStyle = 'white'
    ctx.clearRect(0, 0, canvas.width, canvas.height)

    ctx.fillStyle = 'red'
    ctx.fillRect((canvas.width - w) / 2, (canvas.height - h) / 2, w, h)
    ctx.fill()

    requestAnimationFrame(run)
  }

  run(0)
}
