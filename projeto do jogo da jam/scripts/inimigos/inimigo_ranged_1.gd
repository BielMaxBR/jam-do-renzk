extends KinematicBody2D

var alvo = self #self apenas para n ficar Null e poder dar algum erro
var velocidade = 75 #velocidade com q o inimigo se movimenta
var pode_atirar = true #cadenciador de ataques
var cadencia_ataques = 2.0 #tempo entre cada ataque
var dano = 10 #dano infligido por esse inimigo
var pre_projetil = preload("res://scenes/projeteis/projetil_inmigo_ranged_1.tscn")

signal morreu


func _ready():
	$"hit_box/CollisionShape2D".disabled = false


func _process(delta):
	alvo = self.get_parent().get_node("player") #pega o jogador como alvo
	if (alvo.global_position - self.global_position).length() >= 600: #distancia entre o jogador e o inimigo
		movimento_avanco() #avanca pra cima do jogador
	else:
		tiro() #atira no jogador


func movimento_avanco():
	var direcao_player = (alvo.global_position - self.global_position).normalized()
	move_and_slide(direcao_player * velocidade)


func tiro():
	if pode_atirar:
		pode_atirar = false
		$"AnimationPlayer".play("aviso_ataque_piscada")
		yield($"AnimationPlayer", "animation_finished")
		
		$"AnimationPlayer".play("tiro")
		var mira = alvo.global_position + Vector2(0, -32) #+altura do sprite, pra mirar pro meio dele
		$"arma".look_at(mira)
		
		var projetil = pre_projetil.instance()
		projetil.vetor = Vector2(cos($"arma".global_rotation), sin($"arma".global_rotation))
		projetil.global_rotation = $"arma".global_rotation
		projetil.global_position = $"arma/Position2D".global_position
		self.get_parent().add_child(projetil)
		
		yield($"AnimationPlayer", "animation_finished")
		$"cadencia_tiro".start(cadencia_ataques)


func _on_cadencia_tiro_timeout():
	pode_atirar = true


func _on_area_ataque_area_entered(area):
	area.hit(dano)


func inimigo_acertado():
	print("inimigo acertado")


func inimigo_morto():
	print("inimigo morto")
	emit_signal("morreu")
	self.queue_free()
