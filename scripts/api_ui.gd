extends Control


func _on_server_pressed() -> void:
	Networkhandler.start_server()

func _on_client_pressed() -> void:
	get_viewport().gui_release_focus()
	Networkhandler.start_client()
