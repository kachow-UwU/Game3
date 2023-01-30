extends Spatial

var next_level := Global.level + 1
export(int) var carrots := 1
var carrot_added := 0

var water_height := 1.3
var shader

func _ready() -> void:
	$HUD/Fade.visible = true
	$Water.visible = true
	shader = $HUD/Fade.material
	var ratio = get_viewport().size.x / get_viewport().size.y
	shader.set_shader_param("aspect_ratio", ratio)
	$HUD/Fade/AnimationScreen.play("fromBlack")


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

func add_carrot() -> void:
	carrot_added += 1
	Global.add_level()
	if carrots == carrot_added:
		var file = File.new()
		if file.file_exists("res://scenes/Scene" + str(next_level) + ".tscn"):
			var _err = get_tree().change_scene("res://scenes/Scene" + str(next_level) + ".tscn")
		else:
			Global.level = Global.default_level
			Global.removeSave()
			var _err = get_tree().change_scene("res://scenes/TheEnd.tscn")


func _on_ButtonHome_pressed():
	var _err = get_tree().change_scene("res://scenes/Menu.tscn")


func _on_ButtonRetry_pressed():
	var _err = get_tree().reload_current_scene()
