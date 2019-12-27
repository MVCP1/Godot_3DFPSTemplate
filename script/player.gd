extends KinematicBody

# Declare member variables here. Examples:
var vel = 5.0
var sensitivity = -0.001
var angle = 80
var pre_bullet = preload("res://scenes/bullet.tscn")

var mov = Vector3(0,0,0)

var tocou = false
var procurando = false

var chao = false
var teto = false
var gravidade = -10
var vertical = 0
var pulo = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if chao and procurando:
		tocou = true
	else:
		tocou = false
	if not chao:
		procurando = true
	if chao and procurando:
		procurando = false
	if tocou:
		mov = Vector3(0,0,0)
		print(tocou)
	if chao:
		print("parado")
		
		if Input.is_action_pressed("shift"):
			vel = 7.5
		else:
			vel = 5
	else:
		print("caindo")
	pass

func _physics_process(delta):
	move_and_slide(Vector3(0,vertical,0))
	get_node("RayCast_chao").force_raycast_update()
	get_node("RayCast_teto").force_raycast_update()
	chao = get_node("RayCast_chao").is_colliding()
	teto = get_node("RayCast_teto").is_colliding()
	gravidade(delta)
	
	if Input.is_action_just_pressed("espaco") and chao:
		vertical = pulo*delta
		mov = Vector3(0,0,0)
		if chao:
			if Input.is_action_pressed("frente"):
				mov = mov + ((get_node("frente").get_global_transform().origin - get_translation()) * vel/4 * 1)
			if Input.is_action_pressed("tras"):
				mov = mov + ((get_node("frente").get_global_transform().origin - get_translation()) * vel/4 * (-1))
			if Input.is_action_pressed("direita"):
				mov = mov + ((get_node("lado").get_global_transform().origin - get_translation()) * vel/4 * 1)
			if Input.is_action_pressed("esquerda"):
				mov = mov + ((get_node("lado").get_global_transform().origin - get_translation()) * vel/4 * (-1))
	#if chao:
		#mov = Vector3(0,0,0)
	if not chao:
		move_and_slide((mov))
		
		
	if Input.is_action_pressed("frente"):
		if chao:
			move_and_slide((get_node("frente").get_global_transform().origin - get_translation()) * vel)
		else:
			move_and_slide((get_node("frente").get_global_transform().origin - get_translation()) * (3*vel/4))
		
	if Input.is_action_pressed("tras"):
		if chao:
			move_and_slide((get_node("frente").get_global_transform().origin- get_translation()) * vel * -1)
		else:
			move_and_slide((get_node("frente").get_global_transform().origin- get_translation()) * (3*vel/4) * -1)
			
	if Input.is_action_pressed("direita"):
		if chao:
			move_and_slide((get_node("lado").get_global_transform().origin - get_translation()) * vel)
		else:
			move_and_slide((get_node("lado").get_global_transform().origin - get_translation()) * (3*vel/4))
		
	if Input.is_action_pressed("esquerda"):
		if chao:
			move_and_slide((get_node("lado").get_global_transform().origin- get_translation()) * vel * -1)
		else:
			move_and_slide((get_node("lado").get_global_transform().origin- get_translation()) * (3*vel/4) * -1)
		
	if Input.is_action_just_pressed("esc"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().quit()
	
	if Input.is_action_just_pressed("alt"):
		if Input.get_mouse_mode() != Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if Input.is_action_just_pressed("mouse_esquerdo"):
		var bullet = pre_bullet.instance()
		get_node("AudioStreamPlayer").play()
		
		get_parent().add_child(bullet)
		#bullet.set_global_transform(get_node("Camera").get_global_transform())
		#bullet.set_scale(Vector3(0.5,0.5,0.5))
		var rot = get_node("Camera").get_global_transform().basis.get_euler()
		bullet.set_rotation(Vector3(rot.z,rot.y+PI/2,rot.x))

		bullet.set_translation(get_node("Camera").get_global_transform().origin)
	pass

func _input(event):
	if event is InputEventMouseMotion:
		#rotate_y(event.relative.x * sensitivity)
		set_rotation(get_rotation() + Vector3(0,event.relative.x * sensitivity, 0))
		#if get_node("Camera").rotation_degrees.x + rad2deg(event.relative.y) > -60 and get_node("Camera").rotation_degrees.x + rad2deg(event.relative.y) < 60:
		get_node("Camera").set_rotation(get_node("Camera").get_rotation() + Vector3(event.relative.y * sensitivity, 0, 0))
		get_node("Camera").set_rotation(Vector3(deg2rad(clamp(rad2deg(get_node("Camera").get_rotation().x), -angle, angle)), get_node("Camera").get_rotation().y, get_node("Camera").get_rotation().z))

func gravidade(delta):
	if chao:# and not Input.is_action_just_pressed("espaco"):
		#print("parado")
		if not(Input.is_action_pressed("frente") or Input.is_action_pressed("tras") or Input.is_action_pressed("esquerda") or Input.is_action_pressed("direita")):
			vertical = 0
		else:
			vertical = -1
	else:
		vertical = vertical + gravidade*delta
		#print("caindo")
	if teto:
		vertical = (-1)*sqrt(vertical*vertical)/2
	#if ladeira and not Input.is_action_just_pressed("espaco"):
	#	print("desce")
	pass