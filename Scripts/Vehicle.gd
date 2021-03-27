extends VehicleBody

############################################################
# behaviour values

export var MAX_ENGINE_FORCE = 200.0
export var MAX_BRAKE_FORCE = 5.0
export var MAX_STEER_ANGLE = 0.5

export var steer_speed = 5.0

var steer_target = 0.0
var steer_angle = 0.0

var speed
var reverse = false
export var MAX_SPEED =15

############################################################
# Input

#export var joy_steering = JOY_ANALOG_LX
#export var steering_mult = -1.0
#export var joy_throttle = JOY_ANALOG_R2
#export var throttle_mult = 1.0
#export var joy_brake = JOY_ANALOG_L2
#export var brake_mult = 1.0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _physics_process(delta):
	var steer_val = 0 #steering_mult * Input.get_joy_axis(0, joy_steering)
	var throttle_val = 0 #throttle_mult * Input.get_joy_axis(0, joy_throttle)
	var brake_val = 0 #brake_mult * Input.get_joy_axis(0, joy_brake)
	
	# overrules for keyboard
	if Input.is_action_pressed("ui_up"):
		if speed < 0.1:
			reverse=false
			print("Reverse Off")
		if reverse:
			brake_val = 1.0
		else:
			throttle_val = 1.0
	if Input.is_action_pressed("ui_down"):
		if speed < 0.1:
			reverse=true
			print("Reverse On")
		if reverse:
			throttle_val = -1.0
		else:
			brake_val = 1.0
	if Input.is_action_pressed("ui_left"):
		steer_val = 1.0
	if Input.is_action_pressed("ui_right"):
		steer_val = -1.0
	
	
		
	if Input.is_action_just_pressed("ui_accept"):
		print (linear_velocity)
		print (angular_velocity)
	
	
	
	engine_force = throttle_val * MAX_ENGINE_FORCE
	brake = brake_val * MAX_BRAKE_FORCE
	
	speed = get_linear_velocity().length();
	#print(speed)
	if (speed > 1) and throttle_val == 0 and brake_val==0:
		if reverse:
			set_engine_force(MAX_ENGINE_FORCE*3)
		else:
			set_engine_force(-MAX_ENGINE_FORCE*3)
	
	if (speed>0 and speed<1) and throttle_val == 0:
		set_linear_velocity(Vector3(0,0,0))
		set_angular_velocity(Vector3(0,0,0))
	
	if (reverse and speed > 5) or speed > MAX_SPEED:
		set_engine_force(0)
		
	
			
	steer_target = steer_val * MAX_STEER_ANGLE
	if (steer_target < steer_angle):
		steer_angle -= (steer_speed - (speed / 20)) * delta 
		if (steer_target > steer_angle):
			steer_angle = steer_target
	elif (steer_target > steer_angle):
		steer_angle += (steer_speed - (speed / 20)) * delta 
		if (steer_target < steer_angle):
			steer_angle = steer_target
	
	steering = steer_angle 
	
	Globals.vehiclePosition = translation
	Globals.vehiclePosition.y = 0