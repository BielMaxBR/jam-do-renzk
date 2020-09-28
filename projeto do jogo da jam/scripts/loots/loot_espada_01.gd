extends Area2D

var personagem
var loot = "res://scenes/armas/espada_01.tscn"
var drop = "res://scenes/loots/loot_espada_01.tscn"

func _ready():
	$"Sprite".visible = true
	$"CollisionShape2D".disabled = false



func _process(delta):
	if Input.is_action_just_pressed("action"):
		if personagem != null:
			personagem.coletar_loot_arma(loot, drop)
			$"CollisionShape2D".disabled = true
			self.queue_free()
			self.set_process(false)


func _on_loot_espada_01_body_entered(body):
	personagem = body
	$"Label".visible = true
	self.set_process(true)


func _on_loot_espada_01_body_exited(body):
	$"Label".visible = false
	self.set_process(false)
