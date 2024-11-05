extends Eventos.EventoComplexo


func defineTipo():
	self.tipo = VG.EVENTO_AO_TOCAR
	
func onTouch(personagem):
	criaDialogo(personagem)
	return true
