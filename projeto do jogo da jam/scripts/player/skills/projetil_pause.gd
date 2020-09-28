extends Area2D

export var alvo = Vector2()
var stop = false
var inimigo
var danoInimigo = 0
var vel = 500
func _ready():
	#print(get_parent())
	pass
func _process(delta):
	if stop == true:
		# invisivel
		# mantém o inimigo paralizado
		if inimigo:
			inimigo.global_position = self.global_position+Vector2(0,32)
			# salva o dano do inimigo pra voltar dps
			if danoInimigo == 0:
				danoInimigo = inimigo.dano
			# zera o dano
			inimigo.dano = 0
		else:
			queue_free()
	else:
		translate(alvo.normalized()* vel * delta)

func _on_Timer_timeout():
	if inimigo:
		inimigo.dano = danoInimigo
	stop = false
	queue_free()
	pass # Replace with function body.


func _on_pause_area_entered(area):
	print("e bateu")
	if area.is_in_group("o fim"):
		queue_free()
	if area.is_in_group("inimigos"):
		$Timer.start()
		inimigo = area.get_parent()
		stop = true
