extends Node

@warning_ignore_start("unused_signal")
signal program_started

signal server_requested
signal client_requested
signal server_created
signal client_created

signal local_name_changed(new_name: String)

signal host_match_started
signal match_started
signal board_shared
signal robber_created
signal move_robber_requested
signal robber_moved
signal robber_steal_activated
signal robber_resource_stolen(target_player: Player)

signal turn_order_created
