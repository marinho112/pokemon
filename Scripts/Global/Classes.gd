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
	var damageClass: String
	var drain: int
	var effectChance: int
	var effectChanges= []
	var effectEntries= []
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
		resp+=" / "+ damageClass
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
		damageClass = str(json.get("damage_class", ""))
		drain = validaInt(json.get("drain", 0))
		effectChance = validaInt(json.get("effect_chance", 0))
		effectChanges = json.get("effect_changes", [])
		effectEntries = json.get("effect_entries", [])
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
		resp += "Peso: " + str(peso) + " kg\n"
		resp += "Altura: " + str(float(tamanho)/10) + " m\n"
		resp += "Felicidade: " + str(felicidade) + "\n"
		resp += "Fome: " + str(fome) + "\n"
		resp += "Idade: " + str(idade) + "\n"
		resp += "Idade Mínima: " + str(idadeMin) + "\n"
		resp += "Idade Máxima: " + str(idadeMax) + "\n"
		resp += "Nível Mínimo para Evoluir: " + str(lvMinEvolui) + "\n"
		resp += "Nível Máximo para Evoluir: " + str(lvMaxEvolui) + "\n"

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
		
	func getRandomHabilit():
		var habilidades = json.get("abilities", [])
		if habilidades.size() > 0:
			habilidade = Ferramentas.getHabilidadeJson(habilidades[randi()%habilidades.size()])
	
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
		return caracteristica[1]+int(caracteristica[1]*caracteristica[2]/100)+caracteristica[3]
	
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
	
	func getAtributoReal(att):
		var resp=0
		match att:
			VG.ATRIBUTO_ATAQUE:
				resp=atak+int(ev_atak/4)+int((iv_atak+1)/2)
			VG.ATRIBUTO_ESPECIAL_ATAQUE:
				resp=sp_atak+int(ev_sp_atak/4)+int((iv_sp_atak+1)/2)
			VG.ATRIBUTO_DEFESA:
				resp=def+int(ev_def/4)+int((iv_def+1)/2)
			VG.ATRIBUTO_ESPECIAL_DEFESA:
				resp=sp_def+int(ev_sp_def/4)+int((iv_sp_def+1)/2)
			VG.ATRIBUTO_VELOCIDADE:
				resp=speed+int(ev_speed/4)+int((iv_speed+1)/2)
			VG.ATRIBUTO_VIDA:
				resp=hp+int(ev_hp/4)+int((iv_hp+1)/2)
		
		return resp
	
	func getVidaAtual():
		var vidaAtual=getAtributoReal(VG.ATRIBUTO_VIDA)
		vidaAtual-=danoRecebido
		if(vidaAtual<0):
			return 0
		return vidaAtual
	
	func getDesenvolvimento():
		return int((forca[1]+resistencia[1])/10)
	
	func getVariacaoIdade():
		var range= int(idadeMax-idadeMin/100)
		var variMax=120
		var variMin=variMax-(range*30)
		if(range<=2):
			variMin-=10
			variMax-=10
		return [variMin,variMax]
	
	func getPeso():
		return int(peso*(80+getDesenvolvimento()+getVariacaoIdade())/100)
		
	func getTamanho():
		return int(tamanho*(100+getVariacaoIdade())/100)
		
	func getClasseDeTamanho():
		return int((pow(getPeso()*getTamanho(),0.28)*30)-10)

	func temArma(arma):
		for item in armas:
			if(item[0]==arma):
				return item[1]
		return 0

	func getHabilidadeNome():
		return "Não Programado"
		
	func getHabilidadeDescricao():
		return "Ainda Não Foi Programado"
