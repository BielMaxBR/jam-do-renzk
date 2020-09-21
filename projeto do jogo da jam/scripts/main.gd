extends Node2D

export var MaxOndas = 3
export var MaxInimigos = 2
var ondaAtual = 0
var InimigosSobraram = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	$HUD/ProgressBar.value = $player.stamina
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
