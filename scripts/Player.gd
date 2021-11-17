extends KinematicBody
var GRAVITY = Vector3(0,-9.5,0)
var gravity = GRAVITY
var velocity = Vector3()
var movement = Vector3()
var direction = Vector3()
var walk_speed = 8
var ACCELERATION = 10
var air_acceleration = ACCELERATION/2
var acceleration = ACCELERATION

onready var mc = $Move_control
onready var rc = $Rotate_control
onready var bj = $Button_jump
onready var bs = $Button_sit
var is_sit:bool = false
var jump:bool = false
var grounded:bool = false
func _ready():
	pass

func _physics_process(delta):
	move_and_rotate(delta)
	pass


func move_and_rotate(delta):
	direction = Vector3.ZERO
	if rc.used:
		$Head.transform.basis = Basis(Vector3.RIGHT,clamp($Head.rotation.x - rc.vec.y*delta*rc.strength,-1.4,1.4))
		transform.basis = Basis(Vector3.UP,rotation.y + rc.vec.x*delta*rc.strength)
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
	print(movement)
	



