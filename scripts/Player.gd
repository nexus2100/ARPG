extends KinematicBody
var gravity = Vector3(0,-9.5,0)
var velocity = Vector3()
var movement = Vector3()
var direction = Vector3()
var forward_speed = 3
var rlb_speed = 4
var accel = 6
var deaccel = 15

onready var mc = $Move_control
onready var rc = $Rotate_control
onready var bj = $Button_jump
onready var bs = $Button_sit
var is_sit:bool = false
var jump:bool = false
func _ready():
	pass

func _physics_process(delta):
	direction = Vector3.ZERO
	
	if rc.used:
		$Head.transform.basis = Basis(Vector3.RIGHT,clamp($Head.rotation.x - rc.vec.y*delta*rc.strength,-1.4,1.4))
		transform.basis = Basis(Vector3.UP,rotation.y + rc.vec.x*delta*rc.strength)
	if  abs(mc.vec.y)>0.6 and mc.strength > 0.4:
		direction.z += sign(mc.vec.y)
	elif  abs(mc.vec.x) > 0.6 and mc.strength > 0.3:
		direction.x += sign(mc.vec.x)
	direction =  direction.normalized()
	direction = direction.rotated(Vector3.UP,rotation.y)
	velocity = velocity.linear_interpolate(direction*forward_speed, delta*accel)
	movement.x = velocity.x*forward_speed
	movement.z = velocity.z*forward_speed
	movement += gravity*delta
	if bj.pressed and is_on_floor() and !is_sit:
		movement.y += 300*delta
	movement = move_and_slide(movement, Vector3.UP)
	if !bs.pressed and is_sit:
		is_sit = false
		$AnimationPlayer.play_backwards("sit")
	if bs.pressed and !is_sit:
		is_sit = true
		$AnimationPlayer.play("sit")
	pass






