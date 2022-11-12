extends KinematicBody2D
#HI
var brain = AiNet.AINet.new(10, 3, 3, 5)
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
var dying = 0

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
	
	var du = 500 # Up Distance
	var dd = 500 # Down Distance
	var dl = 500 # Left Distance
	var dr = 500 # Right Distance
	
	if $up.is_colliding():
		du = position.distance_to($up.get_collision_point())*2
	if $down.is_colliding():
		dd = position.distance_to($down.get_collision_point())*2
	if $left.is_colliding():
		dl = position.distance_to($left.get_collision_point())*2
	if $right.is_colliding():
		dr = position.distance_to($right.get_collision_point())*2
	
	$rightShow.visible = $right.is_colliding()
	$rightShow.position.x = dr
	$leftShow.visible = $left.is_colliding()
	$leftShow.position.x = -dl
	$upShow.visible = $up.is_colliding()
	$upShow.position.y = -du
	$downShow.visible = $down.is_colliding()
	$downShow.position.y = dd
	
	var colliders = [0, 0, 0, 0]
	
	var raycasts = [$right, $left, $up, $down]
	
	for i in range(len(raycasts)-1):
		var raycast = raycasts[i]
		if raycast.is_colliding() and raycast.get_collider():
			if "banana" in raycast.get_collider().name:
				colliders[i] = 1
			if "Entity" in raycast.get_collider().name:
				colliders[i] = 2
			if "StaticBody2D" in raycast.get_collider().name:
				colliders[i] = 3
			if "coconut" in raycast.get_collider().name:
				colliders[i] = 4
	
	brain.setInput([du/500, colliders[0], dd/500, colliders[1], dl/500, colliders[2], dr/500, colliders[3], energy, 1])
	brain.update()
	var output = brain.output()
	if output[0] > 0.5:
		vel += speed
	if output[1] > 0.5:
		rotation_degrees += rotateSpeed
	if output[2] > 0.5:
		rotation_degrees -= rotateSpeed
	
	if energy <= 0 or dying > 0:
		dying += delta
		$AnimationPlayer.play("despawn")
		if dying >= 0.5:
			get_parent().get_parent().entities -= 1
			if time > get_parent().get_parent().longestTime and time >= 10:
				get_parent().get_parent().longestTime = time
				get_parent().get_parent().lastNet = brain.nodes
			queue_free()
	
	vel *= 0.9
	if dying <= 0:
		var oldPos = position
		move_and_slide(Vector2(vel, 0).rotated(rotation))
		move = position-oldPos
	else:
		$Label.text = ""
	

func _on_foodDetect_area_entered(area):
	if area.name == "banana":
		energy += 37.5
		area.get_parent().queue_free()
		get_parent().get_parent().food -= 1
		get_parent().get_parent().spawn(position-move*3, brain.nodes)
	if area.name == "coconut":
		energy = maxEnergy
		area.get_parent().queue_free()
		get_parent().get_parent().food -= 1
		get_parent().get_parent().spawn(position-move*3, brain.nodes)
