extends TextureRect
var id:int = -1;
export(bool) var pressed:bool = false;
export(bool) var toogle_mode:bool = false;
export(Texture) var pressed_texture:Texture = texture;
var normal_texture:Texture = texture;

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			if get_rect().has_point(event.position):
				if index_is_free(event.index):
					id = event.index
					Touch.list_id.append(id)
					pressed = !pressed
		else: 
			if (id == event.index):
				Touch.list_id.remove(Touch.list_id.find(id))
				if (!toogle_mode):
					pressed = !pressed
	elif event is InputEventScreenDrag:
		if !get_rect().has_point(event.position) and id == event.index and !toogle_mode:
			pressed = false
			id = -1


func index_is_free(index:int)->bool:
	var result = true
	if (Touch.list_id.find(index) > -1):
		result = false
	return result
