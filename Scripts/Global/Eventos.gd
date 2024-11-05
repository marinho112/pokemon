extends Node

class Evento extends Node:
	var tipo: String
	
	func defineTipo():
		self.tipo = VG.EVENTO
		
	func _init():
		defineTipo()

	func onClick(personagem):
		return false
		
	func onTouch(personagem):
		return false
		
	func onletItGo(personagem):
		return false
		
	func onRange(personagem):
		return false
	
	func exclue(personagem):
		return false
	
class EventoMsgOnCLik extends Evento:
	
	var mensagem="Menssagem Não Determinada!"
	
	func defineTipo():
		self.tipo = VG.EVENTO_MSG_ON_CLICK
		
	func onClick(personagem):
		var acaoMsg=Acoes.AcaoMsg.new(personagem,mensagem)
		personagem.pilhaAcoes.append(acaoMsg)
		return true
	
	
class EventoComplexo extends Eventos.Evento:

	var dialogo=["Menssagem Não Determinada!","Menssagem Não Determinada2"]
	var opcoes=[]# Exemplo de Opções: [[1,["$$img0","$$img1"]]]

	func setDialogo(dialogo:Array):
		self.dialogo=dialogo
		
	func setOpcoes(opcoes:Array):
		self.opcoes=opcoes
	
	func defineTipo():
		self.tipo = VG.EVENTO_COMPLEXO
		
	func criaDialogo(personagem):
		var acaoDialogo=Acoes.AcaoDialogo.new(personagem,self)
		personagem.pilhaAcoes.append(acaoDialogo)
	
	func selecionaOPT1(pontoDoDialogo,tipoImput,acao):
		acao.avancaDialogo()
	
	func selecionaOPT2(pontoDoDialogo,tipoImput,acao):
		acao.avancaDialogo()
		
	func selecionaOPT3(pontoDoDialogo,tipoImput,acao):
		acao.avancaDialogo()
		
	func selecionaOPT4(pontoDoDialogo,tipoImput,acao):
		acao.avancaDialogo()
		
	func selecionaOPT5(pontoDoDialogo,tipoImput,acao):
		acao.avancaDialogo()
