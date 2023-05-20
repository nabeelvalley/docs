import { WebContainer } from '@webcontainer/api';
import { useEffect, useRef, useState } from "react"

import type {Terminal} from 'xterm' 
import 'xterm/css/xterm.css';


interface Props {

}

/**
 * Only a single container instance may be booted and exist at any given time
 */
let instance: WebContainer | undefined = undefined
const useContainer = (setServer) => {
  const [booted, setBooted] = useState(!!instance)

  // we only manage a single container instance
  if (!booted) {
    WebContainer.boot().then((result) => {
      instance = result;
      result.on('server-ready', (port, url) => setServer(url))
      setBooted(true)
    })
  }

  return instance
}


/** @satisfies {import('@webcontainer/api').FileSystemTree} */

export const files = {
  'index.js': {
    file: {
      contents: `
  import express from 'express';
  const app = express();
  const port = 3111;
  
  app.get('/', (req, res) => {
    res.send('Welcome to a WebContainers app! 🥳');
  });
  
  app.listen(port, () => {
    console.log(\`App is live at http://localhost:\${port}\`);
  });`,
    },
  },
  'package.json': {
    file: {
      contents: `
  {
    "name": "example-app",
    "type": "module",
    "dependencies": {
      "express": "latest",
      "nodemon": "latest"
    },
    "scripts": {
      "start": "nodemon --watch './' index.js"
    }
  }`,
    },
  },
};

const useTerminal = (ref, onCommand) => {
  const instanceRef = useRef<Terminal>()
  const [input, setInput] = useState<string>("")

  if (!instance) {
    import('xterm').then(xterm => {
      const term = new xterm.Terminal({
        convertEol: true,
        disableStdin: false
      });
      
      term.open(ref.current);      
      instanceRef.current = term
    }).catch(console.error)
  }

  return instanceRef.current
}

type Status = 'loading' | 'done' | 'initial'
export default () => {
  const [status, setStatus] = useState<Status>('initial')
  const [server, setServer] = useState<string>();

  const container = useContainer(setServer)

  const terminalRef = useRef(null)
  const terminal = useTerminal(terminalRef, console.log)

  console.log({terminal})

  async function startShell() {
    const shellProcess = await container?.spawn('jsh');
    shellProcess.output.pipeTo(
      new WritableStream({
        write(data) {
          terminal.write(data);
          console.log(data)
        },
      })
    );
  
    const input = shellProcess.input.getWriter();
    terminal.onData((data) => {
      input.write(data);
    });
  
    return shellProcess;
  };
  
  if (status === 'initial' && container) {
    setStatus('loading')
    container.mount(files).then(() => {
      setStatus('done')
      startShell()
    })
  }

  return <>
    <div>Web Container: {status}</div>
    <div ref={terminalRef}></div>
    <div>{server ? `Visit app on ${server}` : 'Start app with "npm install && npm start" '}</div>
  </>
}

export const prerender = false;