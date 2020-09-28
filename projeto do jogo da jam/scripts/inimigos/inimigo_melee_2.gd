extends RigidBody2D


var alvo = self
var tempo_para_avanco = 3.0
var velocidade = 1000
export var dano = 20
var saude = 100

signal morreu


func _ready():
	$"Timer_avanco".start(tempo_para_avanco)
	$"Timer_avanco".one_shot = false
	$"area_contato/CollisionShape2D".disabled = true
	self.bounce = 0.0 #forca de ricochete
	self.linear_damp = 0.2 #atrito com o chao
	self.friction = 0.5 #atrio de arrasto com as paredes
	$"hit_box".saude = saude


func _process(delta):
	alvo = self.get_parent().get_node("player")


func _on_Timer_avanco_timeout():
	var direcao = (alvo.global_position - self.global_position).normalized() * 500
	$"Animation_Player".play("aviso_ataque_piscada")
	yield($"Animation_Player", "animation_finished")
	$"area_contato/CollisionShape2D".disabled = false
	self.linear_velocity = direcao
#	self.apply_impulse(Vector2(), direcao * velocidade)


func _on_area_contato_area_entered(area):
	area.hit(dano)


func inimigo_acertado(param_saude):
	#print("inimigo_acertado, saude: ", param_saude)
	pass

func inimigo_morto(param_saude):
	#print("inimigo_morto, saude: ", param_saude)
	emit_signal("morreu")
	queue_free()
