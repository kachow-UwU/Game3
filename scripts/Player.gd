extends StaticBody

var ext_dir := Vector3.ZERO
var dir := Vector3.ZERO
var old_dir := Vector3.ZERO
var is_moving := false
var is_rotating := false

var is_wall := false
var is_push := false
var is_wall2 := false
var is_push2 := false
var is_wall3 := false
var is_push3 := false

var rotationY := 0
var oldRotationY := 0

var pos1 := Vector2.ZERO

func _ready():
	$AnimationTree.active = true

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.pressed:
			pos1 = event.position
		else:
			calc_swipe(event.position)

func calc_swipe(pos2: Vector2) -> void:
	var pos = pos2 - pos1
	if pos.length() > 100:
		var d = (rad2deg(pos.angle()) + 180)
		d = int(d / 90.0)
		match d:
			0: $".".external_dir(Vector3.BACK)
			1: $".".external_dir(Vector3.LEFT)
			2: $".".external_dir(Vector3.FORWARD)
			3: $".".external_dir(Vector3.RIGHT)



func _physics_process(_delta: float) -> void:
	dir = Vector3.ZERO
	if Input.is_action_just_pressed("ui_up"): dir = Vector3.BACK
	if Input.is_action_just_pressed("ui_down"): dir = Vector3.FORWARD
	if Input.is_action_just_pressed("ui_left"): dir = Vector3.RIGHT
	if Input.is_action_just_pressed("ui_right"): dir = Vector3.LEFT
	
	
#	if dir == Vector3.BACK and rotationY != 180:
#		rotationY = -90
#		print(rotationY)
#	elif dir == Vector3.BACK and rotationY == 180:
#		rotationY = 270
#		print(rotationY)
#	if dir == Vector3.FORWARD: 
#		rotationY = 90
#		print(rotationY)
#	if dir == Vector3.RIGHT: 
#		rotationY = 0
#		print(rotationY)
#	if dir == Vector3.LEFT and rotationY != -90:
#		rotationY = 180
#		print(rotationY)
#	elif dir == Vector3.LEFT and rotationY == -90:
#		rotationY = -180
#		print(rotationY)

	if ext_dir != Vector3.ZERO:
		dir = ext_dir
		ext_dir = Vector3.ZERO

	match dir:
		Vector3.BACK: rotationY = -90
		Vector3.FORWARD: rotationY = 90
		Vector3.RIGHT: rotationY = 0
		Vector3.LEFT: rotationY = 180
		
	
	if dir != Vector3.ZERO and dir != old_dir:
		old_dir = dir
		$RayCast.translation = old_dir * 2 + Vector3.UP * 2.5
		$RayCast2.translation = old_dir * 4 + Vector3.UP * 2.5
		$RayCast3.translation = old_dir * 6 + Vector3.UP * 2.5
		$RayCast.force_raycast_update()
		$RayCast2.force_raycast_update()
		$RayCast3.force_raycast_update()
		
	if dir != Vector3.ZERO:
		if $RayCast.is_colliding():
			is_wall = $RayCast.get_collider().is_in_group("wall")
			is_push = $RayCast.get_collider().is_in_group("block")
		else:
			is_wall = false
			is_push = false
			
		if $RayCast2.is_colliding():
			is_wall2 = $RayCast2.get_collider().is_in_group("wall")
			is_push2 = $RayCast2.get_collider().is_in_group("block")
		else:
			is_wall2 = false
			is_push2 = false
		
		if $RayCast3.is_colliding():
			is_wall3 = true
		else:
			is_wall3 = false
		
		
		if is_wall:
			get_parent().cam_shake()
			$AnimationTree.set("parameters/Hurt/active", true)
		elif is_push and is_wall2:
			get_parent().cam_shake()
			$AnimationTree.set("parameters/Hurt/active", true)
		elif is_push and is_push2 and is_wall3:
			get_parent().cam_shake()
			$AnimationTree.set("parameters/Hurt/active", true)
			
			
		elif not is_push and not is_wall:
			movement(dir)
		elif is_push and not is_wall2 and not is_push2:
			$RayCast.get_collider().set_dir(dir)
			movement(dir)
		elif is_push and is_push2 and not is_wall3:
			$RayCast.get_collider().set_dir(dir)
			$RayCast2.get_collider().set_dir(dir)
			movement(dir)
		
	if rotationY != oldRotationY and not is_rotating:
		is_rotating = true
		$AnimationTree.set("parameters/Walk/active", true)
		$Tween_rotate.interpolate_property($Pivot, 'rotation_degrees:y', oldRotationY, rotationY, 0.1, Tween.TRANS_EXPO, Tween.EASE_OUT)
		$Tween_rotate.start()
		yield($Tween_rotate, "tween_all_completed")
		oldRotationY = rotationY
		is_rotating = false




func movement(vec:Vector3) -> void:
	if is_moving == false:
		is_moving = true
		$AnimationTree.set("parameters/Walk/active", true)
		var a := translation
		var b := a + vec * 2
		$Tween_movement.interpolate_property(self, "translation", a, b, 0.1, Tween.TRANS_EXPO, Tween.EASE_OUT)
		$Tween_movement.start()
		yield($Tween_movement, "tween_all_completed")
		
		if $RayCastGround.is_colliding() == false:
			var c = b + Vector3.DOWN * 2
			$AnimationTree.set("parameters/Transition/current", 1)
			$Tween_movement.interpolate_property(self, "translation", b, c, 0.1, Tween.TRANS_EXPO, Tween.EASE_OUT)
			$Tween_movement.start()
			yield(get_tree().create_timer(1.5), "timeout")
			var _err = get_tree().reload_current_scene()
		
		is_moving = false
		
func external_dir(vec: Vector3) -> void:
	ext_dir = vec



