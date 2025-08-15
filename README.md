
Hex Realms - A case study in game architecture.

# 🎯 Overview
This project is a direct clone of the board game "Settlers of Catan". I created this game to play with friends and learn more about game architecture.
All of the code follows the [GDScript Style Guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html) unless noted otherwise. 
The primary goal of this structure is organization, and a consistent layering structure for both game files and the flow of game logic.
This results in some extra code and steps in game logic in an effort to keep the architecture more homogenous but ultimately becomeing easier to read/refactor/debug etc.
Naming conventions and keywords will also be noted when apporopriate.

[Settlers of Catan Rules](https://www.catan.com/understand-catan/game-rules)

#### This project is ongoing and while this readme describes the current structure, some files may have other patterns in the event they have not been updated.

## 📂 File Structure

- **godot**
	- **_3D**
   		- **board**
    	- **character**
    	- **environment**
	- **_GUI**
   		- **hud**
    	- **menu**
    	- **screen**
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

### Structure Breakdown
- **godot**
	- *Domain* (eg. _3D)
   		- *Header* (eg. board)
       		- *Sets* (eg. StandardBoard.tscn)
        	- *Game Objects* (eg. terrain hexes, robber piece)

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

