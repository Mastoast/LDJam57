extends Trails

func _get_position():
	print(get_parent().position)
	return get_parent().position
