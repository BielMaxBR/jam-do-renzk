extends Node2D

export onready var inimigo 

func _ready():
	$AnimationPlayer.play("spawn")
	yield($AnimationPlayer, "animation_finished")
	if inimigo != null:
		self.get_parent().add_child(inimigo)
	else:
		#print("variavel do spawn = null")
		pass
	self.queue_free()
