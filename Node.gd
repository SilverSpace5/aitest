extends Node2D

func connect2(position2):
	var mesh = load("res://MeshInstance2D.tscn").instance()
	add_child(mesh)
	mesh.look_at(position2)
	mesh.scale.x = position.distance_to(position2)
	mesh.scale.y = 5
