extends KinematicBody2D

var brain = AiNet.AINet.new(4, 3, 3, 3)
export (float) var speed = 50
export (float) var rotateSpeed = 3
var vel = 0


func _ready():
	get_parent().get_parent().entities += 1

func _process(delta):
	
	var du = $up.get_collision_point().y-position.y
	var dd = $down.get_collision_point().y-position.y
	var dl = $left.get_collision_point().x-position.x
	var dr = $right.get_collision_point().x-position.x
	
	brain.setInput([du, dd, dl, dr])
	brain.update()
	var output = brain.output()
	if output[0] > 0.5:
		vel += speed
	if output[1] > 0.5:
		rotation_degrees += rotateSpeed
	if output[2] > 0.5:
		rotation_degrees -= rotateSpeed
	
	vel *= 0.9
	move_and_slide(Vector2(speed, 0).rotated(rotation))
	
	
	
