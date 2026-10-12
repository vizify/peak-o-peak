class_name Box
extends RigidBody2D


@export var required_players: int = 2
var players_pushing: int = 0

func _ready():
	set_multiplayer_authority(1)
	freeze = true
	if not multiplayer.is_server():
		set_physics_process(false)


func _physics_process(delta):
	if players_pushing >= required_players:
		freeze = false
	else:
		freeze = true

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		players_pushing += 1

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		players_pushing -= 1
