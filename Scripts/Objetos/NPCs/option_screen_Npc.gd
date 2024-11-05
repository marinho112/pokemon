extends Sprite2D

var XInicialCursor
var velocidadeCursor=50
var diferencaCursor= 10
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	XInicialCursor = $Cursor.position[0]

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Cursor.position[0]+=velocidadeCursor*delta
	if(($Cursor.position[0]>diferencaCursor+XInicialCursor)and(velocidadeCursor>0)):
		velocidadeCursor*=-1
	if((velocidadeCursor<0)and($Cursor.position[0]<XInicialCursor)):
		velocidadeCursor*=-1
