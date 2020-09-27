extends KinematicBody2D
#sistema de variacao de animacoes no ataque, impulsao no jogador qnd atacar

export onready var tween = get_node("tween_dash")
onready var Pre_skill_Pause = preload("res://scenes/player/skills/projetil_pause.tscn")
onready var dad = get_node("../")
export var stamina = 3
var direcao = Vector2()
var velocidade = 200
var pode_controlar = true
var ataqueDict = {}
var FixedComboIndex = -1
export var comboIndex = 0
var pode_ataque = true
var cadencia_ataque = 0.15

var forca_recuo = 60
var zoom_hit = Vector2(0.05, 0.05)

var dano = 30

var pre_efeito = preload("res://scenes/player/efeito_espada.tscn")
var estado_atual = "negativo"
var dic_angulo = {"negativo": 300, "positivo": -300}
var dic_aux = {"negativo": "positivo", "positivo": "negativo"}

signal recuo
signal zoom

func _ready():
	self.connect("recuo", $"camera_jogador", "camera_recuo")
	self.connect("zoom", $"camera_jogador", "camera_zoom")
	$"stamina_timer".start()
	$"arma/area_ataque/colisao_area".disabled = true

# warning-ignore:unused_argument
func _process(delta):
	if (get_global_mouse_position() - self.global_position).x >= 0:
		$"sprite_personagem".flip_h = false
	else:
		$"sprite_personagem".flip_h = true
	movement()
	$"arma".look_at(get_global_mouse_position()) #mira a arma sempre pro mouse
	if Input.is_action_just_pressed("attack"):
		avanco()
		ataque()
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
		skill.alvo = get_global_mouse_position() - (self.global_position)
		get_parent().add_child(skill)
	pass


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


func avanco():
	var vetor_direcao = (get_global_mouse_position() - self.global_position).normalized()
	tween.interpolate_method(self, "move_and_slide",
	vetor_direcao*200, global_position.normalized(), 1)
	tween.start()


func ataque():
	if pode_ataque:
		$"arma/area_ataque/colisao_area".disabled = false
		var vetor_direcao = (get_global_mouse_position() - self.global_position).normalized()
		emit_signal("recuo", vetor_direcao, forca_recuo, cadencia_ataque/2)
		var efeito = pre_efeito.instance()
		efeito.global_position = $"arma/posicao_efeito".global_position
		efeito.global_rotation = $"arma/posicao_efeito".global_rotation
		self.get_parent().add_child(efeito)
		
		var rotacao_atual = $"arma/espada".rotation_degrees
		$"tween_ataque".interpolate_property($"arma/espada", "rotation_degrees", rotacao_atual, rotacao_atual + dic_angulo[estado_atual], cadencia_ataque, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN )
		$"tween_ataque".start()
		estado_atual = dic_aux[estado_atual]
		pode_ataque = false
		$"cadencia_ataque".start(cadencia_ataque)


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


func _on_area_ataque_area_entered(area):
	if area.has_method("hit"):
		area.hit(dano) #se o jogador acertar o inimigo...


func _on_cadencia_ataque_timeout():
	pode_ataque = true


func _on_tween_ataque_tween_completed(object, key):
	$"arma/area_ataque/colisao_area".disabled = true
