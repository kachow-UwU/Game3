extends Area


func _on_Carrot_body_entered(body):
	if body.is_in_group("player"):
		get_parent().add_carrot()
		queue_free()
