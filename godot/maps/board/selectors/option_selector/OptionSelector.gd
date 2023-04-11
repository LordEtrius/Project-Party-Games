class_name OptionSelector
extends CanvasLayer

signal selected(idx: int)

var title := "Select an option"
var options := [] : set = set_options

@onready var _title = $PanelContainer/VBoxContainer/Label as Label
@onready var _buttons_container = $PanelContainer/VBoxContainer/VBoxContainer as VBoxContainer


func set_options(new_options: Array) -> void:
	options = new_options
	if options and _buttons_container:
		Util.delete_children(_buttons_container)
		var idx := 0
		for option in options:
			var button = Button.new()
			button.text = option.text
			button.pressed.connect(_on_option_selected.bind(idx))
			_buttons_container.add_child(button)
			idx += 1


func _ready() -> void:
	set_options(options)
	_title.text = title


func _on_option_selected(idx: int) -> void:
	selected.emit(idx)
