extends Area2D

export var alvo = Vector2()
var stop = false
var inimigo = []

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
		for i in inimigo:
			if i:
				i.congelado = true
			else:
				queue_free()
	else:
		translate(alvo.normalized()* vel * delta)

func _on_Timer_timeout():
	for i in inimigo:
		if i:
			i.congelado = false

	stop = false
	queue_free()
	pass # Replace with function body.


func _on_pause_area_entered(area):

	if area.is_in_group("o fim"):
		queue_free()
	if area.is_in_group("inimigos") and area.get_parent().congelado == false:
		$Timer.start()
		inimigo.append(area.get_parent())
		$CollisionShape2D.set_deferred("disabled", true)
		$Area2D/CollisionShape2D.set_deferred("disabled", false)
		stop = true


func _on_Area2D_area_entered(area):
	if area.is_in_group("inimigos") and area.get_parent().congelado == false:
		inimigo.append(area.get_parent())
	pass # Replace with function body.
