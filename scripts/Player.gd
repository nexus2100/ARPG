extends KinematicBody
var gravity = Vector3(0,-9.5,0)
var velocity = Vector3.ZERO
var speed = 20
var accel = 4
var deaccel = 15
onready var mc = $Move_control
onready var rc = $Rotate_control

func _ready():
	pass

func _physics_process(delta):
	velocity += gravity * delta
	if rc.used:
		transform.basis = Basis(Vector3.UP,rotation.y + rc.vector.x*delta*rc.strength)
		$Head.transform.basis = Basis(Vector3.RIGHT,clamp($Head.rotation.x - rc.vector.y*delta*rc.strength,-1.4,1.4))
		print(" rotate ", rc.vector," ", rc.strength)
	velocity = move_and_slide(velocity, Vector3.UP)
	pass

