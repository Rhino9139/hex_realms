extends Port

@export var resource_sprite: Sprite3D

var index: int
var port_type: Global.Resources


func _ready() -> void:
	index = int(name)
	port_type = PORT_ARRAY[index]
	resource_sprite.texture = load(Global.RESOURCE_ICONS[port_type])
