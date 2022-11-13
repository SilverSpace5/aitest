extends Node2D

var i = 0

func connect2(position2:Vector2):
	var mesh = load("res://line.tscn").instance()
	get_parent().get_node("lines").add_child(mesh)
	mesh.look_at(position2)
	mesh.scale.x = 2
	mesh.modulate = Color(rand_range(0, 1), rand_range(0, 1), rand_range(0, 1))
	mesh.scale.y = position.distance_to(position2)/16
	mesh.z_index = 1
