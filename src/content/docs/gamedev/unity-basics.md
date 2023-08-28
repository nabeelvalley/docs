---
published: true
title: Unity Basics
subtitle: Basic Game Development using Unity
---

---
published: true
title: Unity Basics
subtitle: Basic Game Development using Unity
---

> Notes from [this series](https://www.youtube.com/watch?v=_uO5B7bP9jo&list=PLX2vGYjWbI0TiP080ELGDurOmz5NAg5CI)

# Setting Up

Create a new 3D Project with the Universal Render Pipeline and select a folder to save the project to, if this is the first time creating a Unity Project it may take some time to load

You may also need to set Visual Studio as the Editor using `Edit > Preferences > External Tools` and selecting Visual Studio as the External Script Editor. Even if you want to use VSCode just set this up once so that the `csproj` files are generated. Alternatively, you can select VSCode, select the generated files you want, and then click `Regenerate Project Files`

# Scenes

Scenes are ways to store and separate sections of your game, like levels for example, typically scenes are saved in `Assets/Scenes`. To Create a Scene use `File > New Scene` and save it with a name

We can add simple objects to the Scene by using primitives, we can create these using `GameObject > 3D Object > Object Type` or by right clicking in the Scene's object hierarchy in the left panel

- `f` - fit entire scene to your screen
- `r` - scale tool
- `w` - move tool
- `e` - rotate tool
- `t` - transform tool
- `alt + drag` - rotate screen
- `ctrl + alt + drag` - tranlate screen

The standard Unity lighting and physics systems use the measurement base unit to be 1m

# Materials

To set a colour or texture you make use of a Material, these are stored in `Assets/Materials`, you can create a new Material by right clicking on the folder and selecting `Create > Material`

To apply a material to an object just drag the material over the object you'd like to assign it to

A Matte material may have settings like:

- Metallic Map: `0`
- Smoothness: `0.25`

A Shiny material may look more like:

- Matallic Map: `0`
- Smoothness: `0.75`

# RigidBody

To use physics a game object needs a RigidBody component. To do this you need to select `Add Component > RigidBody` in a component inspector

# Player Movement

Player movement can be handled using the Input System pacakge to apply forces with a script that's attached to an object

To install the package go to `Window > Package Manager > Input System (search) > Install` which will then reload Unity

You will also need to go to `File > Build Settings` and select the architecture to be `x86_64`

Next, on a Player object select `Add Component > Player Input` and then create an `Input Action` Asset. To create this select `Create Actions` in the Input Action Inspector and save it in `Assets/Inputs`. If you get a `NullReferenceException` when trying to do this it may still have created the action but not assigned it to the object, if that happens just drag it into the `Actions` field of the object

# Scripting

Scripts are stored in `Assets/Scripts` which make use of C#. To create a new script you can do `Assets > Create` or select an object, and select `Add Component > New Script` in the inspector which will create an attach a script at once.

A newly created script, for example `PlayerController.cs` may look like so:

`PlayerController.cs`

```cs
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {

    }
}
```

To use a `PlayerInput` we need to apply an input to the object. We can use either `Update` to apply a change to an object immediately before render or `FixedUpdate` to apply a change before physics calculation. To move an object we'd like to make use of `FixedUpdate`

Once we add some handlers like the `OnMove` to handle Input Actions, and use the `FixedUpdate` function to set a force on the object, we've got something like this:

`PlayerController.cs`

```cs
using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerController : MonoBehaviour
{
    private Rigidbody _rigidBody;
    private float _movementX;
    private float _movementY;

    // Start is called before the first frame update
    void Start()
    {
        // Get the RigidBody data for the object
        _rigidBody = GetComponent<Rigidbody>();
    }

    // FixedUpdate is called before physics calculations
    void FixedUpdate()
    {
        var movement = new Vector3(_movementX, 0.0f, _movementY);

        _rigidBody.AddForce(movement);
    }

    // Handle the OnMove event
    void OnMove(InputValue movementValue)
    {
        // Get the movement vector from the input value
        var movementVector = movementValue.Get<Vector2>();

        _movementX = movementVector.x;
        _movementY = movementVector.y;
    }
}
```

Next, we can add a `public float force` variable to expose a force multiplier that can be set from the Object Inspector itself. After doing that and implementing the multiplers the code should look like this:

`PlayerController.cs`

```cs
using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerController : MonoBehaviour
{
    public float Force = 1;

    private Rigidbody _rigidBody;
    private float _movementX;
    private float _movementY;

    // Start is called before the first frame update
    void Start()
    {
        // Get the RigidBody data for the object
        _rigidBody = GetComponent<Rigidbody>();
    }

    // FixedUpdate is called before physics calculations
    void FixedUpdate()
    {
        var movement = new Vector3(_movementX, 0.0f, _movementY);

        _rigidBody.AddForce(movement);
    }

    // Handle the OnMove event
    void OnMove(InputValue movementValue)
    {
        // Get the movement vector from the input value
        var movementVector = movementValue.Get<Vector2>();

        _movementX = movementVector.x * Force;
        _movementY = movementVector.y * Force;
    }
}
```

> `public` variables can be modified from the Object Inspector when associating a script

# Camera Movement

When setting up movement for the camera you will typically set it up as a child of a game object, this can be done by dragging the Camera object over the game object you want to use, such as the player, in the Object Hierarchy

When we link the objects, all the movements of our player will be passed on to the camera, we typically don't want this and would normally be better off by restricting the camera movement

If our child object is rotating we might be better off by associating the two objects by using a script instead of settnig it as a child

Create a new Script called `CameraController.cs` by using `Add Component > New Script` from the Object Inspector

Since the `CameraController` will be positioned based on the child object, we will want to set that as a property for the `CameraController`, we can do this by having a `public GameObject` field in the `CameraController` class. In general, the equation that governs our relative positions is:

```
CameraPosition = PlayerPosition + CameraOffset
```

We can apply the above with:

`CameraController.cs`

```cs
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour
{

    public GameObject Player;
    private Vector3 _offset;

    // Start is called before the first frame update
    void Start()
    {
        // The Offset is Camera Position - Player Position
        _offset = transform.position - Player.transform.position;
    }

    // LateUpdate is called once per frame after the Update method is run
    void LateUpdate()
    {
        // The new Position is the Player Position + Camera Offset
        transform.position = Player.transform.position + _offset;
    }
}
```

# Rotating Objects

We can create a cube that can be used as a simple collectible, we can make this rotate by using the `Update` function and setting the rotation based on this:

```cs
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PickupController : MonoBehaviour
{
    void Update()
    {
        // Rotate based on dT to ensure constant position updates
        var rotation = new Vector3(15, 30, 45) * Time.deltaTime;

        transform.Rotate(rotation);
    }
}
```

# Prefabs

A Prefab is an asset that functions as a Game Object template. Prefabs can be accessed in different scenes, and we can make a change to a single instance or to the Prefab itself and it will update across scenes if we update a single object

To create a Prefab select the Game Object from the heirarchy into the `Assets/Prefabs` folder. You can then double click on the prefab that was created and it will take you into the prefab editor

To contain instances of this prefab we can create an empty Game Object, e.g. `PrefabParent` and place instances of the Prefab within that

# Collisions

We use the `OnTriggerEnter` function that triggers when a collision is detected, we then use the Unity Tagging system to identify what object type the collision happened with

To set a tag for an object or prefab, go to the object inspector for the Game Object, and create a new tag for the object, for example `Pickup`

Select the `BoxCollider` component's `IsTrigger` property to allow for the collider to work as a collider

> `Colliders` stop physics objects from passing through each other, `TriggerColliders` notify us when there is a contact via the `OnTriggerEnter` event

We can also add a `RigidBody` object to prevent Unity from treating the object as static as this will be more difficult for Unity to calculate physics each frame, howver if the object has `IsTrigger` selected this will cause it to fall through game objects when influenced by physics, we can enable `IsKinematic` on the `RigidBody` whcih will not react to forces, but can only be moved via transforms

Once setting all the above and implementing the `OnTriggerEnter` function on the `PlayerController` so we can detect when the player collides, we will have the following:

`PlayerController.cs`

```cs
using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerController : MonoBehaviour
{
    public float Force = 1;

    private Rigidbody _rigidBody;
    private float _movementX;
    private float _movementY;

    // Start is called before the first frame update
    void Start()
    {
        // Get the RigidBody data for the object
        _rigidBody = GetComponent<Rigidbody>();
    }

    // FixedUpdate is called before physics calculations
    void FixedUpdate()
    {
        var movement = new Vector3(_movementX, 0.0f, _movementY);

        _rigidBody.AddForce(movement);
    }

    // Handle the OnMove event
    void OnMove(InputValue movementValue)
    {
        // Get the movement vector from the input value
        var movementVector = movementValue.Get<Vector2>();

        _movementX = movementVector.x * Force;
        _movementY = movementVector.y * Force;
    }

    // Handle event on entering a collision object
    void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Pickup"))
            other.gameObject.SetActive(false);
    }
}

```

# Storing State Information

We may want to store state information like scores, there are a few ways we can do this, one of which would be keeping it stored in a variable on our Player object, and updating the variable when needed, for example:

```cs
using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerController : MonoBehaviour
{
    private int _score;

    // Start is called before the first frame update
    void Start()
    {
        // Get the RigidBody data for the object
        _rigidBody = GetComponent<Rigidbody>();
        _score = 0;
    }

    // ...

    // Handle event on entering a collision object
    void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Pickup"))
        {
            other.gameObject.SetActive(false);
            _score++;
        }
    }
}
```

# Adding UI

To add some UI Text you can use the `UI > TextMeshPro`, we can move around text as well as use anchoring to position it in the canvas, you can additionally use `shift + alt + click` in the `Rect Transform` in the Object Inspector to change the way the position types work

To access the UI content programatically, such as the Text, we just need to add the appropriate object as an input where needed. To access the `TextMeshPro` object we use a property such as `public TextMeshProUGUI ScoreText` which we can set from the Unity UI, using this we can set the text content when our score updates like so:

`PlayerController.cs`

```cs
using UnityEngine;
using UnityEngine.InputSystem;
using TMPro;

public class PlayerController : MonoBehaviour
{
    public TextMeshProUGUI ScoreText;

    // ...

    // Start is called before the first frame update
    void Start()
    {
        // Get the RigidBody data for the object
        _rigidBody = GetComponent<Rigidbody>();

        // Set the score state and UI
        _score = 0;
        SetCountText();
    }

    // ...

    // Handle event on entering a collision object
    void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Pickup"))
        {
            // Hide Game Objects
            other.gameObject.SetActive(false);

            // Update score state and UI
            _score++;
            SetCountText();
        }
    }

    // Set the score text in the UI
    private void SetCountText()
    {
        ScoreText.text = $"{_score} pts.";
    }
}
```
