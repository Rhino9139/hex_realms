# Hex Realms - A experiment in game architecture.

## 🎯 Overview
This project is a direct clone of the board game "Settlers of Catan". I created this game to play with friends and learn more about game architecture.
All of the code follows the [GDScript Style Guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html) unless noted otherwise. 
The primary goal of this structure is organization, and a consistent layering structure for both game files and the flow of game logic.
This results in some extra code and steps in game logic in an effort to keep the architecture more homogenous but ultimately becomeing easier to read/refactor/debug etc.
Naming conventions and keywords will also be noted when apporopriate.

[Settlers of Catan Rules](https://www.catan.com/understand-catan/game-rules) The game follows the rules for the base game with 4 players.

#### This project is ongoing and far from complete. This document outlines the current structural design but many files/objects may still follow older design principles.

### Incomplete Game Sections
- Player Trading
- Bank Trading
- Year of Plenty action card
- Monopoly action card
- Victory Screen
- Misc. bugs


## 📂 File Structure

- **godot**
	- **_3D**
   		- **all 3D objects**
	- **_GUI**
   		- **all Control/UI objects**
	- **_LOGIC**
   		- **logic scripts**
	- **_MAIN**
   		- **entry point scene**
	- **_NETWORK**
   		- **server/client/player scripts**
	- **addons**
   		- **plugins**
	- **common**
   		- **Textures, materials, fonts etc**
	- **imports**
   		- **blender files, vox files**

## 🌐 Scene Tree Structure

- **Main**
	- **Master3D**
   		- **World**
    	- **Board**
    	- **Character**
	- **MasterGUI**
   		- **Menu**
    	- **HUD**
    	- **Screen**
	- **MasterNetwork**
   		- **ServerHost**
       	- **Client**
    	- **PlayerManager**
       	- **MultiplayerSpawner**
	- **MasterLogic**
   		- **MenuLogic**
       	- **MatchLogic**
      		- **TurnStateMachine**

The main scene show above is the root at all times. Currently, this main scene does not change with only children of the show nodes being added/removed. The "Master" nodes are for each domain and are purely organizational. Each Header has its own class of the same name. The game proceeds by the logic nodes telling the headers to add/remove objects and then telling the game objects what to do.

### Structure Breakdown
- **Main**
	- *Domain* (eg. _3D)
   		- *Header* (eg. board)
       		- *Sets* (eg. StandardBoard.tscn)
        		- *Game Objects* (eg. terrain hexes, robber piece)
            - *Game Objects* (eg. player camera, main menu)

#### Domians (3D, GUI, Logic, Main, Network)
The project is organized in the file system and scene tree by function with the top layer of organization called "Domains". 
These are given an underscore to start their name to group them together as most file navigation is done in these folders.


#### Headers (world, board, character, menu, hud, screen)
Headers are the top level of orgainization for all game Objects. The sole function of these nodes is to add and remove game objects that are organized under it. 
In the case where a large number of game objects are added/removed together, *Sets* are used, otherwise the header will spawn the game object directly.


#### Sets (standard board, game hud)
Sets are purely organizational and have no logic themselves. They simply hold a group of game objects than need to be spawned or removed together. Sets may have more than one layer for organization.
The main example of this is the Standard Board Set as it holds all of the terrain hexes, building nodes, roads etc.

#### Game Objects (building hotspots, robber piece, ui buttons etc.)
These are the smallest instantiated level of orgainization. Game Objects that share properties will either inherit from the same class (roads, buildings, and terrain hexes all inherit *Hotspot*) or share components.


### Pros
- Organization: all game files are easy to find within this structure
- Follows the scene tree structure in game so it mirrors the flow of game logic
- Scalable: adding and removing anything from game objects to whole new domains is effortless

### Cons
- Some domains are incompatable, not every domain requires all layers of organization making a slightly different structure, eg. the Network and Main domains only have a few total files
- Bloat: Nodes and scripts with minimal function are added to keep structure consistent
	- Some Headers only control one game object, eg. the Character Header only controls the player camera making what looks like redundant complexity
- Unsure of other project types: This game contains turn based logic, 3D objects that interact in specific and very predictable ways, and UI objects with a bulk of the game interaction.
This structure has been adapted to these requirements and I am uncertain how other genres and game types would fit into this style.

### Notes
The goal of this structure is to make the added 'bloat' of additional scripts and layers be a benefit. This expanding of logic and responsibility was intended to be compatible with any possible flow of logic between game objects. 
If done correctly, you should be able to immediately know the answer to questions like "How does this object spawn?" and "How does this object react to this game event?" with absolute certainty.

## ⚙️ Game Logic

### Event Bus
The game uses an autoload "Events" to hold all of the global signals. The autoload is also split into various inner class objects for organization. The inner classes are named after the Header of the object they interact with and whether they are emitted from or connected to the game object. "START" denotes the signal is emitted from the game object while "END" denotes the signal is connected to a callable on the game object. For example: "HUD_START" contains signals emitted from the various HUD game objects like buttons and clicking an action card. "BOARD_END" would contain signals that would tell board pieces what to do like moving the robber or building a settlement. The logic nodes are a bridge for the Events autoload, distributing all global signals. All signals emitted from game objects(HEADER*_START object names) will be connected to a logic node in its _ready() funciton. All signals that connect to game objects (HEADER*_END object names) are emitted from the logic nodes.

	Example: Roll button is pressed -> Roll button emits signal -> Logic State Machine recieves signal -> Logic State Machine emits signal to Screen Header to add the roll screen

This structure was chosen to centralize the decision making logic of the game. In any game, you have to choose when to convert the triggering event logic into reacting event logic. The primary goal is to make each game object never able to act on outside information. While the concepts of Loose Coupling and Dependancy Injection are core principles to follow already, this project is an attempt to take this to the most extreme. For example, a "Quit Game" menu button will not exit the game itself, even if that is its only possible logic. The button will instead inform a Logic Node it was pressed, and the Logic Node will exit the game. IMPORTANT NOTE: This is the end goal of the project but until finished, not all of these principles are followed as described.

### Message Objects
Some game objects require more complex information in an incoming siganl to complete a task. In this case, a game object class will have a "Message" inner class defined. These are simple objects that the logic nodes can make when they signal down to make passing complex information more clear.

### Multiplayer
Hex Realms uses RPC calls to pass information between peers. The expanded out Events structure of the project has proven antagonistic to being a multiplayer game. This is due to RPC calls being used in different layers of the game, creating a common problem of running the same logic multiple times. It is a goal to find out a good stucture of using all RPC calls in the same layer in a clear and understandable way.

### Pros
- Centralized Logic: All of the locations where a triggering event has to propigate out into reaction events occurs in one of the few Logic Nodes. This results in control of the entire game as a very high level pseudo-API
- Clear Path: All game logic follows a predictable and easy to follow path throughtout the scene tree. This makes debugging and scaling the game much easier.
- The organizational inner class objects of the Events autoload add a layer of visual debugging since all game objects will exclusively connect to "HEADER*_END" signals and emit "HEADER*_START" signals. Likewise logic nodes with only connect to "HEADER*_START" signals and emit "HEADER*_END" signals.

### Cons
- Extra Functions: Since all game objects can connect to the event bus, events do not have to flow through the Logic Nodes. Triggering events that only have one reaction events would simply be "NodeA.signal.emit() -> NodeB.signal.connect(callable) -> NodeB.callabe" for the entire logic flow. Instead, to be consistent, these signals still go up through the Logic Nodes making a much longer single-line function chain between the game objects.
- Complex Logic Nodes: The scripts on the Logic Nodes can quickly become too large as there are only a few and they handle all of the logic in the game.
- The amount of logic has also result in multiple nodes controlling logic at once

### Notes
The extra logic is an 'accepted disadvantage' because it results in code that is easier to debug. The size of logic scripts is also less of a disadvantage than normal in this case because of the nature of the code in the script. This is due to the fact that these logic scripts mostly just connect and emit signals with intuitive names, have minimal nested funcitions, and no extra complex logic. This is not the case for some of the game objects like the road hotspot object. The road hotspot contains code that not only controls its visual for hover and building, but also the max length algorithm that, while not the most complex, is argueably much harder to follow. This results in a shorter script that is harder to debug and refactor than any logic script. The multiple logic nodes is currently a pain point that needs more work to figure out a better structure.

## ⚔️ Multiplayer
- Mid Level API: ENetMultiplayerPeer
- Client-Server: One player hosts the game while other players connect
- LAN: Currently Only LAN and same-computer implemented
- Player Nodes: When players connect to the host, Player nodes are created by the PlayerManager in the Network Domain. These nodes contain all the information about a player for the match to proceed. All clients have all player nodes. Multiplayer Authority per player node is not yet implemented but is planned.

## ⛓️‍💥 Variations From Standards
- Signals
	- Signals are generally named with past tense verbs as they are emitted on triggers and other objects respond. Since this flow is split, only the HEADER*_START signals are past tense. The HEADER*_END signals are present tense as they are commands from the logic nodes.
 	- Signals are also usually used to signal up to an ancestor node. I've also used signals to "Signal Down" to maintain the loose coupling and avoid passing node references to the logic nodes.
    - Signal connected callables: A function connected to a signal commonly follows the pattern "_on_*signal_name*". This game uses the pattern "_*signal_name*" for the "*HEADER*_END" connected signals for more differentiation.
- Imported assets like blender files generally go into the "/addons" folder but I keep a separate "/imports" for easier navigation as navigating to plugins is vary rarely needed.
- Underscores as a prefix for variables is often used to denote a private variable. Due to the use of signals, calling properties on other nodes is very rare. Instead, underscores are used for constants, and uppercase is used for static variables and constants.
