
Hex Realms - A case study in game architecture.

### 🎯 Overview
This project is a direct clone of the board game "Settlers of Catan". I created this game to play with friends and learn more about game architecture.
All of the code follows the [GDScript Style Guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html) unless noted otherwise. 
The primary goal of this structure is organization, and a consistent layering structure for both game files and the flow of game logic.
This results in some extra code and steps in game logic in an effort to keep the architecture more homogenous but ultimately becomeing easier to read/refactor/debug etc.
Naming conventions and keywords will also be noted when apporopriate.


### 📂 File Structure

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
