extends TextureRect
var id = -1
var pressed:bool = false
var texture_unpressed
var texture_pressed 
export var path_texture_pressed:String
export var path_texture_unpressed:String
func _ready():
	texture_unpressed = load(path_texture_unpressed)
	texture_pressed = load(path_texture_pressed)

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed and get_rect().has_point(event.position):
			if !pressed:
				id = event.index
				pressed = true
				texture = texture_pressed
			else:
				id = event.index
				pressed = false
				texture = texture_unpressed
		else:
			id = -1


func index_is_free(index:int)->bool:
	var result = true
	for control in get_tree().get_nodes_in_group("Touch_controls"):
		if control.id == index: 
			result = false
	return result
