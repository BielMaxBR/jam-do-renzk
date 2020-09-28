extends Node2D

var pode_ataque = true
var cadencia_ataque = 0.15

var forca_recuo = 60
var zoom_hit = Vector2(0.05, 0.05)

var dano = 30

var pre_efeito = preload("res://scenes/player/efeito_espada.tscn")
var estado_atual = "negativo"
var dic_angulo = {"negativo": 300, "positivo": -300}
var dic_aux = {"negativo": "positivo", "positivo": "negativo"}
var dic_postura = {true: -130, false:0}

var posicao_no_personagem = Vector2(0, -12)

signal recuo
signal zoom


func _ready():
	$"area_ataque/colisao_area".disabled = true
	self.position = posicao_no_personagem
	self.connect("recuo", self.get_parent().get_parent().get_node("camera_jogador"), "camera_recuo")
	self.connect("zoom", self.get_parent().get_parent().get_node("camera_jogador"), "camera_zoom")


func _process(delta):
#	$"postura".global_rotation = dic_postura[self.get_parent().get_child(1).flip_h]
	
	self.look_at(get_global_mouse_position()) #mira a arma sempre pro mouse
	if Input.is_action_just_pressed("attack"):
		ataque()


func ataque():
	if pode_ataque:
		avanco()
		$"area_ataque/colisao_area".disabled = false
		var vetor_direcao = (get_global_mouse_position() - self.global_position).normalized()
		emit_signal("recuo", vetor_direcao, forca_recuo, cadencia_ataque/2)
		
		var efeito = pre_efeito.instance()
		efeito.global_position = $"posicao_efeito".global_position
		efeito.global_rotation = $"posicao_efeito".global_rotation
		self.get_parent().get_parent().get_parent().add_child(efeito) #pega o pai do pai do pai kkk (inventario_armas -> jogador -> YSort)
		
		var rotacao_atual = $"postura/espada".rotation_degrees
		$"tween_ataque".interpolate_property($"postura/espada", "rotation_degrees", rotacao_atual, rotacao_atual + dic_angulo[estado_atual], cadencia_ataque, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN )
		$"tween_ataque".start()
		estado_atual = dic_aux[estado_atual]
		pode_ataque = false
		$"cadencia_ataque".start(cadencia_ataque)


func avanco():
	var vetor_direcao = (get_global_mouse_position() - self.global_position).normalized()
#	tween.interpolate_method(self.get_parent(), "move_and_slide",
#	vetor_direcao*200, global_position.normalized(), 1)
#	tween.start()


func _on_cadencia_ataque_timeout():
	pode_ataque = true


func _on_tween_ataque_tween_completed(object, key):
	$"area_ataque/colisao_area".disabled = true


func _on_area_ataque_area_entered(area):
	if area.has_method("hit"):
		area.hit(dano) #se o jogador acertar o inimigo...
