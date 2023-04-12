class_name CircleSelector
extends AreaSelelector

@export var radius = 100

func init(_radius := 100):
	radius = _radius
	return self


func _ready():
	var collision_shape = $CollisionShape2D as CollisionShape2D
	var shape = collision_shape.shape as CircleShape2D
	shape.radius = radius
