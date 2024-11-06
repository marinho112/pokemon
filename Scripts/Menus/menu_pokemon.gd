extends Node2D

var pokemon
var posicao=0


func visibleOff():
	$telaAtributos.visible=false
	$telaCaracteristicas.visible=false
	$telaMovimentos.visible=false
	$telaDescricao.visible=false
	$pokemonScreem/Conteudo.visible=true
	
	
func defPosicao():
	match posicao:
		0:
			visibleOff()
			$telaDescricao.visible=true
		1:
			visibleOff()
			$telaAtributos.visible=true
		2:
			visibleOff()
			$telaCaracteristicas.visible=true
		3:
			visibleOff()
			$telaMovimentos.visible=true
			$pokemonScreem/Conteudo.visible=false

func _input(event: InputEvent) -> void:
	if(Input.is_action_just_pressed("Direita")):
		posicao+=1
	elif(Input.is_action_just_pressed("Esquerda")):
		posicao-=1
	
	if(posicao>3):
		posicao=0
	if(posicao<0):
		posicao=3
	
	defPosicao()
	
		
func executa(delta: float):
	pass
	
func ajustaTamanho(proporcao):
	var tamanho=Vector2($telaDescricao/fundo.texture.region.size)
	var tamanhoDesejado=Vector2(get_parent().tamanho)
	var tamanhoAjuste=Vector2(tamanhoDesejado.x/tamanho.x,tamanhoDesejado.y/tamanho.y)
	scale=tamanhoAjuste*proporcao/100
	print(tamanhoDesejado.x)
	print(tamanho)
	print(tamanhoAjuste)
	print(tamanhoAjuste*tamanho)

func defineTelaDescricao():
	$telaDescricao/editNo.text=Ferramentas.formataNumero(pokemon.racaID)
	$telaDescricao/editName.text=pokemon.apelido
	$telaDescricao/editOT.text="TesteOT"
	$telaDescricao/editIDNo.text="TesteIDNo"
	if(pokemon.item):
		$telaDescricao/editItem.text=Ferramentas.formataNome(pokemon.item['name'])
	else:
		$telaDescricao/editItem.text=""
	$telaDescricao/Tipo1.frame=pokemon.tipo[0]
	if(pokemon.tipo[1]== null):
		$telaDescricao/Tipo2.visible=false
	else:
		$telaDescricao/Tipo2.visible=true
		$telaDescricao/Tipo2.frame=pokemon.tipo[1]

func defineTelaAtributos():
	$telaAtributos/editHP.text=str(pokemon.getVidaAtual())+"/"+str(pokemon.getAtributoReal(VG.ATRIBUTO_VIDA))
	$telaAtributos/editAtk.text=str(pokemon.getAtributoReal(VG.ATRIBUTO_ATAQUE))
	$telaAtributos/editDef.text=str(pokemon.getAtributoReal(VG.ATRIBUTO_DEFESA))
	$telaAtributos/editSpAtk.text=str(pokemon.getAtributoReal(VG.ATRIBUTO_ESPECIAL_ATAQUE))
	$telaAtributos/editSpDef.text=str(pokemon.getAtributoReal(VG.ATRIBUTO_ESPECIAL_DEFESA))
	$telaAtributos/editSpeed.text=str(pokemon.getAtributoReal(VG.ATRIBUTO_VELOCIDADE))
	$telaAtributos/editExp.text=str(pokemon.exp)
	$telaAtributos/editNextLv.text=str("CALCULAR NO FUTURO")
	$telaAtributos/editAbility.text=pokemon.getHabilidadeNome()
	$telaAtributos/editAbilityDescricao.text=pokemon.getHabilidadeDescricao()

func definePokemonScreem():
	$pokemonScreem/Cabecalho/editEspecie.text=Ferramentas.formataNome(pokemon.raca)
	$pokemonScreem/Cabecalho/editLV.text="LV."+str(pokemon.lv)

func definePokemon(pkm):
	if(pkm!=null):
		pokemon=pkm
		
	defineTelaDescricao()
	defineTelaAtributos()
	
	definePokemonScreem()
	
