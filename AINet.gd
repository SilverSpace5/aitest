extends Node

#COPY NEURAL NETWORKS

class AINet:
	var nodes = []
	var inputs = 0
	var outputs = 0
	var maxConnections = 0
	var maxNodes = 0
	func _init(inputs, outputs, maxNodes, maxConnections):
		self.inputs = inputs
		self.outputs = outputs
		self.maxNodes = maxNodes 
		self.maxConnections = maxConnections
		for i in range(round(rand_range(1, maxNodes))+inputs+outputs):
			nodes.append([0, []])
		for node in nodes:
			var connected = []
			for i in range(round(rand_range(0, maxConnections))):
				var i2 = round(rand_range(0, len(nodes)-1))
				if not i2 in connected and i2 != nodes.find(node):
					connected.append(i2)
					node[1].append([i2, rand_range(-2, 2)])
	
	func update():
		for node in nodes:
			var sum = 0
			for connection in node[1]:
				if connection[0]-1 < 0 or connection[0]-1 >= len(nodes):
					node[1].remove(node[1].find(connection))
				else:
					sum += nodes[connection[0]-1][0] * connection[1]
			node[0] = tanh(sum)
	
	func setInput(inputs):
		for i in range(len(inputs)):
			nodes[i][0] = Global.sigmoid(inputs[i])
	
	func output():
		var output2 = []
		for i in range(outputs):
			output2.append(nodes[len(nodes)-1-i][0])
		return output2
	
	func copy(nodes):
		self.nodes = nodes.duplicate(true)
	
	func change(maxEdits, editChance, maxConnections, connectionsChance, maxNodes, nodeChance):
		for i in range(round(rand_range(0, maxEdits))):
			if rand_range(0, 100) < editChance:
				var node = nodes[round(rand_range(0, len(nodes)-1))]
				if len(node[1]) > 0:
					var weight = node[1][round(rand_range(0, len(node[1])-1))][1]
					weight += rand_range(-2, 2)
					weight = clamp(weight, -4, 4)
		for i in range(round(rand_range(0, maxConnections))):
			if rand_range(0, 100) < connectionsChance:
				var node = nodes[round(rand_range(0, len(nodes)-1))]
				if len(node[1]) > 0 and round(rand_range(0, 1)) == 0:
					node[1].remove(round(rand_range(0, len(node[1])-1)))
				else:
					var i2 = round(rand_range(0, len(node[1])-1))
					node[1].insert(i2, [round(rand_range(0, len(nodes)-1)), rand_range(-2, 2)])
		for i in range(round(rand_range(0, maxNodes))):
			if rand_range(0, 100) < nodeChance:
				if len(nodes) > self.inputs + self.outputs and round(rand_range(0, 1)) == 0:
					var node = nodes[round(rand_range(0, len(nodes)-1))]
					for node2 in nodes:
						var found = false
						for i2 in range(len(node2[1])):
							if not found:
								if node2[1][i2][0] == nodes.find(node):
									found = true
									node2[1].remove(i2)
					nodes.remove(nodes.find(node))
				elif len(nodes) < self.maxNodes:
					var i2 = round(rand_range(0, len(nodes)-1))
					nodes.insert(i2, [0, []])
					var connected = []
					for i3 in range(round(rand_range(0, self.maxConnections))):
						var i4 = round(rand_range(0, len(nodes)-1))
						if not i4 in connected and i4 != nodes.find(nodes[i2]):
							connected.append(i4)
							nodes[i2][1].append([i4, rand_range(-2, 2)])
