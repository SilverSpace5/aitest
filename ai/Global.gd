extends Node

var idsTaken = []

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
