extends KinematicBody
var gravity = Vector3(0,-9.5,0)
var velocity = Vector3()
var movement = Vector3()
var direction = Vector3()
var forward_speed = 15
var rlb_speed = 5
var accel = 2
var deaccel = 5

onready var mc = $Move_control
onready var rc = $Rotate_control
onready var bj = $Button_jump
onready var bs = $Button_sit
var is_sit:bool = false
var jump:bool = false
func _ready():
	pass

func _physics_process(delta):
	move_and_rotate(delta)
	pass


func move_and_rotate(delta):
	direction = Vector3.ZERO
	var speed = 0
	var acceleration = deaccel
	if rc.used:
		$Head.transform.basis = Basis(Vector3.RIGHT,clamp($Head.rotation.x - rc.vec.y*delta*rc.strength,-1.4,1.4))
		transform.basis = Basis(Vector3.UP,rotation.y + rc.vec.x*delta*rc.strength)
	if  abs(mc.vec.y)>0.6 and mc.strength > 0.1 and is_on_floor():
		acceleration = accel
		direction.z += sign(mc.vec.y)
		if mc.vec.y > 0: speed = forward_speed*mc.strength
		else: speed = rlb_speed*mc.strength
	elif  abs(mc.vec.x) > 0.6 and mc.strength > 0.1 and is_on_floor():
		acceleration = accel
		direction.x += sign(mc.vec.x)
		speed = rlb_speed*mc.strength
	direction =  direction.normalized()
	direction = direction.rotated(Vector3.UP,rotation.y)
	velocity = velocity.linear_interpolate(direction*speed, delta*acceleration)
	movement.x = velocity.x
	movement.z = velocity.z
	if !is_on_floor(): movement.y += -9.5*delta
	if bj.pressed and is_on_floor() and !is_sit:
		movement.y += 300*delta
	movement = move_and_slide(movement, Vector3.UP, 0.05, 4, deg2rad(40))
	print(movement)
	if !bs.pressed and is_sit:
		is_sit = false
		$AnimationPlayer.play_backwards("sit")
	if bs.pressed and !is_sit:
		is_sit = true
		$AnimationPlayer.play("sit")



