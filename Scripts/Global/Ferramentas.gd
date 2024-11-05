extends Node

const pokemonData="res://dados/pokemon_DB.txt"
const itemData="res://dados/item_DB.txt"
const habilidadeData="res://dados/ability_DB.txt"
const moveData='res://dados/move_DB.txt'
const caracteristicasData='res://dados/caracteristicas_DB.txt'

func getPokemonJsonFormName(name:float):
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

func getPokemon(id:int):
	var pkm= Classes.pokemon.new()
	var pkmJson=getPokemonJson(id)
	if(pkmJson==null):
		return false
	pkm.json=pkmJson
	pkm.getDadosFromJson()
	
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
		"fight":
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
