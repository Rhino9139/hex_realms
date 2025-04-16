class_name MasterNetwork
extends Node

static var _MASTER: MasterNetwork

var peer: ENetMultiplayerPeer

func _init() -> void:
	_MASTER = self
