//@ts-check
import { parse } from 'postcss'

console.log(parse)

const parsed = parse(`
@media screen and (min-width: 480px) {
    body {
        background-color: lightgreen;
    }
}

#main {
    border: 1px solid black;
}

ul li {
	padding: 5px;
  
  @media screen and (min-width: 480px) {
    body {
        background-color: lightgreen;
    }
}
}

@keyframes my-anim {
  from {
  	background-color: blue
  }
  
  to {
  	background-color: red
  }
}
`)

const isGlobalNode = (node) =>
  node.type === 'atrule' && node.name === 'keyframes'

const toCSS = (nodes) => nodes.map((node) => node.toString()).join('\n\n')

const keyframes = toCSS(parsed.nodes.filter(isGlobalNode))

const rest = toCSS(parsed.nodes.filter((node) => !isGlobalNode(node)))

console.log(keyframes)

console.log('rest')

console.log(rest)
