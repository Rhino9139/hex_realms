extends Node

const _APP_ID: int = 480

#func _ready() -> void:
	#OS.set_environment("SteamAppID", str(480))
	#OS.set_environment("SteamGameID", str(480))
	#
	#Steam.steamInit()
	#
	#var is_running: bool = Steam.isSteamRunning()
	#if is_running:
		#print("Steam is running")
#
#func _process(_delta: float) -> void:
	#Steam.run_callbacks()
