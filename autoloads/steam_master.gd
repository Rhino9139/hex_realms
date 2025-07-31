#extends Node
#
#const _APP_ID: int = 00000
#
#func _ready() -> void:
	#OS.set_environment("SteamAppID", str(_APP_ID))
	#OS.set_environment("SteamGameID", str(_APP_ID))
	#
	#Steam.steamInit()
	#
	#var is_running: bool = Steam.isSteamRunning()
	#if is_running:
		#print("Steam is running")
#
#func _process(_delta: float) -> void:
	#Steam.run_callbacks()
