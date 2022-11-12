extends Sprite

var timer = 0

func _process(delta):
	timer += delta
#	if timer > 7:
#		queue_free()
#		get_parent().food -= 1
