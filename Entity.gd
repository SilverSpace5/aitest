extends KinematicBody2D
#HI
var brain = AiNet.AINet.new(2, 3, 1, 5)
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
	
	var du = $up.get_collision_point().y-position.y
	var dd = $down.get_collision_point().y-position.y
	var dl = $left.get_collision_point().x-position.x
	var dr = $right.get_collision_point().x-position.x
	
	brain.setInput([see, 1])
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
		energy = maxEnergy
		area.get_parent().queue_free()
		get_parent().get_parent().food -= 1
		get_parent().get_parent().spawn(position-move*3, brain.nodes)


func _on_eyes_area_entered(area):
	if area.name == "food":
		see = 1
#		print("",see)

func _on_eyes_area_exited(area):
	see = 0

