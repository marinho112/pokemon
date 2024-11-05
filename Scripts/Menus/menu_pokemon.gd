extends Node2D

var pokemon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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

func definePokemon(pkm):
	if(pkm!=null):
		pokemon=pkm
	$telaDescricao/editNo.text=str(pokemon.ID)
	$telaDescricao/editName.text=pokemon.apelido
	$telaDescricao/editOT.text="TesteOT"
	$telaDescricao/editIDNo.text="TesteIDNo"
	$telaDescricao/editItem.text=pokemon.item['name']
	
	$pokemonScreem/editEspecie.text=pokemon.raca
	$pokemonScreem/editLV.text="LV."+str(pokemon.lv)
	
	
