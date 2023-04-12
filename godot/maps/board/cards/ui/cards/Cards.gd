class_name Cards
extends Control

const CARD_UI_SCENE := preload("res://maps/board/cards/ui/CardUI.tscn")

@export var draggable := true
@export var mouse_animation := true
@export var separation: float = 0.11
@export var sound_active: bool = false

var _cards: Array[Card] = []
var _tweener: Tween

@onready var _arc := $Arc as Path2D


func disable_drag():
	for follow_path in _arc.get_children():
		var card_ui = follow_path.get_child(0) as CardUI
		card_ui.draggable = false


func reset():
	_cards = []
	Util.delete_children(_arc)


func add_cards_to_ui(cards: Array[Card]):
	for card in cards:
		await add_card_to_ui(card)


func add_card_to_ui(card: Card):
	_cards.append(card)
	var card_ui := _create_card_ui(card)
	await _add_to_arc(card_ui, _cards.size() - 1)
	if sound_active:
		SoundFx.card_out02_hand()


func remove_card(idx: int) -> void:
	Util.delete_child(_arc, idx)
	_cards.remove_at(idx)
	await _update_ratio()


func _create_card_ui(card: Card) -> Node:
	var card_ui = CARD_UI_SCENE
	card_ui = card_ui.instantiate()
	card_ui.draggable = draggable
	card_ui.mouse_animation = mouse_animation
	card_ui.size = Vector2(105, 105 * CardUI.ASPECT)
	card_ui.card = card
	return card_ui


func _add_to_arc(card_ui: Node, index: int) -> void:
	# creates the path follow
	var path_follow := PathFollow2D.new()
	path_follow.name = "Follow%s" % str(index)
	# adds the card to the path follow
	path_follow.add_child(card_ui)
	card_ui.position = -0.5 * card_ui.size
	# adds node to the tree
	_arc.add_child(path_follow)
	# sets path_follow props
	path_follow.loop = false
	path_follow.progress_ratio = _index_to_ratio(index)
	# update all cards positions
	await _update_ratio()


func _index_to_ratio(index: int) -> float:
	var initial_separation = 0.5 - (_cards.size() - 1) * separation / 2
	return initial_separation + index * separation


func _update_ratio() -> void:
	_update_tweener()

	for i in range(0, _cards.size()):
		var path_follow = _arc.get_child(i) as PathFollow2D
		var new_ratio = _index_to_ratio(i)
		_tweener.tween_property(path_follow, "progress_ratio", new_ratio, 0.1)
		_tweener.parallel()
	
	if _tweener.is_running():
		await _tweener.finished


func _update_tweener():
	if _tweener != null and _tweener.is_running():
		_tweener.kill()
	_tweener = create_tween()
