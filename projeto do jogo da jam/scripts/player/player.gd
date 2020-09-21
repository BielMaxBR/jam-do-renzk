extends KinematicBody2D

export onready var tween = get_node("Tween")
onready var dad = get_node("../")
export var stamina = 3
var direcao = Vector2()
var velocidade = 250
var pode_controlar = true
var ataqueDict = {}
var comboIndex = 0
var pode_ataque = true
var cadencia_ataque = 0.2

var dano = 30


func _ready():
	print(dad)
	$"StaminaTimer".start()
	for ataque in $ataques.get_child_count():
		ataqueDict[ataque] = $ataques.get_child(ataque)

	comboIndex = $ataques.get_child_count()


# warning-ignore:unused_argument
func _process(delta):
	movement()
	$"ataques".look_at(get_global_mouse_position()) #mira a arma sempre pro mouse
	if Input.is_action_just_pressed("attack"):
		ataque()


func get_movement_input():
	direcao.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direcao.y =  Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up") 
	direcao = direcao.normalized()
	#if pode_controlar:
	if direcao != Vector2(0,0):
		#print(tween.get_runtime())
		pass
	if Input.is_action_just_pressed("dash") and stamina > 0:
		dash()
		stamina -= 1


func dash():
	tween.interpolate_method(self, "move_and_slide",
	Vector2(0,0) + (get_local_mouse_position().normalized() * 1800), position.normalized(), 2,
	Tween.TRANS_QUINT, Tween.EASE_OUT_IN)
	tween.start()
	pass

func avanco():
	tween.interpolate_method(self, "move_and_slide",
	Vector2(0,0) + (get_local_mouse_position().normalized() * 300), position.normalized(), 1,
	Tween.TRANS_QUINT, Tween.EASE_OUT_IN)
	tween.start()
	pass

func movement():
	get_movement_input()
	if position.x > 1024:
		position.x = 0
	if position.x < 0:
		position.x = 1024
	
	if position.y > 600:
		position.y = 0
	if position.y < 0:
		position.y = 600
	if pode_controlar:
		# warning-ignore:return_value_discarded
		move_and_slide(direcao * velocidade)


func ataque():
	if pode_ataque:
		if $ComboTimer.is_stopped():
			$ComboTimer.start()
		if comboIndex > 0 and not $ComboTimer.is_stopped():
			
			var ataqueAtual = ataqueDict[comboIndex-1]
			var colisor = ataqueAtual.get_child(1)
			var anim = $AnimationPlayer

			colisor.disabled = false
			pode_ataque = false
			comboIndex -= 1
			avanco()
			$AtackTimer.start(cadencia_ataque)
			anim.play("ataque_teste")
			$ComboTimer.start()
			yield(anim, "animation_finished")
			colisor.disabled = true
		pass
		#$"area_ataque/CollisionShape2D".disabled = false
		#$"AnimationPlayer".play("ataque_teste")
		#pode_ataque = false
		#$"candencia_ataque".start(cadencia_ataque)
	#	yield($"AnimationPlayer", "animation_finished")
	#	$"area_ataque/CollisionShape2D".disabled = true


func _on_Timer_timeout():
	if stamina < 3:
		stamina += 1 
	pass


func _on_Tween_tween_all_completed():
	pode_controlar = true
	pass # Replace with function body.


func _on_Tween_tween_started(object, key):
	pode_controlar = false
	pass # Replace with function body.


func jogador_acertado():
	print("jogador_acertado")


func jogador_morto():
	print("jogador_morto")


func _on_candencia_ataque_timeout():
	pode_ataque = true


func _on_area_ataque_area_entered(area):
	area.hit(dano) #se o jogador acertar o inimigo...


func _on_ComboTimer_timeout():
	comboIndex = $ataques.get_child_count()
	pass # Replace with function body.
