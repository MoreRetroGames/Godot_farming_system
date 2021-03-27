extends KinematicBody

export (int) var speed = 500
var direction = Vector3()
var gravity = -9.8
var velocity = Vector3()

func _ready():
	
	print("Player active")

func _physics_process(delta):
	
	direction = Vector3(0,0,0)
		
	#Inputs
	if Input.is_action_pressed("ui_up"):
		direction.z -= 1
	if Input.is_action_pressed("ui_down"):
		direction.z += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	
	#Move
	direction = direction.normalized()
	direction = direction * speed * delta
	
	velocity.y += gravity * delta
	velocity.x = direction.x
	velocity.z = direction.z
	
	velocity = move_and_slide(velocity,Vector3(0,1,0))
	
	Globals.vehiclePosition = translation