> From the [Action RPG Series by HeartBeast](https://www.youtube.com/watch?v=mAbG8Oi-SvQ&list=PL9FzW-m48fn2SlrW0KoLT4n5egNdX-W9a)

# Getting Started

You will first need to [download the Godot Engine](https://godotengine.org/download/windows). You can use C# as the language but will require you to have the Visual Studio Build tools prereqs installed as well

Next, extract and launch the Godot executable and select a location for your game's folder

YOu can then go to `Project > Project Settings` to confugire your project settings

An appropriate window size for pixel art you can go to `Display > Window` and set a Width of `320` and Height of `180`, since this will make your game's preview window really small you'll also want to change the Test Height and Width, something like `1280 / 720` may work, and set a Stretch Mode to `2d` in the same menu

# Adding Game Resources

To import resources you can select the `Import` tab at the top of the left panel to configure the import settings before importing your resources

If you're importing assets for 2D or 2D pixel art, set this appropriately prior to importing

Therafter, you can just drag the resources into the bottom left `FileSystem` panel

You can then drag an image into the game area to see what it looks like in the scene

# Setup the Scene Type

Before you can start working you'll need to setup your Root Scene node, select 2D or 3D for the root scene node as appropriate, I'll be using 2D

Then click `Scene > Save` to save the Scene

You can then run by clicking the play icon in the top right of the window

Godot uses a collection of Scenes and Nodes to organize game content

- Zoom in and out with your scroll wheel
- Pan the scene by right clicking and dragging

# Create a Character

To add a Character to a game we will add a `KinematicBody2D` node and we can add this via the `+` button in the Scene panel

Godot has a few different `PhysicsBody2D` types:

- `KinematicBody2D` - will let us apply kinematic motion to it
- `RigidBody2D` - will use physics to control their behaviour
- `StaticBody2D` - will not move

Next, we can right click on the `KinematicBody2D` node to rename it as `Player`, and we can click on the `Player` node and add a `Sprite` node as a child and then drag an image to use into the `Texture` field of the `Sprite` node

To only show a single image in the Sprite you need to go to the `Animation` section of the Sprite and set the number of `HFrames` or `WFrames`

When moving things around you may accidentally move around a child of a selected node instead of the node itself, to avoid this select the `Player` node on the left, and the icon with the two squares to `Make sure the object's children are not selectable` which will make sure that child elements of the `Player` node are not moved accidentally. To move a child, you can select it in the node list and move it while holding `alt`

# Add a Script

To make your `Player` movable you can add a script to it from the `Attach Script` button on the top of the left scene panel, and add a name for the script, I'm going to use `Player.gd`. The initialized script will look something like this:

`Player.gd`

```py
extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
```

We can see that the above extends `KinematicBody2D` and a script must extend the type of the object it is attached to. The `_ready` function runs when the object is added to a scene. Functions starting with `_` are callback functions on an object and are called on a specific event

> GD Script is based on Python, other languages are supported by GD is the best supported, you can use the `geequlim.godot-tools` VSCode Extension as well as the Godot Editor

It's also possible to drag an existing script from the resources panel onto an object to attach it

To move our character we use the `_physics_process(delta)` callback, where the `delta` is the amount of time since the last physics process, the `delta` here is constant as opposed to the `_process` function in which it varies based on framerate

Any user inputs are stored in the `Input` object, we can use this to read the input

> `down` and `right` are `positive`, `up` and `left` are negative

The code to handle basic direction inputs would look like so:

`Player.gd`

```py
extends KinematicBody2D

var velocity = Vector2.ZERO

func set_velocity_from_input():
	var input_vector = Vector2.ZERO

	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	if input_vector != Vector2.ZERO:
		 velocity =  input_vector
	else:
		velocity = Vector2.ZERO

	move_and_collide(velocity)

func _physics_process(_delta):
	set_velocity_from_input()
```

Adding acceleration and deceleration as well as `export`ing the configuration variables we end up with the code as follows:

`Player.gd`

```py
extends KinematicBody2D

export var MAX_SPEED    : float = 120
export var ACCELERATION : float = 480
export var FRICTION     : float = 480

var velocity = Vector2.ZERO

func set_velocity_from_input(delta):
	var input_vector = Vector2.ZERO

	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	# if the input is non-zero update using input
	if input_vector != Vector2.ZERO:
		# use a normalized (unit) vector
		velocity = velocity.move_toward(input_vector * MAX_SPEED,
										ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	# move the player and update with the returned velocity
	velocity = move_and_slide(velocity)

func _physics_process(delta):
	set_velocity_from_input(delta)
```

> The inclusion of `delta` ensures the speed remains constant regardless of the user's device or frame rate, however you can consider leaving this out as the `_physics_process` function _should_ be called at a constant rate unless the user's device starts lagging

# Collisions

We can add a collider to handle collisions on objects, you can add a `CollisionShape2D` which will allow you to handle this, you will then need to select the shape that you want to use, our collisions will then be handled correctly using the `move_and_slide` function we set above

# Scenes

Godot has the ability to convert anything to a scene, this allows us to re-use a specific collection of preconfigured nodes - similar to prefabs in Unity

To save a node and its children as a scene you can `right click` on `Save Branch as Scene`

> Make sure that when creating a scene you've got the location set to the origin so that the location isn't off when reusing the scene

By default, the order of elements in the scene is based on the position in the heirarchy, but if we've got a 2D world scene and we want our collisions to allow us to go behind or in front of an element, and it should do this based on some kind of sorting, we can change our root 2D node, we can `right click` on the `Node2D` and select `Change Type` and pick `YSort`, depending on our usecase this may be a really quick solution to the problem mentioned

> A Potential problem using `YSort` can be that it will sort based on the center of node, so you may need to consider the effects of that

# Animation

> Sprite animation can either be done with the `AnimationPlayer` or `AnimatedSprite` nodes. The `AnimationPlayer` is a more generic form of the latter

Adding an `AnimationPlayer` node to our `Player` will allow us to define an animation

When the `AnimationPlayer` is selected click `Animation > New` in the bottom panel

Next, set your snap to `0.1` at the bottom, and set the duration to the time you'd want to use

In our case, we would want to animate the `Frame` of our sprite, to do this select the sprite, set the frame you want to use as the first animation frame, and click on the key icon next to the frame number then click `Create`, Godot will automatically move the frame by the `snap` and increment the `Frame` so that you can very easily add the next frame

You can also set the animation to loop, as well as play or stop the animation and view it in the editor

Next, we'll need access to our animation player node from our parent node, we can access any children using the `$` and react our node based on its path. We do it in the `_ready` function so we can access it once it's ready, like so:

```py
var animationPlayer : AnimationPlayer = null

func _ready():
	animationPlayer = $AnimationPlayer
```

Alternatively, we can use an `onready var` to define an instance variable in Gedot which will assign the variable once it's ready, instead of using the `_ready` function:

```py
onready var animationPlayer : AnimationPlayer = $AnimationPlayer
```

You can implement a basic animation setting function using the `animationPlayer.play("animationName")` but an easier solution would be using an `AnimationTree`

Create an `AnimationTree` by adding a node to the hierarchy for the `Player` node

Once we've added an `AnimationTree` we will need to set the `Anim Player` property to the node we want to use. Next, for the `Tree Root` we will select `New AnimationNodeStateMachine` and check off `Active`

Right click in the empty area in the Animation Editor, and click `Add Animation` to get an animation to start with. You can then add another node, and use the `Connect nodes` button at the top left of the animation editor and click and drag between nodes to connect them. You can also set properties for the animation transitions if needed by clicking on the joining line

To have direction-based animation states we'll want to add a `BlendSpace2D` inside of the Animation Editor section of the `AnimationNodeStateMachine`

To add animation nodes click on the pencil icon on the node to go to the visual layout for the `BlendSpace2D` you just added, then click on the pencil icon at the top left of the 2D Blend Space editor (`Create Points`) and click in the relative positions that your animation would be. E.g run up would be upwards, etc. Add a few animations in here with their relative positions

You can then click at the `Set blending position` icon at the top right and click within the internal animation space to set an animation based on a specific location. Since we're using sprites here you also need to set the `Blend` to the `...` option and start the animation in `root` to preview the animation changing

You may also want to set a specific animation in the tree (if you have multiple) to run on load, you can do this from an animation in the `AnimationTree` while an animation is selected by clicking the `Toggle autoplay this animation on start` at the top of the Animation Editor

We will want to manipulate the `blend_position` for the respective animation is what we'll want to set programatically. To get the path for a parameter, like the `blend_position`, you need to view the `AnimationTree` properties and howver over the `Blend Position` for the animation you want to target, and look at the path shown, you would set this like so:

```py
animationTree.set("parameters/Idle/blend_position", input_vector)
```

Overall, using the above logic for setting an animation we can start an animation from the `AnimationState` using the `travel` function. Taking all this into consideration, a `Player` script would look something like this:

`Player.gd`

```py
extends KinematicBody2D

export var MAX_SPEED    : float = 120
export var ACCELERATION : float = 120*4
export var FRICTION     : float = 120*8

onready var animationTree  : AnimationTree = $AnimationTree
onready var animationState : AnimationNodeStateMachinePlayback = animationTree.get("parameters/playback")

var velocity : Vector2 = Vector2.ZERO

func set_velocity_from_input(delta):
	var input_vector = Vector2.ZERO

	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	# if the input is non-zero update using input
	if input_vector != Vector2.ZERO:
		# setup blend_position for each animation
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)

        # set animation to use
        animationState.travel("Run")

		# use a normalized (unit) vector
		velocity = velocity.move_toward(input_vector * MAX_SPEED,
										ACCELERATION * delta)
	else:
        # set animation to use
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	# move the player and update with the returned velocity
	velocity = move_and_slide(velocity)

func _physics_process(delta):
	set_velocity_from_input(delta)
```

# Backgrounds

> If your world is a `YSort` you may need to change it back to a `Node2D` and have separte nodes for your background and environment, with a new `YSort` inside of it

If you want to set a background for the game, drag a sprite into the scene, and enable `Region`, and then open the `TextureRegion` panel at the bottom of the screen with the sprite selected

Next, reimport your texture by clicking on it in the FileSystem, the clicking `Import` on the left panel, selecting the `Repeat` as `Enabled` and then click `Reimport`

You can then resize the sprite in the `TextureRegion` to fit your game space

# Tilemaps

To create a tilemap you need to add a `TileMap` node, set the `Cell Size` and then set the `Tile Set` to `New TileSet`

If you then click on the `TileSet` resource a `TileSet` window will pop up below. You can then drag sprites from the `FileSystem` panel into the left section of the `TileSet` panel at the bottom

Once we've imported a tileset you can select one of the tile types at the top:

- Single Tile
- Auto Tile
- Tile Atlas

Once you click on one of the tiles you'll get a region that you'll need to drag and configure in your `TileSet` panel. YOu can also click the `Snap` icon so that you have a grid to snap to when creating your region

Now that the region has been created you'll see a `Snap Options` section on the Inspector on the right. You can then set your `Step` options to match what your tilemap uses and go and reselect your region to fit

Next, click inside the region and go to `Selected Tile`, from there you need to ensure the `Subtile Size` is set to your tilemap size again and select `3x3 (minimal)` as the `Autotile Bitmask Mode`, then click `Bitmask` at the top of the `TileSet` panel

Then ext step is to set when each tile should be placed by the autotile, you then need to highlight the sections of the tile that are not the wall (e.g. the parts that a character would walk on). Take a look at [this explanation](https://kidscancode.org/godot_recipes/2d/autotile_intro/) because the process is a bit difficult to explain

> Right clicking in the bitmask erases

Next, save and click back on the `TileMap` in your scene heirarchy, select the tile, and set the `Cell` size for your tile. You can then click and drag around the map space and it will add tiles from your tile set

You can add collissions to tiles in the tileset using the `TileSet` editor, on the panel select the tileset click on collision, you can then select the square or polygon tool from the actions menu and click on the tile you'd want to make collide-able. If you'd like to make your tiles be "higher" than the ground you can also setup the `z-index` option

On Tilesets you can also setup Occulsion which allows the tiles to interact with Godot's lighting system and Navigation which allows Godot's navigation system for NPC's to understand tilesets

You can also setup some elements of differing placement for the same tile positions for different tiles in a set by giving different ones different priority levels