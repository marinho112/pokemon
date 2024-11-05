extends Eventos.EventoMsgOnCLik

#DESCOBRIR O MOTIVO DESSES AJUSTES
var ajusteX=16
var ajusteY=16

func _ready() -> void:
	self.visible=false;
	var papai=get_parent()
	for item in TextoPlacas.listaTextoPlacas:
		var x= papai.position.x+(item[1]*32)+ajusteX
		var y= papai.position.y+(item[2]*32)+ajusteY
		if(self.position == Vector2(x,y)):
			mensagem = item[3]
			return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
