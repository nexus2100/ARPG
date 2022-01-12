extends KinematicBody
var GRAVITY = Vector3(0,-9.5,0)
var gravity = GRAVITY
var velocity = Vector3()
var movement = Vector3()
var direction = Vector3()
export(int,1,100) var walk_speed:int = 8
export(int,1,100) var ACCELERATION:int = 10
var air_acceleration = ACCELERATION/2
var acceleration = ACCELERATION
export(float, 0.1,2) var neck_speed:float = 1.2

onready var mc = $Move_control
onready var rc = $Rotate_control
onready var bj = $Button_jump
onready var bs = $Button_sit
onready var sr:RayCast = $Head/Sign_ray
onready var inf:Label = $Info
var is_sit:bool = false
var jump:bool = false
var grounded:bool = false
func _ready():
	pass

func _physics_process(delta):
	if rc.used: 
		look_about(delta)
	if mc.used:
		motion(delta)
	what_sign(delta)
	pass

func look_about(delta):
	$Head.transform.basis = Basis(Vector3.RIGHT,clamp($Head.rotation.x - rc.vec.y*delta*neck_speed*rc.strength,-1.4,1.4))
	transform.basis = Basis(Vector3.UP,rotation.y + rc.vec.x*delta*neck_speed*rc.strength)
	pass

func motion(delta):
	direction = Vector3.ZERO
	
	if  abs(mc.vec.y)>0.7 and mc.strength > 0.1:
		direction.z += sign(mc.vec.y)
	elif  abs(mc.vec.x) > 0.7 and mc.strength > 0.1:
		direction.x += sign(mc.vec.x)
	direction = direction.rotated(Vector3.UP,rotation.y)

	if is_on_floor():
		acceleration = ACCELERATION
		movement.y = 0
		gravity  = -get_floor_normal()*10
		grounded = true
	else:
		acceleration =  air_acceleration
		if grounded:
			gravity = Vector3()
			grounded = false
		else:
			gravity += delta * GRAVITY
	
	if is_on_ceiling() and gravity.y >= 0:
		gravity.y = 0
	
	if bj.pressed and is_on_floor() and !is_sit:
		grounded = false
		gravity = Vector3.UP * 5
	if !bs.pressed and is_sit:
		is_sit = false
		$AnimationPlayer.play_backwards("sit")
	if bs.pressed and !is_sit:
		is_sit = true
		$AnimationPlayer.play("sit")
	velocity = velocity.linear_interpolate(direction * walk_speed*mc.strength, acceleration * delta)
	movement.x = velocity.x + gravity.x
	movement.z = velocity.z + gravity.z
	movement.y = gravity.y
	movement = move_and_slide(movement, Vector3.UP, false, 4, 0.785398, false)


func what_sign(delta):
	if sr.is_colliding():
		inf.text = sr.get_collider().title
	else:
		inf.text = ""
	pass

