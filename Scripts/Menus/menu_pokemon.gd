extends Node2D

var pokemon
var posicao=0
var moveSelecionado=0
var qtdAtaks=0
var contador=0
var contImput=0
var selecaoAtaques=true
var moveTravado=null

func setTextEffect(texto):
	var substrings = []
	var index = 0
	var length=28
	var subString=""
	for letra in texto.replace("\n"," "):
		if(letra!=" "or(index>0)):
			subString+=letra
			index+=1
		if(index==length):
			substrings.append(subString)
			subString=""
			index = 0
	substrings.append(subString)
	$telaMovimentos/Effect1.text=substrings[0]
	if(substrings.size()>1):
		$telaMovimentos/Effect2.text=substrings[1]
		$telaMovimentos/Effect2.visible=true
	else:
		$telaMovimentos/Effect2.visible=false
	if(substrings.size()>2):
		$telaMovimentos/Effect3.text=substrings[2]
		$telaMovimentos/Effect3.visible=true
	else:
		$telaMovimentos/Effect3.visible=false
	if(substrings.size()>3):
		$telaMovimentos/Effect4.text=substrings[3]
		$telaMovimentos/Effect4.visible=true
	else:
		$telaMovimentos/Effect4.visible=false

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

func desenhaCursor():
	if(moveTravado!=null):
		$telaMovimentos/CursorTrava.visible=true
		$telaMovimentos/Cursor.position.y=-55+(28*moveTravado)
	else:
		$telaMovimentos/CursorTrava.visible=false
	$telaMovimentos/Cursor.position.y=-55+(28*moveSelecionado)
	defineMovimentoSelecionado()

func _ready() -> void:
	defPosicao()

func recebeImput():
	var posicaoOld=posicao
	if(Input.is_action_just_pressed("Direita")):
		posicao+=1
	elif(Input.is_action_just_pressed("Esquerda")):
		posicao-=1
	if(posicao>3):
		posicao=0
	if(posicao<0):
		posicao=3
	if(posicaoOld!=posicao):
		defPosicao()
		contImput=5
		return
		
	if((posicao==3)and selecaoAtaques):
		posicaoOld=moveSelecionado
		if(Input.is_action_just_pressed("Cima")):
			moveSelecionado-=1
		elif(Input.is_action_just_pressed("Baixo")):
			moveSelecionado+=1
		if(moveSelecionado>qtdAtaks-1):
			moveSelecionado=0
		if(moveSelecionado<0):
			moveSelecionado=qtdAtaks-1
			
		if(posicaoOld!=moveSelecionado):
			desenhaCursor()
			contImput=1
		
func executa(delta: float):
	if(contImput<=0):
		recebeImput()
	if(contador>0.1):
		contador=0
		if(contImput>0):
			contImput-=1
		if($telaMovimentos/Cursor.scale>=Vector2(1,1)):
			$telaMovimentos/Cursor.scale=Vector2(0.95,0.95)
		else:
			$telaMovimentos/Cursor.scale=Vector2(1,1)
	else:
		contador+=delta
		
	
	
func ajustaTamanho(proporcao):
	var tamanho=Vector2($telaDescricao/fundo.texture.region.size)
	var tamanhoDesejado=Vector2(get_parent().tamanho)
	var tamanhoAjuste=Vector2(tamanhoDesejado.x/tamanho.x,tamanhoDesejado.y/tamanho.y)
	scale=tamanhoAjuste*proporcao/100

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

func defineScales(movimento):
	var tamanho=movimento.scales.size()
	for i in 4:
		var scale=$telaMovimentos.get_node("Scale"+str(i+1))
		if(i+1) <= tamanho:
			scale.get_node("Icone").frame=movimento.scales[i][0]
			scale.get_node("Power").text=str(movimento.scales[i][1])
			scale.visible=true
		else:
			scale.visible=false

func defineArmas(movimento):
	var tamanho=movimento.armas.size()
	for i in 2:
		var arma=$telaMovimentos.get_node("Arma"+str(i+1))
		if(i+1) <= tamanho:
			arma.frame=movimento.armas[i]
			arma.visible=true
		else:
			arma.visible=false

func defineMovimentoSelecionado():
	var movimento=pokemon.ataques[moveSelecionado]
	var strTemp="---"
	if(movimento.power>0):
		strTemp=str(movimento.power)
	$telaMovimentos/Power.text=strTemp
	strTemp="---"
	if(movimento.accuracy>0):
		strTemp=str(movimento.accuracy)
	$telaMovimentos/Accuracy.text=strTemp
	setTextEffect(movimento.flavorText)
	defineScales(movimento)
	defineArmas(movimento)

func defineTelaMovimentos():
	qtdAtaks=0
	for i in 4:
		var atk=pokemon.ataques[i]
		if(atk!=null):
			qtdAtaks+=1 
			var tela=$telaMovimentos.get_node("move"+str(i+1))
			tela.get_node('Tipo').frame=atk.type
			tela.get_node('Nome').text=Ferramentas.formataNome(atk.nome)
			tela.get_node('PP').text="PP "+str(atk.pp)
	if(qtdAtaks>0):
		desenhaCursor()

func definePokemon(pkm):
	if(pkm!=null):
		pokemon=pkm
		
	defineTelaDescricao()
	defineTelaAtributos()
	defineTelaMovimentos()
	definePokemonScreem()
