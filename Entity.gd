extends KinematicBody2D
#HI
var brain = AiNet.AINet.new(18, 3, 3, 5)
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
var raycasts = []
var raycastShows = []
var showTimer = 0
var selected = false
var best = false
onready var game = get_parent().get_parent()

func _ready():
	energy = maxEnergy
	game.entities += 1
	for child in $raycasts.get_children():
		raycasts.append(child)
	for child in $raycastShows.get_children():
		raycastShows.append(child)

func _process(delta):
	showTimer += delta
	if selected and showTimer > 0.1:
		showTimer = 0
		brain.visual(game.get_node("Camera2D/scale/visual"))
	if selected and (Input.is_action_just_pressed("auto") or Input.is_action_just_pressed("click")):
		selected = false
		for child in game.get_node("Camera2D/scale/visual").get_children():
			child.queue_free()
	if ($foodDetect.overlaps_area(game.get_node("Mouse")) and Input.is_action_just_pressed("click")) or best:
		if not selected:
			for child in get_parent().get_children():
				child.selected = false
			selected = true
	if selected:
		$Sprite.scale = Vector2(7, 7)
	else:
		$Sprite.scale = Vector2(6, 6)
#	Area2D
#	if $foodDetect.

	time += delta
#	print(brain.nodes[0])
#	print(brain.nodes[1])
#	print(brain.nodes[2])
#	print(brain.nodes[3])
	if braincopy != []:
		brain.copy(braincopy)
		brain.change(5, 100, 3, 50, 1, 25)
		braincopy = []
	
	energy = clamp(energy, 0, maxEnergy*5)
	$Node2D/Label.text = str(round(energy/maxEnergy*100)) + "%"
	
	# raycast distance
	var rd = [500, 500, 500, 500, 500, 500, 500, 500]
	var colliders = [0, 0, 0, 0, 0, 0, 0, 0]
	
	for i in range(len(raycasts)):
		var raycast = raycasts[i]
		if raycast.is_colliding():
			rd[i] = position.distance_to(raycast.get_collision_point())*2
	
	$raycastShows.visible = game.showRaycasts
	if game.showRaycasts:
		for i in range(len(raycastShows)):
			var raycast = raycastShows[i]
			raycast.scale.x = rd[i]
	
	for i in range(len(raycasts)):
		var raycast = raycasts[i]
		if raycast.is_colliding() and raycast.get_collider():
			if "banana" in raycast.get_collider().name:
				colliders[i] = 1/5
			if "Entity" in raycast.get_collider().name:
				colliders[i] = 2/5
			if "StaticBody2D" in raycast.get_collider().name:
				colliders[i] = 3/5
			if "coconut" in raycast.get_collider().name:
				colliders[i] = 4/5
			if  "Objects" in raycast.get_collider().name:
				colliders[i] = 5/5
	
	brain.setInput([rd[0]/500, colliders[0], rd[1]/500, colliders[1], rd[2]/500, colliders[2], rd[3]/500, colliders[3], rd[4]/500, colliders[4], rd[5]/500, colliders[5], rd[6]/500, colliders[6], rd[7]/500, colliders[7], energy/maxEnergy, 1])
	brain.update()
	var output = brain.output()
	if output[0] > 0.5:
		vel += speed
	if output[1] > 0.5:
		rotation_degrees += rotateSpeed
	if output[2] > 0.5:
		rotation_degrees -= rotateSpeed
	
	if (energy <= 0 and game.entities > game.maxEntities/20) or dying > 0:
		dying += delta
		$AnimationPlayer.play("despawn")
		if dying >= 0.5:
			game.entities -= 1
			if time > game.longestTime and time >= 10:
				game.longestTime = time
				game.lastNet = brain.nodes
			queue_free()
			if selected:
				selected = false
				for child in game.get_node("Camera2D/scale/visual").get_children():
					child.queue_free()
	if energy <= 0 and game.entities <= game.maxEntities/20:
		energy = maxEnergy
		dying = 0
		$AnimationPlayer.stop()
		$Sprite.scale = Vector2(0, 0)
		$Sprite.rotation_degrees = 0
		position = Vector2(rand_range(-1500, 1500), rand_range(-1500, 1500))
		game.spawn(Vector2(rand_range(-1500, 1500), rand_range(-1500, 1500)), brain.nodes)
		brain.change(5, 100, 3, 100, 1, 100)
	
	vel *= 0.9
	$Node2D/Label.visible = energy >= 0
	$Node2D.rotation_degrees = -rotation_degrees
	if dying <= 0:
		var oldPos = position
		move_and_slide(Vector2(vel, 0).rotated(rotation))
		move = position-oldPos
		energy -= 0.25+move.length()/10
	

func _on_foodDetect_area_entered(area):
	if area.name == "banana":
		energy += maxEnergy/4
		area.get_parent().queue_free()
		game.food -= 1
		game.spawn(position-move*3, brain.nodes)
	if area.name == "coconut":
		energy += maxEnergy
		area.get_parent().queue_free()
		game.food -= 1
		game.spawn(position-move*3, brain.nodes)
