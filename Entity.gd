extends KinematicBody2D
#HI
var brain = AiNet.AINet.new(6, 3, 1, 5)
var braincopy = []
export (float) var speed = 50
export (float) var rotateSpeed = 3
export (float) var maxEnergy = 250
var energy = maxEnergy
var vel = 0
var time = 0
var move = Vector2(0, 0)
var longestTime = 0
var see = 0

func _ready():
	get_parent().get_parent().entities += 1

func _process(delta):
	
	print(brain.nodes)
	time += delta
#	print(brain.nodes[0])
#	print(brain.nodes[1])
#	print(brain.nodes[2])
#	print(brain.nodes[3])
	if braincopy != []:
		brain.copy(braincopy)
		brain.change(5, 100, 3, 100, 1, 100)
		braincopy = []
	
	energy -= 1
	$Label.text = str(round(energy/maxEnergy*100)) + "%"
	
	var du = 500
	var dd = 500
	var dl = 500
	var dr = 500
	
	if $up.is_colliding():
		du = position.distance_to($up.get_collision_point())*2
	if $down.is_colliding():
		dd = position.distance_to($down.get_collision_point())*2
	if $left.is_colliding():
		dl = position.distance_to($left.get_collision_point())*2
	if $right.is_colliding():
		dr = position.distance_to($right.get_collision_point())*2
	
	brain.setInput([du, dd, dl, dr, energy, 1])
	brain.update()
	var output = brain.output()
	if output[0] > 0.5:
		vel += speed
	if output[1] > 0.5:
		rotation_degrees += rotateSpeed
	if output[2] > 0.5:
		rotation_degrees -= rotateSpeed
	
	if energy <= 0:
		get_parent().get_parent().entities -= 1
		if time > get_parent().get_parent().longestTime:
			get_parent().get_parent().longestTime = time
			get_parent().get_parent().lastNet = brain.nodes
		queue_free()
	
	vel *= 0.9
	var oldPos = position
	move_and_slide(Vector2(vel, 0).rotated(rotation))
	move = position-oldPos
	

func _on_foodDetect_area_entered(area):
	if area.name == "food":
		energy += 37.5
		area.get_parent().queue_free()
		get_parent().get_parent().food -= 1
		get_parent().get_parent().spawn(position-move*3, brain.nodes)

func _on_eyes_area_entered(area):
	if area.name == "food":
		see = 1
#		print("",see)

func _on_eyes_area_exited(area):
	see = 0

