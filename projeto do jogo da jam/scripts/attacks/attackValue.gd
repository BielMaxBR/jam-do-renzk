extends Node

export var damage = 5
export var knockback = 2
# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("body_entered", self, "_on_body_entered")
	pass # Replace with function body.

func _on_body_entered(body):
	if body.name != "player":
		body.damage(damage, knockback)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
