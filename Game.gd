extends Node2D

var entities = 0
var food = 0
export (int) var maxEntities = 10
export (int) var maxFood = 25
var timer = 0
var foodTimer = 0

func spawn(pos=Vector2(0, 0), net=[]):
	if entities < maxEntities:
		var entity = load("res://Entity.tscn").instance()
		$Entities.add_child(entity)
		entity.position = pos
		if net != []:
			entity.braincopy = net

func _process(delta):
	
	foodTimer += delta
	if foodTimer > 0.1:
		foodTimer = 0
		if food < maxFood:
			food += 1
			var food = load("res://food.tscn").instance()
			add_child(food)
			food.position = Vector2(rand_range(50, 950), rand_range(50, 550))
	
	if entities > 0:
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
		$Camera2D.zoom.x += (zoomAmount+1-$Camera2D.zoom.x)/10
		$Camera2D.zoom.y += (zoomAmount+1-$Camera2D.zoom.y)/10
		var posX = 0
		var posY = 0
		for value in posXs:
			posX += value
		for value in posYs:
			posY += value
		posX /= len(posXs)
		posY /= len(posYs)
		$Camera2D.position = Vector2(posX, posY)
	
#	timer += delta
#	if timer > 0.5:
#		timer = 0
#		randomize()
#		spawn(Vector2(rand_range(50, 950), rand_range(50, 550)))
	
	if entities < 1:
		for i in range(100):
			randomize()
			spawn(Vector2(rand_range(50, 950), rand_range(50, 550)))

func _ready():
	for i in range(1000):
		randomize()
		spawn(Vector2(rand_range(50, 950), rand_range(50, 550)))
