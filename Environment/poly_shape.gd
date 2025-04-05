extends Polygon2D
class_name _PolyShape

func _ready() -> void:
	(get_node("StaticBody2D/CollisionPolygon2D") as CollisionPolygon2D).polygon = polygon.duplicate()

func _process(_delta: float) -> void:
	pass
