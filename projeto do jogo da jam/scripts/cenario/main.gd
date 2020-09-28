extends Node2D

onready var spawner = preload("res://scenes/Cenario/spawner.tscn")
onready var inimigoPreload = preload("res://scenes/inimigos/inimigo_melee_1.tscn")
export var MaxOndas = 5
export var MaxInimigos = 2
var ondaAtual = 0
var InimigosSobraram = MaxInimigos

var lista_inimigos = [preload("res://scenes/inimigos/inimigo_melee_1.tscn"), 
preload("res://scenes/inimigos/inimigo_ranged_1.tscn"),
preload("res://scenes/inimigos/inimigo_melee_2.tscn")]
var inimigos_possiveis = 3 #numero de modelos de inimigos q poderiam spawnar

func _ready():
	randomize()
	ProximaOnda()
	pass 


func _process(delta):
	$HUD/comboTimer.text = str(Engine.get_frames_per_second())
	$HUD/Vida.text = str($YSort/player/hit_box.saude)
	$HUD/Stamina.value = $YSort/player.stamina
	$HUD/InimigosSobram.text = str(InimigosSobraram) + "/" + str(MaxInimigos)
	$HUD/Wave.text = "WAVE" + str(ondaAtual)
	if InimigosSobraram == 0:
		ProximaOnda()
		InimigosSobraram = MaxInimigos


func ProximaOnda():
	ondaAtual += 1
	if ondaAtual <= MaxOndas:
		if ondaAtual == 3 or ondaAtual == 5:
			MaxInimigos += 2
		for i in MaxInimigos:
			var spawn = spawner.instance()
			var inimigo = lista_inimigos[randi()%inimigos_possiveis].instance()
			inimigo.connect("morreu", self, "inimigo_morreu")
			spawn.global_position  = Vector2(rand_range(10,1000),rand_range(10,550))
#			inimigo.global_position = spawn.global_position
			spawn.inimigo = inimigo
			$"YSort".add_child(spawn)
		pass
	else:
		$HUD/proximaFase.visible = true
		print("proxima fase")


func inimigo_morreu():
	InimigosSobraram -= 1
