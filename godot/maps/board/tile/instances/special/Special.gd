@tool
extends Tile

var _options := [PrisonerAction]
var _current_option: SpecialAction = null

@onready var _sprite := $Sprite2D
@onready var _ui := $UI

func effect(_board: Board, _player: BoardPlayer):
	await _current_option.effect(_board, _player, _ui)


func _ready():
	super._ready()
	BoardEvent.special_block.connect(_on_round_started)


func _on_round_started(random_number: int):
	_choose_option(random_number)
	_change_sprite()


func _choose_option(random_number):
	var drawn_option := random_number % _options.size() as int
	if _options[drawn_option] == _current_option:
		drawn_option = (drawn_option + 1) % _options.size()
	_current_option = _options[drawn_option].new()


func _change_sprite():
	_sprite.texture = _current_option.sprite
	_sprite.scale = Vector2.ONE * 0.313
