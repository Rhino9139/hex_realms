class_name Player
extends Node

static var LOCAL_PLAYER: Player
static var LARGEST_ARMY: int = 2

var player_id: int = 0
var player_name: String = "New Player"
var player_index: int = 0
var publisher: Publisher = Publisher.new()

var resources: Dictionary[Global.Resources, int] = {
	Global.Resources.BRICK : 0,
	Global.Resources.ORE : 0,
	Global.Resources.SHEEP : 0,
	Global.Resources.WHEAT : 0,
	Global.Resources.WOOD : 0,
}
var trade_remove: Array[int] = [0, 0, 0, 0, 0]
var trade_add: Array[int] = [0, 0, 0, 0, 0]
var trade_ratios: Array[int] = [4, 4, 4, 4, 4]
var player_mat: StandardMaterial3D
var player_color: Color
var settlement_count: int = 0
var castle_count: int = 0
var road_count: int = 0
var knight_count: int = 0
var num_cards: int = 0
var total_points: int = 0
var cards_in_hand: Array[Global.ActionCardType]
var cards_used: Array[Global.ActionCardType]

var has_longest_road: bool = false:
	set(new_value):
		has_longest_road = new_value
		calculate_points()
		publisher.longest_road_updated.emit(has_longest_road)

var has_largest_army: bool = false:
	set(new_value):
		has_largest_army = new_value
		calculate_points()
		publisher.largest_army_updated.emit(has_largest_army)

var turn_index: int = 1:
	set(new_value):
		turn_index = new_value
		publisher.turn_index = turn_index


func _ready() -> void:
	if player_id == multiplayer.get_unique_id():
		player_name = Main.PLAYER_NAME
		share_name.rpc(player_name)
		LOCAL_PLAYER = self
	elif multiplayer.is_server() == false:
		request_name.rpc_id(player_id)
	
	PlayerManager.NUM_PLAYERS += 1
	player_index = get_index() + 1
	player_mat = Global.PLAYER_MATS[player_index]
	player_color = player_mat.albedo_color
	publisher.player_name = player_name
	publisher.player_color = player_color
	
	Events.BOARD_START.building_added.connect(_building_added)
	Events.PLAYER_END.buy_hotspot.connect(_buy_hotspot)


func trade_resources() -> void:
	for i in 5:
		change_resource(i, trade_add[i])
		change_resource(i, -trade_remove[i])
	trade_remove = [0, 0, 0, 0, 0]
	trade_add = [0, 0, 0, 0, 0]


func manual_trade(add: Array[int], remove: Array[int]) -> void:
	for i in 5:
		change_resource(i, add[i])
		change_resource(i, -remove[i])


func _on_name_changed(new_name: String) -> void:
	player_name = new_name
	share_name.rpc(new_name)


func add_settlement() -> void:
	settlement_count += 1
	calculate_points()


func add_castle() -> void:
	settlement_count -= 1
	castle_count += 1
	calculate_points()


func add_road() -> void:
	road_count += 1


func add_card() -> void:
	pass


func use_card(card_type: Global.ActionCardType) -> void:
	cards_in_hand.erase(card_type)
	cards_used.append(card_type)
	knight_count = 0
	for card in cards_used:
		if card == Global.ActionCardType.KNIGHT:
			knight_count += 1
	share_knight_count.rpc(knight_count)


func change_resource(index: Global.Resources, amount: int) -> void:
	resources[index] += amount
	num_cards = 0
	for value in resources:
		num_cards += value
	
	Events.PLAYER_START.resources_changed.emit(resources, player_id)
	
	if multiplayer.get_unique_id() == player_id:
		share_cards.rpc(num_cards)


func change_resources(amount: Dictionary[Global.Resources, int], is_added: bool = true) -> void:
	if is_added:
		for i in 5:
			change_resource(i, amount[i])
	else:
		for i in 5:
			change_resource(i, -amount[i])


func calculate_points() -> void:
	var point_cards: int = 0
	for card in cards_used:
		if card == Global.ActionCardType.VICTORY_POINT:
			point_cards += 1
	total_points = point_cards + settlement_count + (castle_count * 2)
	if has_longest_road:
		total_points += 2
	if has_largest_army:
		total_points += 2
	publisher.points_changed.emit(total_points)


func _building_added(hotspot: Hotspot) -> void:
	if hotspot.player_owner == self:
		if hotspot.hotspot_type == Hotspot.Type.SETTLEMENT:
			add_settlement()


func _buy_hotspot(hotspot_type: Hotspot.Type) -> void:
	change_resources(Global._COST_BY_HOTSPOT[hotspot_type], false)


@rpc("any_peer", "call_remote")
func share_name(new_name: String) -> void:
	player_name = new_name


@rpc("any_peer", "call_remote")
func request_name() -> void:
	var request_id: int = multiplayer.get_remote_sender_id()
	share_name.rpc_id(request_id, player_name)


@rpc("any_peer", "call_remote")
func share_cards(card_count: int) -> void:
	num_cards = card_count
	publisher.resource_cards_changed.emit(num_cards)


@rpc("any_peer", "call_local")
func share_knight_count(new_count: int) -> void:
	knight_count = new_count
	if knight_count > LARGEST_ARMY:
		LARGEST_ARMY = knight_count
		has_largest_army = true
	for player in PlayerManager.GET_PLAYERS():
		if player.knight_used < LARGEST_ARMY:
			player.has_largest_army = false
	publisher.knights_changed.emit(knight_count)


class Publisher:
	signal points_changed(new_points: int)
	signal knights_changed(new_knights: int)
	signal resource_cards_changed(new_count: int)
	signal longest_road_updated(has_longest: bool)
	signal largest_army_updated(has_largest: bool)
	
	var player_name: String
	var player_color: Color
	var turn_index: int
