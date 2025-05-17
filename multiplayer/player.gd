class_name Player
extends Node

signal settlement_built
signal road_built
signal item_bought(item: String)

static var LOCAL_PLAYER: Player

var player_id: int = 0
var player_name: String = "New Player"
var turn_index: int = -1

var resources: Array[int] = [0, 0, 0, 0, 0]
var trade_remove: Array[int] = [0, 0, 0, 0, 0]
var trade_add: Array[int] = [0, 0, 0, 0, 0]
var settlement_credits: int = 0
var road_credits: int = 0
var player_mat: StandardMaterial3D
var player_color: Color
var settlement_count: int = 0
var castle_count: int = 0
var road_count: int = 0
var knight_unused: int = 0
var knight_used: int = 0
var num_cards: int = 0
var point_card_usused: int = 0
var point_card_used: int = 0
var monopoly_cards: int = 0
var free_roads_cards: int = 0
var year_of_plenty_cards: int = 0
var total_points: int = 0

func _ready() -> void:
	if multiplayer.is_server() == false:
		request_id.rpc_id(1)
	elif player_id == 1:
		player_name = Game.GET_NAME()
		Game.CONNECT_NAME_SIGNAL(self)
		LOCAL_PLAYER = self
	player_mat = Global.PLAYER_MATS[get_index()]
	player_color = player_mat.albedo_color

func trade_resources() -> void:
	for i in 5:
		change_resource(i, trade_add[i])
		change_resource(i, -trade_remove[i])
	trade_remove = [0, 0, 0, 0, 0]
	trade_add = [0, 0, 0, 0, 0]

func _on_name_changed(new_name: String) -> void:
	player_name = new_name
	share_name.rpc(new_name)

func add_settlement() -> void:
	item_bought.emit(Global._SETTLEMENT)
	settlement_built.emit()
	settlement_count += 1
	settlement_credits -= 1

func pay_settlement() -> void:
	for i in 5:
		change_resource(i, -Global.SETTLEMENT_COST[i])

func castle_built() -> void:
	item_bought.emit(Global._CASTLE)
	settlement_count -= 1
	castle_count += 1

func pay_castle() -> void:
	for i in 5:
		change_resource(i, -Global.CASTLE_COST[i])

func add_road() -> void:
	item_bought.emit(Global._ROAD)
	road_built.emit()
	road_count += 1
	road_credits -= 1

func pay_road() -> void:
	for i in 5:
		change_resource(i, -Global.ROAD_COST[i])

func add_card() -> void:
	item_bought.emit(Global._CARD)

func pay_card() -> void:
	for i in 5:
		change_resource(i, -Global.CARD_COST[i])

func change_resource(index: int, amount: int) -> void:
	resources[index] += amount
	GameHUD.UPDATE_RESOURCES()
	num_cards = 0
	for i in resources:
		num_cards += i

@rpc("any_peer")
func request_id() -> void:
	var id: int = multiplayer.get_remote_sender_id()
	response_id.rpc_id(id, player_id)
	if id != player_id:
		share_name.rpc_id(id, player_name)

@rpc("authority")
func response_id(new_id: int) -> void:
	player_id = new_id
	if player_id == multiplayer.get_unique_id():
		player_name = Game.GET_NAME()
		Game.CONNECT_NAME_SIGNAL(self)
		share_name.rpc(player_name)
		LOCAL_PLAYER = self

@rpc("any_peer", "call_remote")
func share_name(new_name: String) -> void:
	player_name = new_name
