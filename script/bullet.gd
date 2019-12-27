extends Area

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(get_node("frente").get_global_transform().origin)
	set_translation(get_node("frente").get_global_transform().origin)
	#set_rotation(get_rotation() + Vector3(0,PI/180,0))
	pass

func _on_bullet_body_entered(body):
	if body != get_parent().get_node("player"):
		queue_free()
	pass # Replace with function body.
