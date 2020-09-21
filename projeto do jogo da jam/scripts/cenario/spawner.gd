extends Node2D

export onready var inimigo 

func _ready():
	$AnimationPlayer.play("spawn")
	yield($AnimationPlayer, "animation_finished")
	self.get_parent().add_child(inimigo)
