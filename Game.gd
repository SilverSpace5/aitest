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
var move = false

func spawn(pos=Vector2(0, 0), net=[]):
	if entities < maxEntities:
		var entity = load("res://Entity.tscn").instance()
		$Entities.add_child(entity)
		entity.position = pos
		if net != []:
			entity.braincopy = net

func _process(delta):
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
		$Camera2D.zoom = Vector2(0.5, 0.5)
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
		var zoomAmount = (xRange[1]-xRange[0])/1024+(yRange[1]-yRange[0])/512
		$Camera2D.zoom.x += (zoomAmount*2-$Camera2D.zoom.x)/10
		$Camera2D.zoom.y += (zoomAmount*2-$Camera2D.zoom.y)/10
		var posX = 0
		var posY = 0
		for value in posXs:
			posX += value
		for value in posYs:
			posY += value
		posX /= len(posXs)
		posY /= len(posYs)
		$Camera2D.position = Vector2(posX, posY)
	else:
		if Input.is_action_pressed("zoomIn"):
			zoom -= 0.015*zoom
		if Input.is_action_pressed("zoomOut"):
			zoom += 0.015*zoom
		zoom = clamp(zoom, 1, 1.3)
		move = false
		$Camera2D.zoom = Vector2(zoom, zoom)
		if Input.is_action_pressed("right"):
			zoom += 0.015*zoom
			move = true
			$Camera2D.position.x += cameraSpeed
		if Input.is_action_pressed("left"):
			zoom += 0.015*zoom
			move = true
			$Camera2D.position.x -= cameraSpeed
		if Input.is_action_pressed("up"):
			zoom += 0.015*zoom
			move = true
			$Camera2D.position.y -= cameraSpeed
		if Input.is_action_pressed("down"):
			zoom += 0.015*zoom
			move = true
			$Camera2D.position.y += cameraSpeed
			
		if move == false:
			zoom -= 0.015*zoom
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
