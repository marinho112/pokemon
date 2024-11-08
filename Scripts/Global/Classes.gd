extends Node


class personagem:
	
	var nome :String
	var timer : int
	var insignias:int
	var item_select:int
	var persona:int
	var cidadeNatal:String
	var pkms=[]

class ataque:
	
	var nome: String
	var accuracy: int
	var ailment: String
	var ailmentChance: int
	var category: String
	var critRate: int
	var damageClass: int
	var drain: int
	var effectChance: int
	var effectChanges= []
	var effectEntries= []
	var scales=[]
	var armas=[]
	var flavorText: String
	var flinchChance: int
	var healing: int
	var id: int
	var learnedByPokemon= []
	var maxHits: int
	var maxTurns: int
	var minHits: int
	var minTurns: int
	var power: int
	var pp: int
	var priority: int
	var statChance: int
	var statChanges=[]
	var target: String
	var type: int
	
	func toString():
		var resp=Ferramentas.formataNome(nome)
		resp+=" / "+ Ferramentas.getTipoNome(type)
		resp+=" / "+ Ferramentas.getNomeClaseDano(damageClass)
		resp+= " / "+str(pp)+"PP"
		return resp
		
	func validaInt(i):
		if(!i):
			return 0
		return int(i)
	
	func carregaDoJson(json):
		nome = json.get("name", "")
		accuracy = validaInt(json.get("accuracy", 100))
		ailment = str(json.get("ailment", "null"))
		ailmentChance = validaInt(json.get("ailment_chance", 0))
		category = str(json.get("category", ""))
		critRate = validaInt(json.get("crit_rate", 0))
		damageClass = Ferramentas.getClaseDanoID(json.get("damage_class", ""))
		drain = validaInt(json.get("drain", 0))
		effectChance = validaInt(json.get("effect_chance", 0))
		effectChanges = json.get("effect_changes", [])
		effectEntries = json.get("effect_entries", [])
		scales  = []
		var temp = json.get("scales", [])
		for item in temp:
			scales.append([Ferramentas.getCaracteristicaID(item[0]),item[1]])
		armas  = []
		temp = json.get("armas", [])
		for item in temp:
			armas.append(Ferramentas.getArmasID(item))
		flavorText = str(json.get("flavor_text", ""))
		flinchChance = validaInt(json.get("flinch_chance", 0))
		healing = validaInt(json.get("healing", 0))
		id = validaInt(json.get("id", 0))
		learnedByPokemon = json.get("learned_by_pokemon", [])
		maxHits = validaInt(json.get("max_hits", 1))
		maxTurns = validaInt(json.get("max_turns", 0))
		minHits = validaInt(json.get("min_hits", 0))
		minTurns = validaInt(json.get("min_turns", 0))
		power = validaInt(json.get("power", 0))
		pp = validaInt(json.get("pp", 5))
		priority = validaInt(json.get("priority", 0))
		statChance = validaInt(json.get("stat_chance", 0))
		statChanges = json.get("stat_changes", [])
		target = str(json.get("target", ""))
		# Tipo
		if json.has("type"):
			type = Ferramentas.getTipoID(json["type"])
		#type = str(json.get("type", ""))
		
		
	func carregaPorId(ID):
		carregaDoJson(Ferramentas.getMoveJson(ID))

class pokemon:
	const maxTreino=100
	
	var idUnico:int
	var raca:String
	var racaID:int
	var apelido:String
	var lv=1
	var exp:int
	var shiny:bool
	var tipo = [0,0]
	var habilidade:Dictionary
	var peso:int
	var tamanho:int
	var item:Dictionary
	
	var json=null
	var nature=VG.NATURE_HARDY
	var baseExp=0
	var felicidade=0
	var fome=0
	var nutricao=0
	var idade=0
	var idadeMin=0
	var idadeMax=500
	var listaEvolucoes=[]
	var lvMinEvolui=100
	var lvMaxEvolui=100 
	var armas=[]
	var danoRecebido=0
	
	var hp:int
	var atak:int
	var sp_atak:int
	var def:int
	var sp_def:int
	var speed:int
	
	var ev_hp:int
	var ev_atak:int
	var ev_sp_atak:int
	var ev_def:int
	var ev_sp_def:int
	var ev_speed:int
	
	var iv_hp:int
	var iv_atak:int
	var iv_sp_atak:int
	var iv_def:int
	var iv_sp_def:int
	var iv_speed:int
		
	var ataques = [null,null,null,null]
	var sprites = [[null,null,null],[null,null,null],[null,null,null],null,null,null]
	
	var forca = [0,0,0,0]
	var resistencia= [0,0,0,0]
	var mente= [0,0,0,0]
	var elemento= [0,0,0,0]
	var aceleracao= [0,0,0,0]
	var mobilidade= [0,0,0,0]
	
	func _init() -> void:
		idUnico=0
	
	func getIdadeAleatoria():
		var variIdade = idadeMax-idadeMin
		idade= int(idadeMin + randi()%variIdade)
	
	func getIdadeAleatoriaPorLV():
		var variIdade = (idadeMax-idadeMin)/(lvMaxEvolui-lv)
		idade= int(idadeMin + randi()%variIdade)
	
	func calculaBaseStats(BASE,EV,IV):
		return int(((2*BASE)+IV+(EV/4))*lv/100)
	
	func calculaHP():
		var baseHp=int(json.get("hp", 1))
		if(baseHp==1):
			return 1
		return calculaBaseStats(baseHp,ev_hp,iv_hp)+lv+10
		
	func calculaStat(stat):
		var natureBonus=0
		var antesDaNature=0
		match(stat):
			VG.ATRIBUTO_ATAQUE:
				antesDaNature=calculaBaseStats(int(json.get("attack", 1)),ev_atak,iv_atak)+5
			VG.ATRIBUTO_DEFESA:
				antesDaNature=calculaBaseStats(int(json.get("defense", 1)),ev_def,iv_def)+5
			VG.ATRIBUTO_ESPECIAL_ATAQUE:
				antesDaNature=calculaBaseStats(int(json.get("sp_attack", 1)),ev_sp_atak,iv_sp_atak)+5
			VG.ATRIBUTO_ESPECIAL_DEFESA:
				antesDaNature=calculaBaseStats(int(json.get("sp_defense", 1)),ev_sp_def,iv_sp_def)+5
			VG.ATRIBUTO_VELOCIDADE:
				antesDaNature=calculaBaseStats(int(json.get("speed", 1)),ev_speed,iv_speed)+5
		if(nature[1]==stat):
			natureBonus+=10
		if(nature[2]==stat):
			natureBonus-=10
		natureBonus*=antesDaNature/100
		
		return int(antesDaNature+natureBonus)
	
	func calculaAtributosPokemon():
		hp=calculaHP()
		atak=calculaStat(VG.ATRIBUTO_ATAQUE)
		def=calculaStat(VG.ATRIBUTO_DEFESA)
		sp_atak=calculaStat(VG.ATRIBUTO_ESPECIAL_ATAQUE)
		sp_def=calculaStat(VG.ATRIBUTO_ESPECIAL_DEFESA)
		speed=calculaStat(VG.ATRIBUTO_VELOCIDADE)
		
	func getIV():
		var IV=[randi()%32,randi()%32,randi()%32,randi()%32,randi()%32,randi()%32]
		if(shiny):
			IV=[31,31,31,31,31,31]
		return IV
	
	func aplicaIV(IV):
		iv_hp=IV[0]
		iv_atak=IV[1]
		iv_def=IV[2]
		iv_sp_atak=IV[3]
		iv_sp_def=IV[4]
		iv_speed=IV[5]
	
	func getIVBasico():
		aplicaIV(getIV())
	
	func getIVLucky():
		var matrizIV=[]
		var final=[]
		for i in 4:
			matrizIV.append(getIV())
		for i in 6:
			final[i]=maxi(maxi(matrizIV[0][i],matrizIV[1][i]),maxi(matrizIV[2][i],matrizIV[3][i]))
		aplicaIV(final)
	
	func getTotalEV():
		return ev_atak+ev_def+ev_hp+ev_speed+ev_sp_atak+ev_sp_def
	
	func getEV(stat,value):
		if(getTotalEV()>=510):
			return
		match(stat):
			VG.ATRIBUTO_VIDA:
				ev_hp+=value
				if(ev_hp>255):
					ev_hp=255
				if(getTotalEV()>510):
					ev_hp-=getTotalEV()-510
			VG.ATRIBUTO_ATAQUE:
				ev_atak+=value
				if(ev_atak>255):
					ev_atak=255
				if(getTotalEV()>510):
					ev_atak-=getTotalEV()-510
			VG.ATRIBUTO_DEFESA:
				ev_def+=value
				if(ev_def>255):
					ev_def=255
				if(getTotalEV()>510):
					ev_def-=getTotalEV()-510
			VG.ATRIBUTO_ESPECIAL_ATAQUE:
				ev_sp_atak+=value
				if(ev_sp_atak>255):
					ev_sp_atak=255
				if(getTotalEV()>510):
					ev_sp_atak-=getTotalEV()-510
			VG.ATRIBUTO_ESPECIAL_DEFESA:
				ev_sp_def+=value
				if(ev_sp_def>255):
					ev_sp_def=255
				if(getTotalEV()>510):
					ev_sp_def-=getTotalEV()-510
			VG.ATRIBUTO_VELOCIDADE:
				ev_sp_def+=value
				if(ev_sp_def>255):
					ev_sp_def=255
				if(getTotalEV()>510):
					ev_sp_def-=getTotalEV()-510
	
	func toString():
		var resp = "Espécie: " + raca + "\n"
		resp += "Nome: " + apelido + "\n"
		resp += "Nível: " + str(lv) + "\n"
		resp += "HP: " + str(hp) + "\n"
		resp += "Ataque: " + str(atak) + "\n"
		resp += "Defesa: " + str(def) + "\n"
		resp += "Ataque Especial: " + str(sp_atak) + "\n"
		resp += "Defesa Especial: " + str(sp_def) + "\n"
		resp += "Velocidade: " + str(speed) + "\n"
		resp += "Peso: " + str(peso/10.0) + " kg\n"
		resp += "Altura: " + str(tamanho/10.0) + " m\n"
		resp += "Felicidade: " + str(felicidade) + "\n"
		resp += "Fome: " + str(fome) + "\n"
		resp += "Idade: " + str(idade) + "\n"
		resp += "Idade Mínima: " + str(idadeMin) + "\n"
		resp += "Idade Máxima: " + str(idadeMax) + "\n"
		resp += "Nível Mínimo para Evoluir: " + str(lvMinEvolui) + "\n"
		resp += "Nível Máximo para Evoluir: " + str(lvMaxEvolui) + "\n"
		resp += "Evoluções: |"
		for item in listaEvolucoes:
			resp += item[0]['name']+"|"
		resp +="\n"
		resp += "Força: " + str(forca) + "\n"
		resp += "Resistência: " + str(resistencia) + "\n"
		resp += "Mente: " + str(mente) + "\n"
		resp += "Elemento: " + str(elemento) + "\n"
		resp += "Aceleração: " + str(aceleracao) + "\n"
		resp += "Mobilidade: " + str(mobilidade) + "\n"

		resp += "Tipos: |" 
		for item in tipo:
			if item:
				resp+=Ferramentas.getTipoNome(item)+"|"
		resp += "\n"
		
		resp += "Nature: " + str(nature) + "\n"
		resp += "Habilidades: " + str(habilidade['name']) + "\n"
		var i=0
		for arma in armas:
			i+=1
			resp += "Arma"+str(i)+": " + str(arma) + "\n"
		if(i==0):
			resp += "Armas: Nenhuma\n"
		i=0
		for ataque in ataques:
			i+=1
			var str = "null"
			if(ataque):
				str=ataque.toString()
			resp += "Ataque"+str(i)+": " + str + "\n"
		if(i==0):
			resp += "Ataques: Nenhum\n"
		if(item):
			resp += "Item: " + str(item['name']) + "\n"
		else:
			resp += "Item: Nenhum\n"
		resp += "EV HP: " + str(ev_hp) + "\n"
		resp += "EV Ataque: " + str(ev_atak) + "\n"
		resp += "EV Ataque Especial: " + str(ev_sp_atak) + "\n"
		resp += "EV Defesa: " + str(ev_def) + "\n"
		resp += "EV Defesa Especial: " + str(ev_sp_def) + "\n"
		resp += "EV Velocidade: " + str(ev_speed) + "\n"

		resp += "IV HP: " + str(iv_hp) + "\n"
		resp += "IV Ataque: " + str(iv_atak) + "\n"
		resp += "IV Ataque Especial: " + str(iv_sp_atak) + "\n"
		resp += "IV Defesa: " + str(iv_def) + "\n"
		resp += "IV Defesa Especial: " + str(iv_sp_def) + "\n"
		resp += "IV Velocidade: " + str(iv_speed) + "\n"
		
		return resp
	
	func imprime():
		print(toString())
	
	func darApelido(novoApelido):
		if(novoApelido=="")or(novoApelido==null):
			apelido=raca.capitalize()
		else:
			apelido=novoApelido
	
	func carregaAtaquePorId(posi,id):
		var move = ataque.new()
		print(id)
		move.carregaPorId(id)
		ataques[posi]=move
	
	func recebeListaAtaques(mode):
		var lis=[]
		match mode:
			0:
				lis+=json.get('movesFromLv',null)
			1:
				lis+=json.get('movesFromLearn',null)
			2:
				lis+=json.get('movesFromEgg',null)
		return lis
	
	func recebeUltimosAtaques():
		var atks=recebeListaAtaques(0)
		var atksValidos=[]
		for item in atks:
			if(item[1]<=lv):
				atksValidos.append(item)
		if(atksValidos.size()<=0):
			return
		for i in 4:
			var x=atksValidos.size()-i-1
			if(x>=0):
				carregaAtaquePorId(i,atksValidos[x][0])
				
	func getDadosFromJson():
		
		racaID = int(json.get("id", 0))
		raca = json.get("name", "")
		hp = int(json.get("hp", 0))
		atak = int(json.get("attack", 0))
		sp_atak = int(json.get("sp_attack", 0))
		def = int(json.get("defense", 0))
		sp_def = int(json.get("sp_defense", 0))
		speed = int(json.get("speed", 0))
		peso = int(json.get("weight", 0))
		tamanho=int(json.get("height", 0))
		
		baseExp = int(json.get("base_experience", 0))
		darApelido(apelido)
		
		# Tipos
		if json.has("types"):
			for i in range(min(json["types"].size(), 2)):
				tipo[i] = Ferramentas.getTipoID(json["types"][i])
		
		var evolution = Ferramentas.getEvolutionData(raca)
		listaEvolucoes=[]
		if(evolution!=null):
			for item in evolution:
				var evo =Ferramentas.getPokemonJsonFormName(item[0])
				if(evo!=null):
					listaEvolucoes.append([evo,item[1]])
		getLvMinMax()
	
	func getRandomHabilit():
		var habilidades = json.get("abilities", [])
		var listHab=[]
		for item in habilidades:
			var tmp = Ferramentas.getHabilidadeJson(item)
			if(tmp!=null):
				listHab.append(tmp)
		if listHab.size() > 0:
			habilidade = listHab[randi()%listHab.size()]
	
	func getRandomItem():
		var held_items = json.get("held_items", [])
		if held_items.size() > 0:
			item = Ferramentas.getItemJson(held_items[randi()%held_items.size()] )
	
	func getCaracteristica(nomeCaracteristica):
		var caracteristica=[]
		match nomeCaracteristica:
			VG.CARACTERISTICA_FORCA:
				caracteristica=forca
			VG.CARACTERISTICA_RESISTENCIA:
				caracteristica=resistencia
			VG.CARACTERISTICA_MENTE:
				caracteristica=mente
			VG.CARACTERISTICA_ELEMENTO:
				caracteristica=elemento
			VG.CARACTERISTICA_ACELERACAO:
				caracteristica=aceleracao
			VG.CARACTERISTICA_MOBILIDADE:
				caracteristica=mobilidade
		var calcCar=caracteristica[1]+caracteristica[3]
		return calcCar+int(calcCar*caracteristica[2]/100)
	
	func getLvMinMax():
		var filePath="res://dados/idade.txt"
		var file = FileAccess.open(filePath, FileAccess.READ)
		var cont=0
		if file:
			idadeMax=0
			while not file.eof_reached():
				var linha = file.get_line()
				if(linha[0]!='#'):
					var linaLista= linha.split(',')
					for item in linaLista:
						if(int(item) == racaID):
							if(cont<5):
								idadeMin=100*cont
							else:
								idadeMax=500
						for evolucao in listaEvolucoes:
							if(int(item)==evolucao[0]["id"]):
								idadeMax=maxi(idadeMax,cont*100)
								if(evolucao[1]["min_level"]!=null):
									var lv = evolucao[1]["min_level"]
									lvMinEvolui= int(lv*80/100)
									lvMaxEvolui= int(lv*120/100)
					cont+=1
			file.close()
			if(listaEvolucoes.size()<=0):
				idadeMax=500
		else:
			print("Erro ao abrir o arquivo: ", filePath)
		
		
	
	func carregaCaracteristicas():
		var caracteristicasJson=Ferramentas.getPokemonCaracteristicasJson(racaID)
		if(caracteristicasJson):
			forca[0]=caracteristicasJson['forca']
			resistencia[0]=caracteristicasJson['resistencia']
			elemento[0]=caracteristicasJson['elemento']
			mente[0]=caracteristicasJson['mente']
			aceleracao[0]=caracteristicasJson['aceleracao']
			mobilidade[0]=caracteristicasJson['mobilidade']
			calculaCaracteristicas()
			return
	
	func getTreinoCaracteristicaBasico():
		var maximo= int(idade/20) +6
		
		forca[3]=randi()%maximo
		resistencia[3]=randi()%maximo
		elemento[3]=randi()%maximo
		mente[3]=randi()%maximo
		aceleracao[3]=randi()%maximo
		mobilidade[3]=randi()%maximo
	
	func calculaCaracteristica(caracteristica):
		const maxIdadeCalculavel=300
		if(idade>=maxIdadeCalculavel):
			caracteristica[1]=caracteristica[0]
			return false
		var newIdadeMax=min(idadeMax,maxIdadeCalculavel)
		var minPercent=100-(((newIdadeMax-idadeMin)/10.0)*2)
		var porcentagem = minPercent + ((idade*100.0 / newIdadeMax) * (100-minPercent))/100.0
		caracteristica[1]=  int(caracteristica[0] * (porcentagem / 100.0))
		return true
	
	func calculaCaracteristicas():
		calculaCaracteristica(forca)
		calculaCaracteristica(resistencia)
		calculaCaracteristica(elemento)
		calculaCaracteristica(mente)
		calculaCaracteristica(aceleracao)
		calculaCaracteristica(mobilidade)
	
	func getVidaAtual():
		var vidaAtual=hp
		vidaAtual-=danoRecebido
		if(vidaAtual<0):
			return 0
		return vidaAtual
	
	func getDesenvolvimento():
		return int((forca[1]+resistencia[1])/10)
	
	func getVariacaoIdade():
		var range= int((idadeMax-idadeMin)/100)
		var variMax=120
		var variMin=variMax-(range*20)
		if(range<=2):
			variMin-=10
			variMax-=10
		var aux= ((idade*variMax)-(idade*variMin))/(idadeMax-idadeMin)
		var proporcao=int((variMax-variMin)/100*aux)+variMin
		return proporcao-100
	
	func getPeso():
		return int(peso*(80+getDesenvolvimento()+getVariacaoIdade())/100)
		
	func getTamanho():
		return int(tamanho*(100+getVariacaoIdade())/100)
		
	func getClasseDeTamanho():
		return int(((pow(getPeso()*getTamanho(),0.28)*30)/4)+10)

	func temArma(arma):
		for item in armas:
			if(item[0]==arma):
				return item[1]
		return 0

	func getHabilidadeNome():
		return "Não Programado"
		
	func getHabilidadeDescricao():
		return "Ainda Não Foi Programado"
		
	func getPokemonBase():
		getIdadeAleatoria()
		carregaCaracteristicas()
		getRandomHabilit()
		getIVBasico()
		getTreinoCaracteristicaBasico()
		var itemChance = json.get("held_items", []).size()*5
		if(randi()%100<itemChance):
			getRandomItem()
		recebeUltimosAtaques()
		calculaAtributosPokemon()
