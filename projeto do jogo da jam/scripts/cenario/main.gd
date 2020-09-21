extends Node2D

onready var spawner = preload("res://scenes/Cenario/spawner.tscn")
onready var inimigoPreload = preload("res://scenes/inimigos/inimigo_melee_1.tscn")
export var MaxOndas = 3
export var MaxInimigos = 2
var ondaAtual = 0
var InimigosSobraram = MaxInimigos

func _ready():
	ProximaOnda()
	pass 

func ProximaOnda():
	ondaAtual += 1
	if ondaAtual <= MaxOndas:
		for i in MaxInimigos:
			var spawn = spawner.instance()
			var inimigo = inimigoPreload.instance()
			inimigo.connect("morreu", self, "inimigo_morreu")
			spawn.position  = Vector2(rand_range(10,1000),rand_range(10,550))
			inimigo.position = spawn.position
			spawn.inimigo = inimigo
			add_child(spawn)
		pass
	else:
		$HUD/proximaFase.visible = true
		print("proxima fase")
	

func _process(delta):
	$HUD/ProgressBar.value = $player.stamina
	$HUD/InimigosSobram.text = str(InimigosSobraram) + "/" + str(MaxInimigos)
	$HUD/Wave.text = "WAVE" + str(ondaAtual)
	if InimigosSobraram == 0:
		InimigosSobraram = MaxInimigos
		ProximaOnda()
func inimigo_morreu():
	InimigosSobraram -= 1
