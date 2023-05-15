---
published: true
title: Smooth Bottom Navigator with Secondary Actions
subtitle: 15 December 2022
description: A Smooth Bottom Navigator using CSS Transitions and Svelte
---

---
title: Smooth Bottom Navigator with Secondary Actions
subtitle: 15 December 2022
description: A Smooth Bottom Navigator using CSS Transitions and Svelte
---

Not dissimilar from my previous post on the [expanding bottom nav](/blog/2022/13-11/svelte-expanding-nav) this expands on the idea of animating between states in the navigator in a more global way, this version makes use of a similar animation/transition pattern but does so by modifying the heights as well as the absolute positioning of different components

The implementation below takes the overall concept to the simplest possible state, however some refinements that can still be made include being responsive to the size of the additional content as well as doing a more accurate calculation on how large the sliding tab should be and how it's placed

The values for the padding/positions are very hardcoded, but in practice you'd likely want to make these respond to data provided and size appropriately in regards to rest of the component

Here's the svelte code below:

```html
<script>
  import {
    InboxIcon,
    HomeIcon,
    DatabaseIcon,
    MessageCircleIcon,
    MicIcon,
    MusicIcon,
  } from "svelte-feather-icons";

  let selected = "home";

  const icons = [
    {
      id: "home",
      icon: HomeIcon,
    },
    {
      id: "database",
      icon: DatabaseIcon,
    },
    {
      id: "message",
      icon: MessageCircleIcon,
    },
    {
      id: "mic",
      icon: MicIcon,
    },
  ];

  $: selectedIndex = icons.findIndex((item) => item.id === selected);
  $: expanded = selected === "mic";
</script>

<h1>{selected}</h1>

<div class="wrapper">
  <div class="background" class:expanded class:collapsed={!expanded}>
    <div
      class="slider"
      style="--left: {(selectedIndex / icons.length) * 100}%;--right: {((selectedIndex+1) / icons.length) * 100}%;"
    />
    <div class="content" class:expanded class:collapsed={!expanded}>
      <MusicIcon />
      <p>Recording: 00:01:23</p>
    </div>
  </div>

  <div class="items">
    {#each icons as icon}
      <div
        class="item"
        on:click={() => (selected = icon.id)}
        on:keypress={console.log}
      >
        <svelte:component this={icon.icon} />
      </div>
    {/each}
  </div>
</div>

<style global>
  /* uses fixed postion in order to lock it to lock the component to the bototom of the screen */
  .wrapper {
    position: fixed;
    width: 100vw;
    bottom: 0px;
  }

  /* ensure the background and items are all placed the same since they need to overlap	 */
  .items,
  .background {
    height: 0px;
    position: absolute;
    left: 0px;
    bottom: 20px;
    right: 0px;
    max-width: 80vw;
    margin-left: auto;
    margin-right: auto;
  }

  .background {
    border: solid 1px black;
    border-radius: 16px;
    background-color: white;
    height: 52px;

    transition: height 300ms ease-in-out;
  }

  .background.collapsed {
    transition-delay: 150ms;
  }

  .background.expanded {
    height: 100px;
    transition-delay: 0ms;
  }

  .content {
    overflow: hidden;
    display: flex;
    flex-direction: row;
    gap: 16px;
    height: 24px;
    opacity: 1;
    padding: 20px 40px;
    transition: all 300ms ease-in-out;
  }

  .content.collapsed {
    height: 0;
    opacity: 0;
    padding: 0px 40px;
    transition-delay: 0ms;
  }

  .content.expanded {
    height: 24px;
    opacity: 1;
    transition-delay: 150ms;
  }

  .content p {
    margin: 0;
  }

  .slider {
    position: absolute;
    left: calc(var(--left) + 6px);
    right: va(--left);
    bottom: 6px;
    height: 40px;
    width: calc(var(--right) - var(--left) - 12px);
    border-radius: 12px;
    background-color: #87b5eb70;
    transition: left 300ms ease-in-out;
  }

  .items {
    display: flex;
    flex-direction: row;
    justify-content: space-around;
    height: 40px;
  }

  /* set the icon color	 */
  .item {
    color: black;
  }

  /* select a better default font */
  * {
    font-family: Arial, Helvetica, sans-serif;
    margin: 0;
    padding: 0;
  }
</style>
```

And the current version of the component can be seen here:

<iframe height="400px" width="100%" src="https://repl.it/@nabeelvalley/AnimatedBottomNav?lite=true" scrolling="no" frameborder="no" allowtransparency="true" allowfullscreen="true" sandbox="allow-forms allow-pointer-lock allow-popups allow-same-origin allow-scripts allow-modals"></iframe>
