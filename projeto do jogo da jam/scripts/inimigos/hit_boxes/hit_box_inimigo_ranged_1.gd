extends Area2D


var saude = 80

func hit(param_dano):
	saude -= param_dano
	if saude <= 0:
		self.get_parent().inimigo_morto()
	else:
		self.get_parent().inimigo_acertado()
