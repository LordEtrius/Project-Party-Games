class_name CardUI
extends TextureRect

const ASPECT :=  300. / 200.

@export var draggable = true : set = set_draggable
@export var mouse_animation := true

var _tweener: Tween
var _base_position: Vector2 = Vector2.ZERO
var card = null : set = set_card
var animation_time = 0.25
var sfx_player = AudioStreamPlayer.new()

@onready var _title = $Title
@onready var _description = $Inside/Info/Description
@onready var _indication = $Indication
@onready var _draggable_component := $Draggable as DraggableComponent
@onready var _card_image = $Inside/Image
@onready var _card_info = $Inside/Info
@onready var audio_file = "res://assets/cards/audio/hover_click01.wav"



func set_draggable(new_draggable: bool):
	draggable = new_draggable
	if _draggable_component:
		_draggable_component.drag_active = draggable


func set_card(new_card: Card):
	if card != null:
		card.disconnect("will_play_effect",Callable(self,"_on_Card_will_play_effect"))
		card.disconnect("played_effect",Callable(self,"_on_Card_played_effect"))
	card = new_card
	if new_card != null:
		card.connect("will_play_effect",Callable(self,"_on_Card_will_play_effect"))
		card.connect("played_effect",Callable(self,"_on_Card_played_effect"))
		show()
		# this occurs because this function can
		# be executed before ready state
		if _title and _description:
			_title.text = card.title
			_description.text = card.description
	else:
		hide()
		# this occurs because this function can
		# be executed before ready state
		if _title and _description:
			_title.text = ""
			_description.text = ""


func on_get_drag_data() -> Dictionary:
	var drag_data = {}
	drag_data["type"] = "card"
	drag_data["card"] = card
	return drag_data


func get_control_preview() -> Control:
	var preview = load("res://maps/board/cards/ui/CardUI.tscn").instantiate() as CardUI
	preview.card = card
	preview.draggable = false
	preview.mouse_animation = false
	preview.size = Vector2(100, 150)
	var control = Control.new()
	control.add_child(preview)
	preview.position = -0.5 * preview.size
	return control


func _ready():
	pivot_offset = size / 2
	_base_position = self.position
	
	set_card(card)
	set_draggable(draggable)

	if mouse_animation:
		self._card_info.show()
		self.connect("mouse_entered", Callable(_on_mouse_entered))
		self.connect("mouse_exited", Callable(_on_mouse_exited))


func _on_Card_will_play_effect():
	_animate_active()
	_indication.color = Color.BLUE
	

func _on_Card_played_effect():
	_animate_restore()
	_indication.color = Color.TRANSPARENT


func _on_mouse_entered():
	_animate_mouse_entered()


func _animate_mouse_entered():
	# Update tweener
	_update_tweener()
	# Animate card
	_animate_active()
	# Play sound
	SoundFx.hover_click_hand()
	_tweener.parallel()
	_tweener.tween_property(_card_image, "modulate", Color(1, 1, 1, 0), animation_time)


func _animate_active():
	self.z_index = 1
	_update_tweener()
	_tweener.tween_property(self, "position", _base_position + Vector2(0, -50), animation_time)
	_tweener.parallel()
	_tweener.tween_property(self, "scale", Vector2.ONE * 1.25, animation_time)


func _on_mouse_exited():
	_animate_mouse_exited()
	

func _animate_mouse_exited():
	_update_tweener()
	_animate_restore()
	_tweener.parallel()
	_tweener.tween_property(_card_image, "modulate", Color(1, 1, 1, 1), animation_time)


func _animate_restore():
	self.z_index = 0
	_update_tweener()
	_tweener.tween_property(self, "position", _base_position, animation_time)
	_tweener.parallel()
	_tweener.tween_property(self, "scale", Vector2.ONE, animation_time)


func _update_tweener():
	if _tweener != null and _tweener.is_running():
		_tweener.kill()
	_tweener = create_tween()
