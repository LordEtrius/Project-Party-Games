@tool
extends Tile

const SELECTOR = preload("res://maps/board/selectors/option_selector/OptionSelector.tscn")
const MAX_OPTIONS = 2

var _owner_player: BoardPlayer = null : set = set_player_ownership
var _ownership_options = [
	{
		"text": "Take 25% of next player's hp",
		"action": 
			func (next_player):
				var old_next_player_hp = next_player.hp
				next_player.suffer_damage(ceili(next_player.hp * 0.25), _owner_player)
				_owner_player.hp += old_next_player_hp - next_player.hp,
	},
	{
		"text": "Take 25% of next player's jello coins",
		"action": 
			func (next_player): 
				var old_next_player_hp = next_player.score.sub_points
				next_player.score.sub_points -= ceili(next_player.score.sub_points * 0.25)
				_owner_player.hp += old_next_player_hp - next_player.score.sub_points,
	},
]
var _choosed_option = null

@onready var _owner_player_label = $Label as Label

func set_player_ownership(player: BoardPlayer) -> void:
	_owner_player = player
	if _owner_player and _owner_player_label:
		_owner_player_label.text = _owner_player.nick
	else:
		_owner_player_label.text = ""


func effect(_board: Board, player: BoardPlayer) -> void:
	# If the tile is owned by another player, the player who landed on it suffers the effect
	if _owner_player and _owner_player != player:
		_choosed_option.action.call(player)
		TileEvent.emit_signal(
			"record", "Ownership tile: %s suffered %s effect" % [player.nick, _owner_player.nick]
		)
		await player.animate_rotation()
	
	# Get the ownership random options
	_ownership_options.shuffle()
	var _drawn_options = _ownership_options.slice(0, MAX_OPTIONS)
	
	# Create the selector and wait for the player to choose an option
	var selector = SELECTOR.instantiate() as OptionSelector
	selector.options = _drawn_options
	var idx := await player.select(selector) as int
	
	# Store the choosed option and set the ownership
	_choosed_option = _drawn_options[idx]
	_owner_player = player
	await player.animate_scale()


func _ready() -> void:
	super._ready()
	set_player_ownership(_owner_player)
