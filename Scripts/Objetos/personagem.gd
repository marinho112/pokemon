extends CharacterBody2D

var mapa = null
var posicao : Vector2i= Vector2i(0,0)
var movimento = Vector2i(0,0)
var direcao = Vector2i(0,1)
var pilhaAcoes=[]
var correndo = false
var esquerda=false
var pausado= false
var travado = false
var imovel= false
var opcao=0
var contaTrava=-1
var personagemInfo
const velocidade = 120
const mainMenuLoad=preload('res://Nodes/Menus/mainMenu.tscn')


func _ready():
	personagemInfo=Classes.personagem.new()
	personagemInfo.nome="TesteValdo"
	mapa= get_parent().get_node("Mapa").get_child(0)
	$Camera2D/MSGScreen.visible=false;
	$Camera2D/OptionScreen.visible=false;
	posicionar()
	var pkm= Ferramentas.getPokemon(3)
	pkm.carregaCaracteristicas()
	pkm.getRandomHabilit()
	pkm.getRandomItem()
	pkm.recebeUltimosAtaques()
	personagemInfo.pkms.append(pkm)
	pkm.imprime()

func set_posicao( novaPosicao):
	posicao = novaPosicao;

func posicionar():
	position=mapa.get_node("TileMapLayer").map_to_local(posicao)
	get_node("AnimatedSprite2D").set_frame_and_progress(1,0)

func _input(event: InputEvent) -> void:
	if(pausado or travado):
		return
	if(Input.is_action_just_pressed("A")):
		var listaEventos = mapa.get_node("TileEventMap").get_children()#(direcao+posicao)
		var posicãoBuscada=position+Vector2(32*direcao)
		if(pilhaAcoes.size()==0):
			for item in listaEventos:
				if(item.position==posicãoBuscada):
					return item.onClick(self)
		opcao=1
	if(Input.is_action_just_pressed("B")):
		opcao=2
	
func getImputMovimento():
		
	var intencaoDeMovimento = Vector2i(0,0)
	
	if(pausado or travado or imovel):
		movimento = intencaoDeMovimento
		return
	if(Input.is_action_pressed("Cima")):
		intencaoDeMovimento+=Vector2i(0,-1)
	if(Input.is_action_pressed("Baixo")):
		intencaoDeMovimento+=Vector2i(0,1)
	if(intencaoDeMovimento[1]==0):
		if(Input.is_action_pressed("Esquerda")):
			intencaoDeMovimento+=Vector2i(-1,0)
		if(Input.is_action_pressed("Direita")):
			intencaoDeMovimento+=Vector2i(1,0)
	if(intencaoDeMovimento!=Vector2i(0,0)):
		if(Input.is_action_pressed("B")):
			correndo=true
		else:
			correndo=false
	movimento=intencaoDeMovimento
	###POR ALGUM MOTIVO O MOVIMENTO ESTA ATUALIZANDO APENAS DPS DE MUITOS FRAMES
	
func getImputMenu():
	if(Input.is_action_pressed("start")):
		if((pilhaAcoes.size()==0)and(!pausado)):
			var menu=mainMenuLoad.instantiate()
			$Camera2D.add_child(menu)
			pilhaAcoes.append(menu)
			return true
	return false

func mover(valMovimento):
	var perna = 0
	if(esquerda):
		perna+=2
	get_node("AnimatedSprite2D").flip_h=false
	if(valMovimento[1]==-1):
		if(correndo):
			get_node("AnimatedSprite2D").play("Correndo_Cima",0)
		else:
			get_node("AnimatedSprite2D").play("Andando_Cima",0)
	if(valMovimento[1]==1):
		if(correndo):
			get_node("AnimatedSprite2D").play("Correndo_Baixo",0)
		else:
			get_node("AnimatedSprite2D").play("Andando_Baixo",0)
	if(valMovimento[0]==1):
		get_node("AnimatedSprite2D").flip_h=true
		if(correndo):
			get_node("AnimatedSprite2D").play("Correndo_Lado",0)
		else:
			get_node("AnimatedSprite2D").play("Andando_Lado",0)
	if(valMovimento[0]==-1):
		if(correndo):
			get_node("AnimatedSprite2D").play("Correndo_Lado",0)
		else:
			get_node("AnimatedSprite2D").play("Andando_Lado",0)
		
	get_node("AnimatedSprite2D").set_frame_and_progress(perna,0)
	var movendo = get_parent().get_node("Mapa").get_child(0).get_node("TileMapLayer").map_to_local(valMovimento+posicao)
	pilhaAcoes.append(Acoes.AcaoMover.new(self,movendo))
	
	#direcao = valMovimento
	
func apontaDirecao(novaDirecao):
	direcao=novaDirecao
	get_node("AnimatedSprite2D").flip_h=false
	if(direcao[1]==-1):
		get_node("AnimatedSprite2D").play("Andando_Cima",0)
	if(direcao[1]==1):
		get_node("AnimatedSprite2D").play("Andando_Baixo",0)
	if(direcao[0]==1):
		get_node("AnimatedSprite2D").flip_h=true
		get_node("AnimatedSprite2D").play("Andando_Lado",0)
	if(direcao[0]==-1):
		get_node("AnimatedSprite2D").play("Andando_Lado",0)
	get_node("AnimatedSprite2D").set_frame_and_progress(1,0)
	movimento=Vector2i(0,0)
	
func validaMovimento(intencaoDeMovimento):
	var temObjeto=get_parent().get_node("Mapa").get_child(0).get_node("TileConstructionMap").get_cell_tile_data(intencaoDeMovimento)!=null
	var permissão=0 #0=Nenhuma,1=sempre pode andar,2=Travado
	var permissionCel=get_parent().get_node("Mapa").get_child(0).get_node("TilePermissions").get_cell_atlas_coords(intencaoDeMovimento)
	match permissionCel:
		Vector2i(1,0):
			permissão=1
		Vector2i(0,0):
			permissão=2
		Vector2i(2,0):
			permissão=3
	if(temObjeto):
		if(permissão==1):
			return true
	elif(permissão<2):
		return true
	return false

func _process(delta: float):
	if(contaTrava>0):
		travado=true
		contaTrava-=delta
	elif(contaTrava>-1):
		travado=false
		contaTrava=-1
	if(getImputMenu()):
		return
	getImputMovimento()
	if((pilhaAcoes.size()>0)and(!pausado)):
		pilhaAcoes[0].executa(delta)
	elif(imovel):
		pass
	else:
		if(movimento!=Vector2i(0,0)):
			if(pilhaAcoes.size()==0):
				if((movimento==direcao)and(validaMovimento(movimento+posicao))):
					mover(movimento)
				else:
					apontaDirecao(movimento)
					if(!correndo):
						contaTrava=0.1
			
