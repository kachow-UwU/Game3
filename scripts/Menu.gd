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
	if Global.save_exist() == false:
		$CanvasLayer/VBoxContainer/Button_resume.visible = false
	else:
		$CanvasLayer/VBoxContainer/Button_resume.visible = true

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


func _on_Button_new_pressed():
	$CanvasLayer/Fade/AnimationScreen.play("toBlack")
	yield($CanvasLayer/Fade/AnimationScreen, "animation_finished")
	Global.level = Global.default_level
	Global.removeSave()
	var _err = get_tree().change_scene("res://scenes/Scene" + str(Global.level) + ".tscn")
	pass # Replace with function body.


func _on_Button_quit_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_Timer2_timeout():
	$Player.external_dir(loop[id])
	id += 1
	if id == loop.size():
		id = 0
	pass # Replace with function body.


func _on_Button_resume_pressed():
	$CanvasLayer/Fade/AnimationScreen.play("toBlack")
	yield($CanvasLayer/Fade/AnimationScreen, "animation_finished")
	var _lvl = Global.get_level()
	var file = File.new()
	if file.file_exists("res://scenes/Scene" + str(Global.level) + ".tscn"):
		var _err = get_tree().change_scene("res://scenes/Scene" + str(Global.level) + ".tscn")
	else:
		var _err = get_tree().change_scene("res://scenes/TheEnd.tscn")


	
