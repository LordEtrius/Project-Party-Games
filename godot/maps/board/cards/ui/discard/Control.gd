extends PanelContainer

signal discarded(card)

var _tweener: Tween

func _can_drop_data(_position, data):
	if "card" in data:
		return data.card != null
	return false


func _drop_data(_position, data):
	emit_signal("discarded", data.card)


func animate():
	if _tweener != null and _tweener.is_running():
		_tweener.kill()
	
	_tweener = create_tween().set_trans(Tween.TRANS_SINE)
	
	var base_scale = scale
	_tweener.tween_property(
		self, "scale", base_scale * 1.25, 0.5
	)
	_tweener.tween_property(
		self, "scale", base_scale, 0.5
	)
	await _tweener.finished
