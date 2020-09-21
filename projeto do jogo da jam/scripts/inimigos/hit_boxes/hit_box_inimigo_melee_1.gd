extends Area2D

var saude = 100


func hit(param_dano):
	saude -= param_dano
	if saude <= 0:
		self.get_parent().inimigo_morto(saude)
	else:
		self.get_parent().inimigo_acertado(saude)
