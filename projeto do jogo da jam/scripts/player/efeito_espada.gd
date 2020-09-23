extends Node2D


func _ready():
	$"AnimationPlayer".play("efeito_espada")
	yield($"AnimationPlayer", "animation_finished")
	self.queue_free()

