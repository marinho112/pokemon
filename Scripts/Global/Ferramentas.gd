extends Node

const pokemonData="res://dados/pokemon_DB.txt"
const itemData="res://dados/item_DB.txt"
const habilidadeData="res://dados/ability_DB.txt"
const moveData='res://dados/move_DB.txt'
const caracteristicasData='res://dados/caracteristicas_DB.txt'
const evolutionData='res://dados/evolution_DB.txt'

func getIdadeString(val):
	if(val>400):
		return VG.IDADE_OLD
	if(val>300):
		return VG.IDADE_ADULT
	if(val>200):
		return VG.IDADE_YOUNG
	if(val>100):
		return VG.IDADE_KID
	return VG.IDADE_BABY

func getPokemonJsonFormName(name:String):
	var file = FileAccess.open(pokemonData, FileAccess.READ)
	var content = file.get_as_text()
	
	var json = JSON.new()
	var finish = json.parse_string(content)
	for item in finish['pokemons']:
		if(item['name']==name):
			return item

func getPokemonJson(id:int):
	var file = FileAccess.open(pokemonData, FileAccess.READ)
	var json=null
	if file:
		var content = file.get_as_text()
		var jsonPai = JSON.new()
		var finish = jsonPai.parse_string(content)
		for item in finish['pokemons']:
			if(item['id']==id):
				json= item 
				break
	else:
		print("Erro ao abrir o arquivo: ", pokemonData)
	return json

func getPokemon(id:int,lv = 1):
	var pkm= Classes.pokemon.new()
	var pkmJson=getPokemonJson(id)
	if(pkmJson==null):
		return false
	pkm.json=pkmJson
	pkm.getDadosFromJson()
	pkm.lv=lv
	
	return pkm

func getItemJson(name:String):
	var file = FileAccess.open(itemData, FileAccess.READ)
	var json=null
	if file:
		var content = file.get_as_text()
		
		var jsonPai = JSON.new()
		var finish = jsonPai.parse_string(content)
		for item in finish['item']:
			if(item['name']==name):
				json= item 
				break
	else:
		print("Erro ao abrir o arquivo: ", itemData)
	return json

func getHabilidadeJson(name:String):
	var file = FileAccess.open(habilidadeData, FileAccess.READ)
	var json=null
	if file:
		var content = file.get_as_text()
		var jsonPai = JSON.new()
		var finish = jsonPai.parse_string(content)
		for item in finish['ability']:
			if(item['name']==name):
				json= item 
				break
	else:
		print("Erro ao abrir o arquivo: ", habilidadeData)
	return json
			
func getMoveJson(name:String):
	var file = FileAccess.open(moveData, FileAccess.READ)
	var json=null
	if file:
		var content = file.get_as_text()
		var jsonPai = JSON.new()
		var finish = jsonPai.parse_string(content)
		for item in finish['moves']:
			if(item['name']==name):
				json= item 
				break
	else:
		print("Erro ao abrir o arquivo: ", moveData)
	return json
	
func getPokemonCaracteristicasJson(id:int):
		var file = FileAccess.open(caracteristicasData, FileAccess.READ)
		var json=null
		if file:
			while not file.eof_reached():
				var linha = file.get_line().split(',')
				if(linha[1]==str(id)):
					json={
						'forca':int(linha[2]),
						'resistencia':int(linha[3]),
						'elemento':int(linha[4]),
						'mente':int(linha[5]),
						'aceleracao':int(linha[6]),
						'mobilidade':int(linha[7])
					}
					break
			file.close()
		else:
			print("Erro ao abrir o arquivo: ", caracteristicasData)
		return json

func getEvolutionData(name:String):
	var file = FileAccess.open(evolutionData, FileAccess.READ)
	var json=null
	if file:
		var content = file.get_as_text()
		
		var jsonPai = JSON.new()
		var finish = jsonPai.parse_string(content)
		for item in finish['evolution']:
			if(item[0]==name):
				return item[1] 
				break
	else:
		print("Erro ao abrir o arquivo: ", itemData)

func getTipoID(nomeTipo):
	match nomeTipo:
		"water":
			return VG.TIPO_AGUA
		"dragon":
			return VG.TIPO_DRAGAO
		"electric":
			return VG.TIPO_ELETRICO
		"ghost":
			return VG.TIPO_FANTASMA
		"fire":
			return VG.TIPO_FOGO
		"ice":
			return VG.TIPO_GELO
		"bug":
			return VG.TIPO_INSETO
		"fighting":
			return VG.TIPO_LUTADOR
		"steel":
			return VG.TIPO_METAL
		"normal":
			return VG.TIPO_NORMAL
		"rock":
			return VG.TIPO_PEDRA
		"grass":
			return VG.TIPO_PLANTA
		"psychic":
			return VG.TIPO_PSIQUICO
		"dark":
			return VG.TIPO_SOMBRIO
		"ground":
			return VG.TIPO_TERRA
		"poison":
			return VG.TIPO_VENENO
		"flying":
			return VG.TIPO_VOADOR
			
func getTipoNome(ID):
	
	match ID:
		VG.TIPO_AGUA:
			return "Água"
		VG.TIPO_DRAGAO:
			return "Dragão"
		VG.TIPO_ELETRICO:
			return "Elétrico"
		VG.TIPO_FANTASMA:
			return "Fantasma"
		VG.TIPO_FOGO:
			return "Fogo"
		VG.TIPO_GELO:
			return "Gelo"
		VG.TIPO_INSETO:
			return "Insceto"
		VG.TIPO_LUTADOR:
			return "Lutador"
		VG.TIPO_METAL:
			return "Metal"
		VG.TIPO_NORMAL:
			return "Normal"
		VG.TIPO_PEDRA:
			return "Pedra"
		VG.TIPO_PLANTA:
			return "Planta"
		VG.TIPO_PSIQUICO:
			return "Psiquico"
		VG.TIPO_SOMBRIO:
			return "Sombrio"
		VG.TIPO_TERRA:
			return "Terra"
		VG.TIPO_VENENO:
			return "Venenoso"
		VG.TIPO_VOADOR:
			return "Voador"
	
func getClaseDanoID(nomeClasse):
	
	match nomeClasse:
		"physical":
			return 0
		"special":
			return 1
	return 2

func getNomeClaseDano(ID):
	
	match ID:
		0:
			return "Físico"
		1:
			return "Especial"
	return "Estatus"
 
func getCaracteristicaID(nomeCaracteristica):
	match nomeCaracteristica:
		"forca":
			return VG.ID_FORCA
		"resistencia":
			return VG.ID_RESISTENCIA
		"elemento":
			return VG.ID_ELEMENTO
		"mente":
			return VG.ID_MENTE
		"aceleracao":
			return VG.ID_ACELERACAO
		"mobilidade":
			return VG.ID_MOBILIDADE
		"tamanho":
			return VG.ID_CLASSE_TAMANHO
	
func getArmasID(nomeArma):
	
	match nomeArma:
		"soco":
			return VG.ID_SOCO
		"chute":
			return VG.ID_CHUTE
		"garra":
			return VG.ID_GARRA
		"presa":
			return VG.ID_PRESA
		"espinho":
			return VG.ID_ESPINHO
		"rabo":
			return VG.ID_RABO
		"asa":
			return VG.ID_ASA
		"lingua":
			return VG.ID_LINGUA
		"giro":
			return VG.ID_GIRO
	
func formataNome(nome):
	var novoNome= nome.replace("-", " ")
	var palavras = novoNome.split(" ")
	var resp=""
	for i in range(palavras.size()):
		resp += palavras[i].capitalize()+" "
	return resp

func formataNumero(num):
	var str=''
	if(num<100):
		str+="0"
	if(num<10):
		str+="0"
	str+=str(num)
	return str
