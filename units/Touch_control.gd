extends Control
var start:Vector2 = Vector2.ZERO
var vector:Vector2 = Vector2.ZERO
var used:bool = false
export(int,10,300) var max_drag:int = 100
var strength:float = 0

func _on_Touch_control_gui_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			used = true
			start = event.position
		else:
			used = false 
			start = Vector2.ZERO
			vector = Vector2.ZERO
			strength = 0
	elif event is InputEventScreenDrag:
		vector = (start - event.position).normalized()
		strength = clamp(start.distance_to(event.position),0,max_drag)/max_drag
	pass # Replace with function body.
