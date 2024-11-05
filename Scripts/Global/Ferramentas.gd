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
