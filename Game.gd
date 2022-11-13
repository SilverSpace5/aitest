extends Node2D

var entities = 0
var food = 0
export (int) var cameraSpeed = 50
export (int) var startEntities = 5
export (int) var maxEntities = 10
export (int) var maxFood = 25
var timer = 0
var foodTimer = 0
var cocunutTimer = 0
var lastNet = []
var longestTime = 0
var auto = true
var showRaycasts = false
var zoom = 1
var zoom2 = 0.5
var move = false
var showTimer = 0
var zoomAmount = 1
var targetPos = Vector2(512, 300)

func spawn(pos=Vector2(0, 0), net=[]):
	if entities < maxEntities:
		var entity = load("res://Entity.tscn").instance()
		$Entities.add_child(entity)
		entity.position = pos
		if net != []:
			entity.braincopy = net

func _process(delta):
	$Mouse.position = get_global_mouse_position()
#	showTimer += delta
#	if showTimer >= 0.1 and entities > 0:
#		showTimer = 0
#		var closesDis = 0
#		var closestEntity = Node2D
#		for entity in $Entities.get_children():
#			if closesDis == 0 or entity.position.distance_to($Camera2D.position) < closesDis:
#				closesDis = entity.position.distance_to($Camera2D.position)
#				closestEntity = entity
#		closestEntity.brain.visual($Camera2D/scale/visual)
	foodTimer += delta
	cocunutTimer += delta
	if foodTimer > 0:
		foodTimer = 0
		if food < maxFood:
			food += 1
			var food = load("res://food.tscn").instance()
			$food.add_child(food)
			food.position = Vector2(rand_range(-1500, 1500), rand_range(-1500, 1500))
	if cocunutTimer > 0.05:
		cocunutTimer = 0
		if food < maxFood:
			food += 1
			var food = load("res://food1.tscn").instance()
			$food.add_child(food)
			food.position = Vector2(rand_range(-1500, 1500), rand_range(-1500, 1500))
	
	if entities > 0 and auto:
		zoomAmount = 0.5
		var posXs = []
		var posYs = []
		var xRange = [0, 0]
		var yRange = [0, 0]
		for node in $Entities.get_children():
			posXs.append(node.position.x)
			posYs.append(node.position.y)
			if $Camera2D.position.x-node.position.x < xRange[0]:
				xRange[0] = $Camera2D.position.x-node.position.x
			if $Camera2D.position.x-node.position.x > xRange[1]:
				xRange[1] = $Camera2D.position.x-node.position.x
			if $Camera2D.position.y-node.position.y < yRange[0]:
				yRange[0] = $Camera2D.position.y-node.position.y
			if $Camera2D.position.y-node.position.y > yRange[1]:
				yRange[1] = $Camera2D.position.y-node.position.y
		zoomAmount = ((xRange[1]-xRange[0])/1024+(yRange[1]-yRange[0])/512)/4
		var posX = 0
		var posY = 0
		for value in posXs:
			posX += value
		for value in posYs:
			posY += value
		posX /= len(posXs)
		posY /= len(posYs)
		targetPos = Vector2(posX, posY)
	else:
		if Input.is_action_pressed("zoomIn"):
			zoom2 -= 0.015*zoom2
		if Input.is_action_pressed("zoomOut"):
			zoom2 += 0.015*zoom2
		zoom2 = clamp(zoom2, 0.2, 1)
		zoom = clamp(zoom, 0.2, 1)
		move = false
		zoomAmount = zoom
		if Input.is_action_pressed("right"):
			move = true
			targetPos.x += cameraSpeed
		if Input.is_action_pressed("left"):
			move = true
			targetPos.x -= cameraSpeed
		if Input.is_action_pressed("up"):
			move = true
			targetPos.y -= cameraSpeed
		if Input.is_action_pressed("down"):
			move = true
			targetPos.y += cameraSpeed
			
		if move:
			zoom = zoom2
		else:
			zoom = zoom2+0.05

	var selected = null
	for node in $Entities.get_children():
		if node.selected:
			selected = node

	if selected:
		targetPos = selected.position
		zoomAmount = 0.2
	
	$Camera2D.position += (targetPos-$Camera2D.position)/10
	$Camera2D.zoom.x += (zoomAmount*2-$Camera2D.zoom.x)/10
	$Camera2D.zoom.y += (zoomAmount*2-$Camera2D.zoom.y)/10
	$Camera2D/scale.scale = $Camera2D.zoom
	
	if Input.is_action_just_pressed("auto"):
		auto = not auto
	if Input.is_action_just_pressed("raycasts"):
		showRaycasts = not showRaycasts
	
#	timer += delta
#	if timer > 0.5:
#		timer = 0
#		randomize()
#		spawn(Vector2(rand_range(50, 950), rand_range(50, 550)))
	
	if entities < 1:
		food = 0
		for child in $food.get_children():
			child.queue_free()
		for i in range(startEntities):
			randomize()
			spawn(Vector2(rand_range(50, 950), rand_range(50, 550)), lastNet)

func _ready():
	for i in range(startEntities):
		randomize()
		spawn(Vector2(rand_range(50, 950), rand_range(50, 550)), lastNet)
