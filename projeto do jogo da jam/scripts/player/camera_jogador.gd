extends Camera2D

var zoom_padrao = Vector2(1, 1)
var posicao_padrao = Vector2()

var pode_zoom = true


func _ready():
	self.current = true


func camera_zoom(param_zoom):
	#pega o zoom atual e soma a quantidade determinada pelo script, a variavel distancia_zoom é modificada no script do jogador, se ativar mais de uma vez, os zooms irao se somar
	var zoom_atual = self.zoom
	$"tween_zoom".interpolate_property(self, "zoom", zoom_atual, zoom_atual + param_zoom, 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	$"tween_zoom".start()


func camera_recuo(param_direcao, param_intensidade, param_duracao): 
	#print("oimfoiam")
	#pega a posicao original e soma a quantidade determinada pelo script, os parametros da direcao do deslocamento, a forca do deslocamento e a duracao serao passados como parametro no script do jogador
	$"tween_recuo".interpolate_property(self, "position", posicao_padrao, posicao_padrao + (param_direcao * param_intensidade), param_duracao, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	$"tween_recuo".start()
	yield($"tween_recuo", "tween_completed") #a animacao de recuo nao da pra fazer com sinal porque os recuos nao podem se somar
	var posicao_atual = self.position
	$"tween_recuo".interpolate_property(self, "position", posicao_atual, posicao_padrao, param_duracao, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	$"tween_recuo".start()


func _on_tween_zoom_tween_all_completed():
	#quando todos as animacoes de zooms terminarem, a camera volta do zoom q ela está para o zoom padrao de (1, 1)
	var zoom_atual = self.zoom
	$"tween_zoom".interpolate_property(self, "zoom", zoom_atual, zoom_padrao, 0.6, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	$"tween_zoom".start()
