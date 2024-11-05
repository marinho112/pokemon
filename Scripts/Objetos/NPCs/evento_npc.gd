extends Eventos.EventoComplexo

var travaCelula=false

func defineTipo():
	self.tipo = VG.EVENTO_NPC
	
func onClick(personagem):
	criaDialogo(personagem)
	return true

func get_animated_sprite_2d_size(animated_sprite_2d) -> Vector2:
	return animated_sprite_2d.sprite_frames.get_frame_texture(animated_sprite_2d.animation, animated_sprite_2d.frame).get_size()

func set_node_size(new_width: float, new_height: float):
	# Obtenha o tamanho atual do node
	var current_size = get_animated_sprite_2d_size($AnimatedSprite2D)
	var current_width = current_size.x
	var current_height = current_size.y

	# Calcule o fator de escala
	var scale_x = new_width / current_width
	var scale_y = new_height / current_height

	# Atualize a escala do node
	self.scale = Vector2(scale_x, scale_y)

func negaPermicao():
	var map=get_parent().get_parent()
	var permicoes=map.get_node("TilePermissions")
	var posicao=permicoes.local_to_map(self.position)
	if(permicoes.get_cell_atlas_coords(posicao)==(Vector2i(-1,-1))):
		permicoes.set_cell(posicao,0,Vector2i(0,0))
		travaCelula=true

func exclue(personagem):
	if(travaCelula):
		var permicoes=get_parent().get_parent().get_node("TilePermissions")
		var posicao = permicoes.local_to_map(self.position)
		if(permicoes.get_cell_atlas_coords(posicao)==(Vector2i(0,0))):
			permicoes.erase_cell(posicao)
	super(personagem)

func _ready() -> void:
	set_node_size(30,30)
	negaPermicao()
	
