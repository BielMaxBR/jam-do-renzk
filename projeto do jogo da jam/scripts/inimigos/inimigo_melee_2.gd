extends RigidBody2D


var alvo = self
var tempo_para_avanco = 3.0
var velocidade = 1000
export var dano = 20
var saude = 100

signal morreu

export var congelado = false

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
	if congelado:
		linear_velocity = Vector2(0,0)


func _on_Timer_avanco_timeout():
	if not congelado:
		var direcao = (alvo.global_position - self.global_position).normalized() * 500
		for i in range(0,5):
			$"Sprite".play("parado")
			yield($"Sprite", "animation_finished")
		if direcao.normalized().x > direcao.normalized().y:
			$Sprite.play("lateral")
		else:
			$Sprite.play("frontal")
		if alvo.global_position.x > global_position.x:
			$Sprite.flip_h = false
		else:
			$Sprite.flip_h = true
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
