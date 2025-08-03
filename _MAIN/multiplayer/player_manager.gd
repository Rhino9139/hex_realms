class_name PlayerManager
extends Node

static var MASTER: PlayerManager

const _PATHS: Dictionary[String, String] = {
	"Player" : "uid://cjwp661yn28ll",
}


static func GET_PLAYERS() -> Array[Player]:
	var list: Array[Player]
	for child in MASTER.get_children():
		if child is Player:
			list.append(child)
	return list


static func GET_NUM_PLAYERS() -> int:
	return GET_PLAYERS().size()


static func GET_PLAYER_BY_ID(player_id: int) -> Player:
	for player in GET_PLAYERS():
		if player.player_id == player_id:
			return player
	push_error("Player not found with the ID: ", player_id)
	return null


func _init() -> void:
	MASTER = self


func _ready() -> void:
	Events.server_created.connect(_on_server_created)


func add_player(new_id: int) -> void:
	var new_player: Player = load(_PATHS["Player"]).instantiate()
	new_player.player_id = new_id
	add_child(new_player, true)


func _on_server_created() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	add_player(1)


func _on_peer_connected(new_id: int) -> void:
	add_player(new_id)


#static func REMOVE_PLAYER(id: int) -> void:
	#for child in MASTER.get_children():
		#if child is Player:
			#if child.player_id == id:
				#child.queue_free()


#static func RETURN_PLAYERS() -> Array:
	#MASTER.sort_players()
	#return MASTER.player_array


#static func GET_PLAYER(player_id: int) -> Player:
	#for player in RETURN_PLAYERS():
		#if player.player_id == player_id:
			#return player
	#return null


#func sort_players() -> void:
	#player_array = player_manager.get_children()
	#player_array.sort_custom(sort_ascending)
#
#
#func sort_ascending(a, b) -> bool:
	#if a.turn_index < b.turn_index:
		#return true
	#return false
