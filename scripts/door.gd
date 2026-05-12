extends Area2D


func _on_body_entered(body):
	print('entered')
	print(body.get_groups())
	if body.is_in_group("player"):
		body.in_win_zone = true

func _on_body_exited(body):
	#print('exited')
	if body.is_in_group("player"):
		body.in_win_zone = false
