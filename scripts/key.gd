extends Area2D

func _on_body_entered(body):
	print("key entered")
	if body.is_in_group("player"):
		body.has_key = true
		queue_free()
