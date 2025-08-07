extends Port

@export var resource_sprite: Sprite3D

var index: int
var port_type: Type


func _ready() -> void:
	index = int(name)
	port_type = PORT_ARRAY[index]
	resource_sprite.texture = load(RESOURCE_ICONS[port_type])
