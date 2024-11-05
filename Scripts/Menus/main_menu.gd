extends Node2D

var listaOpcoes=[]
var posicao=0

const variMaxima=8
const optLoad=preload('res://Nodes/Menus/opcaoMainMenu.tscn')

var distancia
var cursorBasePosition
var velCursor=50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	distancia=$OpcaoModelo.texture.get_size()[1]/$OpcaoModelo.vframes
	cursorBasePosition=$Cursor.position
	determinaOptsValidas()
	criaElementosListaOpcoes()
	
func exclue():
	get_parent().get_parent().pilhaAcoes.remove_at(0)
	queue_free()
	
func confirmaOpcaoSelecionada():
	listaOpcoes[posicao].executa()

func determinaOptsValidas():
	listaOpcoes.append(Options.OptionPokedex.new(get_parent().get_parent(),self))
	listaOpcoes.append(Options.OptionPokemon.new(get_parent().get_parent(),self))
	listaOpcoes.append(Options.OptionPersonagem.new(get_parent().get_parent(),self))
	listaOpcoes.append(Options.OptionOpcoes.new(get_parent().get_parent(),self))
	listaOpcoes.append(Options.OptionExit.new(get_parent().get_parent(),self))

func _input(event: InputEvent) -> void:
	if(get_parent().get_parent().pausado):
		return
	if(Input.is_action_just_pressed("B")):
		exclue()
	if(Input.is_action_just_pressed("A")):
		confirmaOpcaoSelecionada()
	elif(Input.is_action_just_pressed("Cima")):
		if(posicao>0):
			posicao-=1
	elif(Input.is_action_just_pressed("Baixo")):
		if(posicao<(listaOpcoes.size()-1)):
			posicao+=1
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func executa(delta) -> void:
	$Cursor.position=Vector2($Cursor.position[0]+velCursor*delta,cursorBasePosition[1]+(distancia*posicao))
	if(($Cursor.position[0]>=variMaxima+cursorBasePosition[0])and(velCursor>0)):
		velCursor*=-1
	if(($Cursor.position[0]<=cursorBasePosition[0])and(velCursor<0)):
		velCursor*=-1
		
func criaElemento(posicaoLista:int):
	var opt=optLoad.instantiate()
	opt.position=$OpcaoModelo.position+Vector2(0,posicaoLista*distancia)
	if(posicaoLista<(listaOpcoes.size()-1)):
		opt.frame=1
	else:
		opt.frame=$OpcaoModelo.vframes-1
	add_child(opt)
	return opt

func criaElementosListaOpcoes():
	var posi=0
	for opcao in listaOpcoes:
		var elemento
		if(posi>0):
			elemento=criaElemento(posi)
		else:
			elemento=$OpcaoModelo
		elemento.get_node('TextEdit').text=listaOpcoes[posi].texto
		posi+=1
		
