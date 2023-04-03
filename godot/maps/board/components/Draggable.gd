class_name DraggableComponent
extends Control

@export var drag_active := false : set = set_drag_active
@export var node_path: NodePath = ""
## The texture to use as a drag preview
## If null, the node's texture will be used
@export var texture: Texture2D = null
@export var texture_size: Vector2 = Vector2(100, 100)

@onready var node: Node = get_node(node_path)

func set_drag_active(value):
	drag_active = value
	visible = value
	set_process(value)


func _process(_delta):
	self.size = node.size
	self.position = Vector2.ZERO
	if texture == null:
		if "texture" in node:
			texture = node.texture


func _get_drag_data(_at_position) -> Variant:
	if not drag_active:
		return null
	var data = Callable(node, "on_get_drag_data").call()
	set_drag_preview(get_control_preview())
	return data


func get_control_preview() -> Control:
	return Callable(node, "get_control_preview").call()


# static func create_dragged_texture(texture: Texture2D, texture_size: Vector2 = Vector2(100, 100)) -> Control:
#	 var drag_texture = TextureRect.new()
#	 drag_texture.expand = true
#	 drag_texture.texture = texture
#	 drag_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
#	 drag_texture.size = texture_size

#	 var control = Control.new()
#	 control.add_child(drag_texture)
#	 drag_texture.position = -0.5 * drag_texture.size

#	 return control
