extends Area2D

export var alvo = Vector2()
var inimigo = []

func _ready():
	#print(get_parent())
	pass
func _process(delta):
	#if global_position.x < 0 or global_position.x > 2000 or global_position.y < 0 or global_position.y > 1000:
	#	queue_free()
	for i in inimigo:
		if i:
			i.congelado = true
		else:
			continue


func _on_Timer_timeout():
	for i in inimigo:
		if i:
			i.congelado = false

	queue_free()
	pass # Replace with function body.


func _on_pause_area_entered(area):

	if area.is_in_group("inimigos") and area.get_parent().congelado == false:
		if $Timer.is_stopped():
			$Timer.start()
		inimigo.append(area.get_parent())

