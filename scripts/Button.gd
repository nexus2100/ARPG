extends TextureRect
var id = -1
var pressed
var rpos:Vector2
func _ready():
	rpos = rect_position
	pass

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			if get_rect().has_point(event.position):
				if index_is_free(event.index):
					id = event.index
					pressed = true
					rect_position.y -=15
					rect_scale.x = 0.8
					rect_scale.y = 0.8
		else:
				pressed = false
				id = -1
				rect_scale.x = 1
				rect_scale.y = 1
				rect_position = rpos
	elif event is InputEventScreenDrag:
		if !get_rect().has_point(event.position) and id == event.index:
			pressed = false
			id = -1
			rect_scale.x = 1
			rect_scale.y = 1
			rect_position = rpos


func index_is_free(index:int)->bool:
	var result = true
	for control in get_tree().get_nodes_in_group("Touch_controls"):
		if control.id == index: 
			result = false
	return result
