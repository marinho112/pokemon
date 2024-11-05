extends Node

class Option:
	var tipo = VG.OPTION
	var personagem
	var menu
	var texto='NotDefined'
	
	func _init(personagem,menu):
		self.personagem=personagem
		self.menu=menu

	func executa() -> void:
		pass

class OptionExit extends Option:
	
	func _init(personagem,menu):
		tipo = VG.OPTION_EXIT
		texto='Sair'
		super(personagem,menu)

	func executa() -> void:
		menu.exclue()

class OptionPokedex extends Option:
	
	func _init(personagem,menu):
		tipo = VG.OPTION_POKEDEX
		texto='Pokedex'
		super(personagem,menu)

	func executa() -> void:
		menu.exclue()

class OptionPokemon extends Option:
	
	func _init(personagem,menu):
		tipo = VG.OPTION_POKEMON
		texto='Pokemon'
		super(personagem,menu)

	func executa() -> void:
		var menu=load('res://Nodes/Menus/menu_pokemon.tscn').instantiate()
		var camera=personagem.get_node("Camera2D")
		camera.add_child(menu)
		menu.z_index=10
		#menu.definePokemon(0)
		menu.ajustaTamanho(100)
		personagem.pilhaAcoes.insert(0,menu)

class OptionPersonagem extends Option:
	
	func _init(personagem,menu):
		tipo = VG.OPTION_PERSONAGEM
		texto=personagem.personagemInfo.nome
		super(personagem,menu)

	func executa() -> void:
		menu.exclue()

class OptionOpcoes extends Option:
	
	func _init(personagem,menu):
		tipo = VG.OPTION_OPTIONS
		texto='Opições'
		super(personagem,menu)

	func executa() -> void:
		menu.exclue()
		
		
