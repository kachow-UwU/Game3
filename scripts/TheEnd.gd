extends Spatial

var loop = [
Vector3(1, 0, 0),
Vector3(1, 0, 0),
Vector3(0, 0, 1),
Vector3(0, 0, 1),
Vector3(-1, 0, 0),
Vector3(-1, 0, 0),
Vector3(0, 0, -1),
Vector3(0, 0, -1),
Vector3(0, 0, -1),
Vector3(0, 0, -1),
Vector3(-1, 0, 0),
Vector3(-1, 0, 0),
Vector3(0, 0, 1),
Vector3(0, 0, 1),
Vector3(1, 0, 0),
Vector3(1, 0, 0),
]

var id := 0
var water_height := 1.3


func _ready() -> void:
	var ratio = get_viewport().size.x / get_viewport().size.y
	var shader = $CanvasLayer/Fade.material
	shader.set_shader_param("aspect_ratio", ratio)
	$Water.visible = true
	$CanvasLayer/Fade.visible = true
	$CanvasLayer/Fade/AnimationScreen.play("fromBlack")

func _process(_delta) -> void:
	$Water.translation.y = lerp($Water.translation.y, water_height, 0.015)
	$Cam/Camera.rotation_degrees.z = lerp($Cam/Camera.rotation_degrees.z, 0.0, 0.015)


func _on_Timer_timeout() -> void:
	randomize()
	water_height = rand_range(1.3, 1.7)
	$Timer.wait_time = rand_range(0.2, 0.5)
	pass
	
func cam_shake() -> void:
	$Cam/Camera.rotation_degrees.z = -3


func _on_Timer2_timeout():
	$Player.external_dir(loop[id])
	id += 1
	if id == loop.size():
		id = 0
	pass # Replace with function body.


func _on_Button_Menu_pressed():
	var _err = get_tree().change_scene("res://scenes/Menu.tscn")
