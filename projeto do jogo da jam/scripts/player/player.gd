extends KinematicBody2D
#sistema de variacao de animacoes no ataque, impulsao no jogador qnd atacar

export onready var tween = get_node("tween_dash")
onready var Pre_skill_Pause = preload("res://scenes/player/skills/projetil_pause.tscn")
onready var dad = get_node("../")
export var stamina = 3
var direcao = Vector2()
var velocidade = 200
var pode_controlar = true

var arma_atual = "nada"
var drop_arma_atual = "nada"


func coletar_loot_arma(param_loot, param_drop):
	if arma_atual == "nada": #se nao tiver nenhuma arma...
		var instancia = load(param_loot).instance() #carrega e adiciona a nova arma
		$"inventario_armas".add_child(instancia)
		arma_atual = param_loot #define as variaveis das armas e do drop com os endereços das cenas de cada
		drop_arma_atual = param_drop
	
	else: #se o jogador ja tiver alguma arma...
		$"inventario_armas".get_child(0).queue_free() #apaga o node da arma anteriormente equipada
		
		var instancia = load(param_loot).instance() #carrega e adiciona a nova arma
		$"inventario_armas".add_child(instancia)
		arma_atual = param_loot #define as variaveis das armas e do drop
		drop_arma_atual = param_drop
		
		var drop = load(drop_arma_atual).instance() #adiciona a cena do loot da arma no YSort
		drop.global_position = self.global_position
		self.get_parent().add_child(drop)


func _ready():
	$"stamina_timer".start()

# warning-ignore:unused_argument
func _process(delta):
	print($"inventario_armas".get_children())
	if (get_global_mouse_position() - self.global_position).x >= 0:
		$"sprite_personagem".flip_h = false
	else:
		$"sprite_personagem".flip_h = true
	movement()
	
	if Input.is_action_just_pressed("skill_1"):
		skill(1)

func get_movement_input():
	direcao.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direcao.y =  Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up") 
	direcao = direcao.normalized()
	
	if direcao != Vector2():
		$"AnimationPlayer".play("corrida_jogador")
	else:
		$"AnimationPlayer".play("idle_personagem")
	
	if Input.is_action_just_pressed("dash") and stamina > 0:
		dash()
		stamina -= 1

func skill(slot):
	if slot == 1:
		var skill = Pre_skill_Pause.instance()
		skill.global_position = get_global_position()
		#skill.look_at(get_global_mouse_position())
		skill.alvo = get_global_mouse_position() - (self.global_position+Vector2(0,-30))
		get_parent().add_child(skill)


func dash():
	tween.interpolate_method(self, "move_and_slide",
	Vector2(0,0) + ((get_global_mouse_position() - self.global_position).normalized() * 1200), global_position.normalized(), 2,
	Tween.TRANS_QUINT, Tween.EASE_OUT_IN)
	tween.start()


func movement():
	get_movement_input()
	if pode_controlar:
		# warning-ignore:return_value_discarded
		move_and_slide(direcao * velocidade)


func _on_stamina_timer_timeout():
	if stamina < 3:
		stamina += 1 


func _on_tween_dash_tween_started(object, key):
	pode_controlar = false
	$hit_box/colisao_hit_box.disabled = true


func _on_tween_dash_tween_all_completed():
	pode_controlar = true
	$hit_box/colisao_hit_box.disabled = false


func jogador_acertado():
	#print("jogador_acertado")
	pass


func jogador_morto():
	#print("jogador_morto")
	pass
