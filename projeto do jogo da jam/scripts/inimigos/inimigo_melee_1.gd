extends KinematicBody2D

var alvo = self #self apenas para n ficar Null e poder dar algum erro
var velocidade = 100 #velocidade com q o inimigo se movimenta
var pode_ataque = true #cadenciador de ataques
var cadencia_ataques = 1.0 #tempo entre cada ataque
export var dano = 10 #dano infligido por esse inimigo

signal morreu

export var congelado = false
func _ready():
	$"area_ataque/CollisionShape2D".disabled = true
	$"hit_box/CollisionShape2D".disabled = false


func _process(delta):
	alvo = self.get_parent().get_node("player") #pega o jogador como alvo
	if not congelado:
		if (alvo.global_position - self.global_position).length() >= 50: #distancia entre o jogador e o inimigo
			movimento_avanco() #avanca pra cima do jogador
		else:
			ataque() #ataca o jogador


func movimento_avanco():
	var direcao_player = (alvo.global_position - self.global_position).normalized()
	move_and_slide(direcao_player * velocidade)


func ataque():
	if pode_ataque:
		pode_ataque = false
		$"area_ataque".look_at(alvo.global_position + Vector2(0, -12)) #+altura do sprite, pra mirar pro meio dele
		$"AnimationPlayer".play("aviso_ataque_piscada")
		yield($"AnimationPlayer", "animation_finished")
		$"AnimationPlayer".play("ataque")
		$"area_ataque".look_at(alvo.global_position + Vector2(0, -32)) #+altura do sprite, pra mirar pro meio dele
		$"area_ataque/CollisionShape2D".disabled = false
		yield($"AnimationPlayer", "animation_finished")
		$"area_ataque/CollisionShape2D".disabled = true
		$"cadencia_ataque".start(cadencia_ataques)


func _on_cadencia_ataque_timeout():
	pode_ataque = true


func _on_area_ataque_area_entered(area):
	area.hit(dano)


func inimigo_acertado(param_saude):
	#print("inimigo acertado ", param_saude)
	pass

func inimigo_morto(param_saude):
	#print("inimigo morto ", param_saude)
	emit_signal("morreu")
	self.queue_free()
