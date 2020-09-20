extends KinematicBody2D

export onready var tween = get_node("Tween")
onready var dad = get_node("../")
export var stamina = 3
var direcao = Vector2()
var velocidade = 250
var pode_controlar = true

func _ready():
	print(dad)
	$"Timer".start()


func get_movement_input():
	direcao.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direcao.y =  Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up") 
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
	
# warning-ignore:unused_argument
func _process(delta):
	movement()

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
