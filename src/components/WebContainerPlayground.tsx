import { FileSystemTree, WebContainer } from '@webcontainer/api'
import { useRef, useState } from 'react'

import type { Terminal } from 'xterm'
import { FitAddon } from 'xterm-addon-fit'

import 'xterm/css/xterm.css'

interface Props {
  windowFileKey: string
  initialCommand?: string
  startCommand?: string
}

type SetServer = (url: string) => void

/**
 * Only a single container instance may be booted and exist at any given time
 */
let instance: WebContainer | undefined = undefined
const useContainer = (setServer?: SetServer) => {
  const [booted, setBooted] = useState(!!instance)

  // we only manage a single container instance
  if (!booted) {
    WebContainer.boot().then((result) => {
      instance = result
      result.on('server-ready', (_, url) => setServer?.(url))
      setBooted(true)
    })
  }

  return instance
}

const useTerminal = (ref) => {
  const instanceRef = useRef<Terminal>()

  if (!instance) {
    import('xterm').then((xterm) => {
      const term = new xterm.Terminal({
        convertEol: true,
        disableStdin: false,
        fontFamily: 'monospace',
        fontSize: 14,
      })

      const fitAddon = new FitAddon()
      term.loadAddon(fitAddon)
      term.open(ref.current)
      fitAddon.fit()
      instanceRef.current = term
    })
  }

  return instanceRef.current
}

const exec = async (
  container: WebContainer,
  terminal: Terminal,
  script: string
): Promise<void> => {
  const [command, ...args] = script.split(' ')

  const result = await container?.spawn(command, args)

  terminal.writeln(`> ${script}`)

  result?.output.pipeTo(
    new WritableStream({
      write(data) {
        terminal.write(data)
      },
    })
  )

  await result.exit
  terminal.writeln('')
}

type Status = 'loading' | 'done' | 'initial'
export default (props: Props) => {
  const [status, setStatus] = useState<Status>('initial')
  const [server, setServer] = useState<string>()
  const [initialized, setInitialized] = useState(false)

  const container = useContainer(setServer)

  const terminalRef = useRef(null)
  const terminal = useTerminal(terminalRef)

  const startShell = async () => {
    if (props.initialCommand) {
      await exec(container, terminal, props.initialCommand)
    }
    setInitialized(true)

    const shellProcess = await container.spawn('jsh')
    shellProcess.output.pipeTo(
      new WritableStream({
        write(data) {
          terminal.write(data)
        },
      })
    )

    const input = shellProcess.input.getWriter()
    terminal.onData((data) => {
      input.write(data)
    })

    return shellProcess
  }

  const files = window[props.windowFileKey] as FileSystemTree

  console.log({ files })

  if (status === 'initial' && container) {
    setStatus('loading')
    container.mount(files).then(() => {
      setStatus('done')
      startShell()
    })
  }

  return (
    <>
      {props.startCommand && initialized && !server ? (
        <p>
          Get started by running <code>{props.startCommand}</code> in the
          terminal above
        </p>
      ) : null}
      <div ref={terminalRef}></div>
      {server ? (
        <blockquote>
          Server running at{' '}
          <code>
            <a href={server}>{server}</a>
          </code>
        </blockquote>
      ) : null}
    </>
  )
}

export const prerender = false
