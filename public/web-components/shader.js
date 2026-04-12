// @ts-check

/**
 * @param {HTMLCanvasElement} canvas
 * @param {string} shader - WebGPU Shader
 * @returns {Promise<((saveTo?: string) => void) | undefined>} renderer function. Will be `undefined` if there is an instantiation error
 */
export async function setupCanvas(
  canvas,
  shader,
) {
  // @ts-ignore
  const adapter = await navigator.gpu?.requestAdapter()
  const device = await adapter?.requestDevice()
  if (!device) {
    return
  }

  /**
   * @type {any}
   */
  const ctx = canvas?.getContext('webgpu')
  if (!ctx) {
    return
  }

  // @ts-ignore
  const format = navigator.gpu.getPreferredCanvasFormat()
  ctx.configure({
    device,
    format,
  })

  const module = device.createShaderModule({
    label: 'base shader',
    code: shader,
  })

  const uTime = device.createBuffer({
    size: [4],
    // @ts-ignore
    usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST,
  })

  let curr = 1

  const texture = device.createTexture({
    size: { width: canvas.width, height: canvas.height },
    format: 'rgba8unorm',
    // @ts-ignore
    usage: GPUTextureUsage.TEXTURE_BINDING | GPUTextureUsage.COPY_DST | GPUTextureUsage.RENDER_ATTACHMENT
  });


  const sampler = device.createSampler({
    addressModeU: "clamp-to-edge",
    addressModeV: "mirror-repeat",
    magFilter: "linear",
  });

  const htmlInCanvas = canvas.hasAttribute('layoutsubtree')

  if (htmlInCanvas) {
    // @ts-expect-error this is part of the WIP API for html-in-canvas
    canvas.onpaint = () => {
      console.log('paint')
      device.queue.copyElementImageToTexture(canvas.querySelector('.html-in-canvas'), canvas.width, canvas.height, { texture })
    }

    // @ts-expect-error this is part of the WIP API for html-in-canvas
    canvas.requestPaint()
  }

  const pipeline = device.createRenderPipeline({
    label: 'render pipeline',
    layout: 'auto',
    vertex: {
      module,
    },
    fragment: {
      module,
      targets: [
        {
          format,
        },
      ],
    },
  })

  const bindGroup0 = htmlInCanvas && 
    device.createBindGroup({
      label: 'textures',
      layout: pipeline.getBindGroupLayout(0),
      entries: [
        { binding: 0, resource: sampler },
        { binding: 1, resource: texture.createView() },
      ],
    });

  const bindGroup1 = device.createBindGroup({
    label: 'uniforms',
    layout: pipeline.getBindGroupLayout(1),
    entries: [
      { binding: 0, resource: { buffer: uTime } }
    ],
  });

  /**
   * @param {string} [saveTo]
   */
  function render(saveTo) {
    curr += 0.1

    // https://stackoverflow.com/questions/70284258/destroyed-texture-texture-used-in-a-submit-when-using-a-video-texture-in-ch
    // render pass descriptor needs to be recreated since this doesn't live very long on the GPU
    const renderPassDescriptor = {
      label: 'render pass descriptor',
      colorAttachments: [
        {
          loadOp: 'clear',
          storeOp: 'store',
          clearValue: [0, 0, 0, 0],
          view: ctx.getCurrentTexture().createView(),
        },
      ],
    }

    const encoder = device.createCommandEncoder({ label: 'command encoder' })
    const pass = encoder.beginRenderPass(renderPassDescriptor)

    pass.setPipeline(pipeline)

    if (bindGroup0) {
      pass.setBindGroup(0, bindGroup0)
    }

    pass.setBindGroup(1, bindGroup1)
    device.queue.writeBuffer(uTime, 0, new Float32Array([curr]));

    pass.draw(6) // call our vertex shader 6 times
    pass.end()


    const commandBuffer = encoder.finish()
    device.queue.submit([commandBuffer])
    if (saveTo) {
      // saving must be done during the render
      downloadCanvas(canvas, saveTo)
    }
  }

  return render
}

/**
 * @param {HTMLCanvasElement} canvas
 * @param {string} name
 */
function downloadCanvas(canvas, name) {
  const data = canvas.toDataURL('image/png')
  const link = document.createElement('a')

  link.download = name.split('.').slice(0, -1).join('.') + '.png'
  link.href = data
  link.click()
  link.parentNode?.removeChild(link)
}
