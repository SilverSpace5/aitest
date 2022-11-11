extends Node

func _ready():
	randomize()
	var test = AiNet.Network.new(3, 3, 3, 3, 3, 0)
	print(test.output([1, 2, 3]))
