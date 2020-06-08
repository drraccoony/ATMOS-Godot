extends KinematicBody2D

export var movespeed = 100
export var jumpheight = 250
export var gravity = 10

var jetpack_max_fuel = 40
var jetpack_fuel = jetpack_max_fuel

const up = Vector2(0, -1)
var motion = Vector2()

var onground = 0
var jumped = 0
var jetpack_thrust = 40
var jetpack_armed = 0
var jetpacking = 0

func _ready():
	$jetfuel_bar.max_value = jetpack_max_fuel
	$jetfuel_bar.value = jetpack_fuel

func _physics_process(delta):
	if motion.y < 400:
		motion.y += gravity
	#print(motion.y)
	if is_on_floor() and (jetpack_fuel <= jetpack_max_fuel+1):
		jetpack_fuel += 0.1
		$jetfuel_bar.value = jetpack_fuel
	
	if jetpack_fuel >= jetpack_max_fuel:
		$jetfuel_bar.visible = 0
	else:
		$jetfuel_bar.visible = 1
	
	if Input.is_action_pressed("ui_right"):
		motion.x = movespeed
		$sprite.flip_h = false
		if is_on_floor():
			$sprite.play("run")
	elif Input.is_action_pressed("ui_left"):
		motion.x = -movespeed
		$sprite.flip_h = true
		if is_on_floor():
			$sprite.play("run")
	else:
		motion.x = 0
		$sprite.play("idle")
	
		if is_on_floor() and jumped:
			jumped = 0
			$SndLand.play(0)
			$SndJetpack.stop()
			jetpack_armed = 0
			jetpacking = 0
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			$sprite.play("jump")
			$SndJump.play(0)
			motion.y = -jumpheight
			onground = 0
			jumped = 1
	
	if jumped and !jetpack_armed and Input.is_action_just_released("ui_up"):
		jetpack_armed = 1
		print ("Jetpack Armed!!")
	
	if Input.is_action_pressed("ui_up") and jetpack_armed and jetpack_fuel > 0:
		if jetpack_armed == 1:
			$SndJetpack.play()
			jetpack_armed = 2
			jetpacking = 1
		if motion.y > -100 and jetpack_fuel > 0:
			motion.y += -jetpack_thrust
			$jet_parts.emitting = 1
			jetpack_fuel -= 1
			$jetfuel_bar.value = jetpack_fuel
	if jetpack_fuel == 0:
		$SndJetpack.stop()
		$jet_parts.emitting = 0
		jetpacking = 0
	
	if jetpacking and Input.is_action_just_released("ui_up"):
		$SndJetpack.stop()
		$jet_parts.emitting = 0
		jetpacking = 0
		jetpack_armed = 1
	
	
	
	move_and_slide(motion, up)
	pass
