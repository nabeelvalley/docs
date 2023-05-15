---
published: true
title: Expanding Bottom Navigation with CSS Transitions
subtitle: 13 November 2022
description: A bottom navigation with expanding icons using CSS Transitions and Svelte
---

---
title: Expanding Bottom Navigation with CSS Transitions
subtitle: 13 November 2022
description: A bottom navigation with expanding icons using CSS Transitions and Svelte
published: true
---

So I was looking around on YouTube and came across a video about this library called `google_nav_bar` for flutter and I really liked the idea of how it works and wanted to implement something similar in an app I've been working on

The basic functionality of the of the library can be seen on [`google_nav_bar` package page](https://pub.dev/packages/google_nav_bar)

I thought the main challenge of this would be implementing the fade-in of the text with the expanding content section, I took a first shot with the result below:

```html
<script>

	let selected = 'home';

	let items = ['home', 'search', 'archive', 'settings'];
	let colors = {
		home: 'lightpink',
		search: 'violet',
		archive: 'skyblue',
		settings: 'lightgrey'
	};
</script>

<svelte:head>
	<link rel="stylesheet" href="https://unpkg.com/mono-icons@1.0.5/iconfont/icons.css" />
</svelte:head>

<nav class="wrapper">
	<ul class="list">
		{#each items as item (item)}
			<li class="item" class:selected={selected === item} on:click={() => (selected = item)}>
				<div class="icon" style={`--bg: ${colors[item]}`}>
					<i class={`mi mi-${item}`} />
				</div>
				<div class="text">
					{item}
				</div>
			</li>
		{/each}
	</ul>
</nav>

<style>
	.mi {
		font-size: 24px;
	}

	.wrapper {
		display: flex;
		width: 100%;
	}

	.list {
		flex: 1;
		display: flex;
		flex-direction: row;
		align-items: center;
		justify-content: space-between;
		padding: 10px 20px;
	}

	.item {
		display: flex;
		flex-direction: row;
		align-items: center;
		gap: 8px;
		justify-content: flex-start;
	}

	.item .text {
		width: 0px;
		opacity: 0;
		overflow: hidden;
		transition: width 0.15s 0s, opacity 0.15s 0s;
	}

	.item.selected .text {
		width: 100px;
		opacity: 1;
		transition: width 0.15s 0s, opacity 0.15s 0.075s;
	}

	.icon {
		display: flex;
		align-items: center;
		justify-content: center;
		color: var(--bg);
		line-height: 0;
	}

	/* resets	 */
	ul {
		padding: 0;
		margin: 0;
	}

	li {
		margin: 0;
		list-style: none;
	}
</style>
```

I like the overall feel and I think the finicky bits of using the transition are done, but I'd still like to play around a bit more to see how close to the original library I can get it

For now though, here's the REPL with the current working state of the component:

<iframe height="400px" width="100%" src="https://repl.it/@nabeelvalley/ExpandingBottomNavItems?lite=true" scrolling="no" frameborder="no" allowtransparency="true" allowfullscreen="true" sandbox="allow-forms allow-pointer-lock allow-popups allow-same-origin allow-scripts allow-modals"></iframe>
