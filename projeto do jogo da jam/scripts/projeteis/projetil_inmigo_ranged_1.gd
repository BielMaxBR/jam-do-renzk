extends Area2D

var dano = 20
var vetor = Vector2() #vetor que o projetil vai seguir
var velocidade = 250 #velocidade do projetil

func _ready():
	$"CollisionShape2D".disabled = false


func _process(delta):
	if global_position.x < 0 or global_position.x > 2000 or global_position.y < 0 or global_position.y > 1000:
		queue_free()
	translate(vetor * velocidade * delta)


func _on_projetil_inimigo_ranged_1_area_entered(area):
	if area.has_method("hit"):
		area.hit(dano)
		queue_free()
	else:
		queue_free()
