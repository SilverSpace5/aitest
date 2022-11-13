extends Node

var randomSeed = randi()
var noise
var idsTaken = []

func _ready():
	setupRandom(3161026589)

func getId():
	var i = 0
	while i in idsTaken:
		i += 1
	idsTaken.append(i)
	return i

func searchNodes(nodes, id):
	for node in nodes:
		if node.id == id:
			return node

func removeId(id):
	idsTaken.remove(id)

func sigmoid(x):
		if x >= 0:
			var z = exp(-x)
			var sig = 1 / (1 + z)
			return sig
		else:
			var z = exp(x)
			var sig = z / (1 + z)
			return sig

func chance(amount):
	return rand_range(0.1, 100) < amount

func fillIn(word, filler, length):
	var newWord = str(word)
	while len(newWord) < length:
		newWord = str(filler) + newWord
	return newWord

func setupRandom(seed2):
	if seed2:
		randomSeed = seed2
	noise = OpenSimplexNoise.new()
	noise.seed = randomSeed
	noise.octaves = 4
	noise.period = 100
	noise.persistence = 0.5

func getRandom(min2, max2, val):
	return clamp(abs(noise.get_noise_1d(val*142))*2.85, 0, 1) * (max2 - min2) + min2
