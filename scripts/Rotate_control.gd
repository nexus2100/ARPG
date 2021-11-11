extends Control

var vec = Vector2()
var pos = Vector2()
var used:bool = false
var id = -1

func _on_Rotate_control_gui_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			used = true
			pos = event.position
			id = event.index
		else:
			used = false
	if event is InputEventScreenDrag and id == event.index:
		vec = pos - event.position
		print("rotate ", event.index)
	pass # Replace with function body.
