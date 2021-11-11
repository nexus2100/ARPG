extends Control

var id = -1
var vec = Vector2()
var pos = Vector2()
var used:bool = false
var strength:float = 0
export(int,50, 300) var max_drag = 100
func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			if(get_rect().has_point(event.position)):
				id = event.index
				used = true
				pos = event.position
		else:
			if id == event.index:
				used = false
				id = -1
				vec = Vector2.ZERO
				strength = 0
			
	elif event is InputEventScreenDrag:
		if event.index == id:
			vec = (pos - event.position)
			strength = clamp(vec.length(),0,max_drag)/max_drag
			vec = vec.normalized()
	pass

