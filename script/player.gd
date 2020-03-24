extends KinematicBody
 
const SPEED = 12/2
const JUMP_FORCE = 30/3
const GRAVITY = 0.98/2
const MAX_FALL_SPEED = 30/2
 
const SENSITIVITY = -0.001
const ANGLE = 80
 
var y_vel = 0
 
func _ready():
	#HIDE MOUSE CURSOR
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

func _input(event):
	#CAMERA ROTATION
	if event is InputEventMouseMotion:
		set_rotation(get_rotation() + Vector3(0,event.relative.x * SENSITIVITY, 0))
		get_node("Camera").set_rotation(get_node("Camera").get_rotation() + Vector3(event.relative.y * SENSITIVITY, 0, 0))
		get_node("Camera").set_rotation(Vector3(deg2rad(clamp(rad2deg(get_node("Camera").get_rotation().x), -ANGLE, ANGLE)), get_node("Camera").get_rotation().y, get_node("Camera").get_rotation().z))


func _physics_process(delta):
	#QUIT GAME
	if Input.is_action_just_pressed("esc"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().quit()
	
	#MOVEMENT
	var move = Vector3()
	if Input.is_action_pressed("frente"):
		move.z -= 1
	if Input.is_action_pressed("tras"):
		move.z += 1
	if Input.is_action_pressed("direita"):
		move.x += 1
	if Input.is_action_pressed("esquerda"):
		move.x -= 1
	move = move.normalized()
	move = move.rotated(Vector3(0, 1, 0), rotation.y)
	move *= SPEED
	#RUNNING
	if Input.is_action_pressed("shift"):
		move *= 2
	move.y = y_vel
	move_and_slide(move, Vector3(0, 1, 0), true)
	
	
	#FLOOR CHECK
	get_node("RayCast_chao").force_raycast_update()
	var on_floor = is_on_floor() or get_node("RayCast_chao").is_colliding()
	
	#CEILING STOP
	if is_on_ceiling() and y_vel > 0:
		y_vel = 0
	
	#GRAVITY
	y_vel -= GRAVITY
	var just_jumped = false
	#JUMP
	if on_floor and Input.is_action_just_pressed("espaco"):
		just_jumped = true
		y_vel = JUMP_FORCE
	#CONSTANT GRAVITY WHEN ON FLOOR (FOR WALKING DOWN SLOPES)
	if on_floor and y_vel <= 0:
		y_vel = -4
	#FALL SPEED LIMIT
	if y_vel < -MAX_FALL_SPEED:
		y_vel = -MAX_FALL_SPEED




#DEBUG INFORMATION
	#MOVEMENT VECTOR
	$Camera/CanvasLayer/RichTextLabel3.text = String(move)
	#ON FLOOR (3x)
	if is_on_floor():
		$Camera/CanvasLayer/Sprite3.set_modulate(Color(0,1,0,1))
	else:
		$Camera/CanvasLayer/Sprite3.set_modulate(Color(1,0,0,1))
	if get_node("RayCast_chao").is_colliding():
		$Camera/CanvasLayer/Sprite5.set_modulate(Color(0,1,0,1))
	else:
		$Camera/CanvasLayer/Sprite5.set_modulate(Color(1,0,0,1))
	if on_floor:
		$Camera/CanvasLayer/Sprite6.set_modulate(Color(0,1,0,1))
	else:
		$Camera/CanvasLayer/Sprite6.set_modulate(Color(1,0,0,1))
	#ON CEILING
	if is_on_ceiling():
		$Camera/CanvasLayer/Sprite4.set_modulate(Color(0,1,0,1))
	else:
		$Camera/CanvasLayer/Sprite4.set_modulate(Color(1,0,0,1))
	#FALLING
	if on_floor and y_vel < 0:
		$Camera/CanvasLayer/Sprite2.set_modulate(Color(1,0,0,1))
	else:
		$Camera/CanvasLayer/Sprite2.set_modulate(Color(0,1,0,1))
