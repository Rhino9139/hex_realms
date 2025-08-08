extends State

var player: Player
var credits: int = 2


func enter() -> void:
	credits = 2
	player = Player.LOCAL_PLAYER
	player.road_built.connect(_on_road_built)


func exit() -> void:
	player.road_built.disconnect(_on_road_built)


func _on_road_built() -> void:
	credits -= 1
	if credits == 0:
		state_changed.emit("ActiveState")
