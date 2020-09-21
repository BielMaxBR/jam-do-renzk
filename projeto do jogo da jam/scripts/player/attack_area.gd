extends Area2D


export var dano = 15

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("area_entered", self, "area_entered")
	pass # Replace with function body.


func area_entered(area):
	if area.name != "player":
		area.hit(dano)
