extends Node2D

var i = 0

func connect2(position2:Vector2, weight=0, localPos=Vector2(0, 0), scale2=1):
	var mesh:Node2D = load("res://line.tscn").instance()
	mesh.modulate = Color(0, 0, 0, 0)
	
	if weight > 0:
		mesh.modulate = Color(0, 1, 0, 0.25)
	elif weight < 0:
		mesh.modulate = Color(1, 0, 0, 0.25)
	
	mesh.scale.y = abs(weight)
	add_child(mesh)
	mesh.look_at(position2)
	mesh.z_index
	mesh.scale.x = position.distance_to(localPos)/scale2
