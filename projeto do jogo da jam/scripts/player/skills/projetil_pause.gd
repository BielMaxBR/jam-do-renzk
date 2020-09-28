extends Area2D

export var alvo = Vector2()
var stop = false
var inimigo

var vel = 700
func _ready():
	#print(get_parent())
	pass
func _process(delta):
	if global_position.x < 0 or global_position.x > 2000 or global_position.y < 0 or global_position.y > 1000:
		queue_free()
	if stop == true:
		# invisivel
		# mantém o inimigo paralizado
		if inimigo:
			inimigo.congelado = true

		else:
			queue_free()
	else:
		translate(alvo.normalized()* vel * delta)

func _on_Timer_timeout():
	if inimigo:
		inimigo.congelado = false

	stop = false
	queue_free()
	pass # Replace with function body.


func _on_pause_area_entered(area):

	if area.is_in_group("o fim"):
		queue_free()
	if area.is_in_group("inimigos") and area.get_parent().congelado == false:
		$Timer.start()
		inimigo = area.get_parent()
		stop = true
