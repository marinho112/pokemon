extends Node

class Acao:
	var tipo = VG.ACAO
	var personagem
	
	func _init(personagem):
		self.personagem=personagem

	func executa(delta) -> void:
		pass
	
	func exclue():
		personagem.pilhaAcoes.remove_at(0)
	

class AcaoMover extends Acao:
	var destino
	
	func defineTipo():
		self.tipo = VG.ACAO_MOVER
	
	func _init(personagem,destino):
		super(personagem)
		self.destino=destino
	
	func exclue():
		personagem.get_node("AnimatedSprite2D").set_frame_and_progress(1,0)
		personagem.posicao+=personagem.direcao
		super()

	func executa(delta) -> void:
		if((!personagem.travado)and(!personagem.imovel)):
			if(destino!=personagem.position):
				var velocidadeAjustada = delta*personagem.velocidade
				if(personagem.correndo):
					velocidadeAjustada*=1.5
				if(personagem.position.distance_to(destino)>velocidadeAjustada):
					personagem.position+=velocidadeAjustada*personagem.direcao
				else:
					personagem.position=destino
					personagem.esquerda=!personagem.esquerda
				return
			else:
				exclue()
				
class AcaoMsg extends Acao:
	
	var msgBox
	
	func defineTipo():
		self.tipo = VG.ACAO_MSG
	
	func _init(personagem,msg) -> void:
		super(personagem)
		msgBox=self.personagem.get_node("Camera2D/MSGScreen")
		msgBox.visible=true
		msgBox.get_node("TextEdit").text=msg
		
	func executa(delta) -> void:
		if(personagem.opcao>0):
			personagem.opcao=0
			exclue()
			
	func exclue():
		msgBox.visible=false;
		super()
		
class AcaoDialogo extends Acao:
	var npc
	var msgBox
	var optBox
	var pontoDoDialogo=0
	var posicaoCursor=0
	var dialogoIniciado=false
	var mapaOpcoes=[]
	var listaContainer
	var timerCursor=0
	
	func defineTipo():
		self.tipo = VG.ACAO_MSG
	
	func _init(personagem,npc) -> void:
		super(personagem)
		msgBox=self.personagem.get_node("Camera2D/MSGScreen")
		optBox=self.personagem.get_node("Camera2D/OptionScreen")
		self.npc=npc
		listaContainer=[optBox.get_node("OPT1"),optBox.get_node("OPT2"),optBox.get_node("OPT3"),
		optBox.get_node("OPT4"),optBox.get_node("OPT5")]
		for item in npc.dialogo:
			mapaOpcoes.append([])
		for opcao in npc.opcoes:
			mapaOpcoes[opcao[0]]=opcao[1]
	
	func exibeMsg(msg):
		msgBox.visible=true
		msgBox.get_node("TextEdit").text=msg
	
	func set_sprite_size(sprite, new_size: Vector2):
		# Obtenha o tamanho atual do node
		var current_size = sprite.texture.get_size()
		var current_width = current_size.x
		var current_height = current_size.y

		# Calcule o fator de escala
		var scale_x = new_size[0] / current_width
		var scale_y = new_size[1] / current_height
		# Atualize a escala do node
		sprite.scale = Vector2(scale_x, scale_y)
		
	func moveCursor(novaPosi=null):
		if(novaPosi!=null):
			posicaoCursor=novaPosi
		var stringPosi="OPT"+str(posicaoCursor+1)
		var posiY=optBox.get_node(stringPosi).position[1]
		var ajuste= optBox.get_node(stringPosi).get_size()[1]/2
		optBox.get_node("Cursor").position[1]=posiY+ajuste
		timerCursor=0.3
		
	func criaOpcao(opcoes):
		if(opcoes.size()==0):
			return
		
		for item in listaContainer:
			for child in item.get_children():
				child.queue_free()
		for i in opcoes.size():
			var opcao=opcoes[i]
			var dig1e2=opcao.substr(0, 2)
			if(dig1e2=="$$"):
				var key= opcao.substr(2,3)
				var valor = int(opcao.substr(5))
				if(key=="img"):
					var sprite = Sprite2D.new()
					var texture
					match(valor):
						0:
							texture = load("res://assets/menus/imagemBotoes/nao.png")
						1:
							texture = load("res://assets/menus/imagemBotoes/sim.png")
					sprite.texture = texture
					sprite.position = (listaContainer[i].size/2)
					set_sprite_size(sprite,listaContainer[i].size)
					listaContainer[i].add_child(sprite)
		posicaoCursor=opcoes.size()-1
		if(posicaoCursor<0):
			posicaoCursor=0
		optBox.visible=true
		moveCursor()
	
	func imputCursor(delta):
		if(timerCursor<=0):
			if(Input.is_action_pressed("Baixo")and(posicaoCursor>0)):
				moveCursor(posicaoCursor-1)
			elif(Input.is_action_pressed("Cima")and(posicaoCursor<(mapaOpcoes[pontoDoDialogo].size()-1))):
				moveCursor(posicaoCursor+1)
		else:
			timerCursor-=delta
		
	func defineMsg():
		exibeMsg(npc.dialogo[pontoDoDialogo])
		criaOpcao(mapaOpcoes[pontoDoDialogo])
	
	func avancaDialogo():
		pontoDoDialogo+=1
		defineMsg()
		
	func selecionaOPT(opcaoSelecionada,pontoDoDialogo,tipoImput=2):
		match opcaoSelecionada:
			0:
				npc.selecionaOPT1(pontoDoDialogo,personagem.opcao,self)
			1:
				npc.selecionaOPT2(pontoDoDialogo,personagem.opcao,self)
			2:
				npc.selecionaOPT3(pontoDoDialogo,personagem.opcao,self)
			3:
				npc.selecionaOPT4(pontoDoDialogo,personagem.opcao,self)
			4:
				npc.selecionaOPT5(pontoDoDialogo,personagem.opcao,self)
	
	func executa(delta) -> void:
		imputCursor(delta)
		if(!dialogoIniciado):
			defineMsg()
			personagem.opcao=0
			dialogoIniciado=true
		if(personagem.opcao>0):
			if(mapaOpcoes[pontoDoDialogo].size()>0):
				if((pontoDoDialogo+1)<npc.dialogo.size()):
					avancaDialogo()
				else:
					exclue()
			else:
				selecionaOPT(pontoDoDialogo,posicaoCursor,personagem.opcao)
			personagem.opcao=0
			
	func exclue():
		if(msgBox!=null):
			msgBox.visible=false;
		if(optBox!=null):
			optBox.visible=false;
		super()
	
