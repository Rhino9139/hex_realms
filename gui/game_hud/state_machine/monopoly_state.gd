extends State

var screen: Screen
var responses: int = 0:
	set(new_value):
		responses = new_value
		check_if_finished()

func enter() -> void:
	responses = 0
	screen = Screen.CREATE_MONOPOLY_SCREEN()
	screen.type_chosen.connect(_on_type_chosen)

func exit() -> void:
	if is_instance_valid(screen):
		screen.type_chosen.disconnect(_on_type_chosen)

func _on_type_chosen(type_index: int) -> void:
	print(Global.TYPE_RES[type_index].type)
	request_resources.rpc(type_index)

func check_if_finished() -> void:
	if responses == MultiplayerManager.NUM_PLAYERS - 1:
		state_changed.emit("ActiveState")

@rpc("any_peer", "call_remote")
func request_resources(type_index: int) -> void:
	var sender: int = multiplayer.get_remote_sender_id()
	var amount: int = Player.LOCAL_PLAYER.resources[type_index]
	Player.LOCAL_PLAYER.change_resource(type_index, -amount)
	respond_resources.rpc_id(sender, type_index, amount)

@rpc("any_peer", "call_remote")
func respond_resources(type_index: int, amount: int) -> void:
	Player.LOCAL_PLAYER.change_resource(type_index, amount)
	responses += 1
