@tool
extends Tile

var _options := [
	{
		"sprite": preload("res://assets/tiles/icon_special1.png"),
		"effect": func(_board: Board, player: BoardPlayer): player.score.sub_points += 1,
	},
	{
		"sprite": preload("res://assets/tiles/icon_special2.png"),
		"effect": func(_board: Board, player: BoardPlayer): player.score.sub_points += 2,
	},
	{
		"sprite": preload("res://assets/tiles/icon_special3.png"),
		"effect": func(_board: Board, player: BoardPlayer): player.score.sub_points += 3,
	},
]
var _current_option := 0

@onready var _sprite := $Sprite2D

func effect(_board: Board, _player: BoardPlayer):
	_options[_current_option].effect.call(_board, _player)


func _ready():
	super._ready()
	BoardEvent.special_block.connect(_on_round_started)


func _on_round_started(random_number: int):
	_choose_option(random_number)
	_change_sprite()


func _choose_option(random_number):
	var drawn_option = random_number % _options.size()
	if drawn_option == _current_option:
		drawn_option = (drawn_option + 1) % _options.size()
	_current_option = drawn_option


func _change_sprite():
	_sprite.texture = _options[_current_option].sprite
	_sprite.scale = Vector2.ONE * 0.313
