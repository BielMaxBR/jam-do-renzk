extends Area2D

var saude = 100


func hit(param_dano):
	saude -= param_dano
	if saude <= 0:
		self.get_parent().jogador_morto()
	else:
		self.get_parent().jogador_acertado()
