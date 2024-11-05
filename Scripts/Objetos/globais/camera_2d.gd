extends Camera2D

var tamanho = Vector2i(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var viewport_size = get_viewport().size
	var z=1.8
	zoom =Vector2(z,z)
	tamanho=Vector2i(viewport_size)/z

func _process(delta: float) -> void:
	pass
