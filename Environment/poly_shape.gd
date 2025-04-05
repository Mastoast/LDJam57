extends Polygon2D
class_name _PolyShape

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		(get_node("StaticBody2D/CollisionPolygon2D") as CollisionPolygon2D).polygon = polygon.duplicate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
