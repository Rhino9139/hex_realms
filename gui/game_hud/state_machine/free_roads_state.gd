extends State

var player: Player
var credits: int = 2

func enter() -> void:
	credits = 2
	player = Player.LOCAL_PLAYER
	Global.MAKE_ROAD_FREE()
	player.road_built.connect(_on_road_built)
	BuyButton.ENABLE_ROAD()

func exit() -> void:
	Global.MAKE_ROAD_COST()
	player.road_built.disconnect(_on_road_built)
	BuyButton.DISABLE_ROAD()

func _on_road_built() -> void:
	credits -= 1
	if credits == 0:
		state_changed.emit("ActiveState")
