class_name Player
extends Node

signal points_changed
signal knights_changed
signal resource_cards_changed
signal longest_road_updated
signal largest_army_updated
signal road_length_updated(new_length: int)

static var LOCAL_PLAYER: Player
static var LARGEST_ARMY: int = 2
static var LONGEST_ROAD: int = 4

var player_id: int = 0
var player_name: String = "New Player"
var player_index: int = 0

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
		longest_road_updated.emit()

var has_largest_army: bool = false:
	set(new_value):
		has_largest_army = new_value
		calculate_points()
		largest_army_updated.emit()

var turn_index: int = 1


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
	
	if LOCAL_PLAYER == self:
		Events.BOARD_START.building_added.connect(_building_added)
		Events.PLAYER_END.buy_hotspot.connect(_buy_hotspot)
		Events.PLAYER_END.buy_action_card.connect(_buy_action_card)
		Events.PLAYER_END.use_action_card.connect(_use_action_card)
	
	road_length_updated.connect(_road_length_updated)


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
	pass


func add_card(new_card: Global.ActionCardType) -> void:
	change_resources(Global._CARD_COST, false)
	cards_in_hand.append(new_card)
	if Player.LOCAL_PLAYER == self:
		Events.PLAYER_START.action_cards_changed.emit(cards_in_hand, cards_used)


func _use_action_card(card_type: Global.ActionCardType) -> void:
	cards_in_hand.erase(card_type)
	cards_used.append(card_type)
	knight_count = 0
	for card in cards_used:
		if card == Global.ActionCardType.KNIGHT:
			knight_count += 1
	share_knight_count.rpc(knight_count)
	if Player.LOCAL_PLAYER == self:
		Events.PLAYER_START.action_cards_changed.emit(cards_in_hand, cards_used)


func change_resource(index: Global.Resources, amount: int) -> void:
	resources[index] += amount
	resources[index] = clamp(resources[index], 0 ,1_000_000)
	num_cards = 0
	for value in resources:
		num_cards += value
	
	Events.PLAYER_START.resources_changed.emit(resources, player_id)
	
	if multiplayer.get_unique_id() == player_id:
		share_cards.rpc(resources)


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
	points_changed.emit()


func _building_added(hotspot: Hotspot) -> void:
	if hotspot.player_owner == self:
		if hotspot.hotspot_type == Hotspot.Type.SETTLEMENT:
			add_settlement()


func _buy_hotspot(hotspot_type: Hotspot.Type) -> void:
	change_resources(Global._COST_BY_HOTSPOT[hotspot_type], false)


func _buy_action_card() -> void:
	if multiplayer.is_server():
		pass


func _road_length_updated(new_length: int) -> void:
	road_count = new_length
	share_longest_road_length.rpc(road_count)


@rpc("any_peer", "call_remote")
func share_name(new_name: String) -> void:
	player_name = new_name


@rpc("any_peer", "call_remote")
func request_name() -> void:
	var request_id: int = multiplayer.get_remote_sender_id()
	share_name.rpc_id(request_id, player_name)


@rpc("any_peer", "call_remote")
func share_cards(new_resources: Dictionary[Global.Resources, int]) -> void:
	resources = {
		Global.Resources.BRICK : 0,
		Global.Resources.ORE : 0,
		Global.Resources.SHEEP : 0,
		Global.Resources.WHEAT : 0,
		Global.Resources.WOOD : 0,
		}
	change_resources(new_resources)
	
	resource_cards_changed.emit()


@rpc("any_peer", "call_local")
func share_knight_count(new_count: int) -> void:
	knight_count = new_count
	if knight_count > LARGEST_ARMY:
		LARGEST_ARMY = knight_count
		has_largest_army = true
	for player in PlayerManager.GET_PLAYERS():
		if player.knight_count < LARGEST_ARMY:
			player.has_largest_army = false
	knights_changed.emit()


@rpc("any_peer", "call_local")
func share_longest_road_length(new_length: int) -> void:
	road_count = new_length
	if road_count > LONGEST_ROAD:
		LONGEST_ROAD = road_count
		has_longest_road = true
	for player in PlayerManager.GET_PLAYERS():
		if player.road_count < LONGEST_ROAD:
			player.has_longest_road = false
