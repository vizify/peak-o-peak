extends RigidBody2D

@export var required_players: int = 2
var players_pushing: int = 0

func _ready():
	# Start completely unfrozen so it drops immediately
	freeze = false
	sleeping = false
	lock_rotation = true

func _physics_process(delta):
	# Get a list of everything physically touching the box right now
	var colliding_bodies = get_colliding_bodies()
	
	var is_touching_ground = false
	for body in colliding_bodies:
		if not body.is_in_group("player"):
			is_touching_ground = true
			break

	# IF 2+ players are pushing, ALWAYS let it move
	if players_pushing >= required_players:
		freeze = false
		sleeping = false
	else:
		# If there aren't enough players, ONLY freeze it if it has landed on the ground
		if is_touching_ground:
			freeze = true
		else:
			freeze = false # Keeps it falling through the air if it hasn't hit the ground yet
