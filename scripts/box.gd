extends RigidBody2D

@export var required_players: int = 2

#Area2D-Node als Kind der Box, um Spieler in der Nähe zu zählen
@onready var interaction_area: Area2D = $Area2D

func _ready():
	freeze = false
	sleeping = false
	lock_rotation = true

func _physics_process(delta):
	# Zähle, wie viele Spieler sich im Erfassungsbereich (Area2D) befinden
	var overlapping_bodies = interaction_area.get_overlapping_bodies()
	var current_players = 0
	
	for body in overlapping_bodies:
		if body.is_in_group("player"):
			current_players += 1

	# Logik: Wenn genug Spieler da sind, befreien wir die Box
	if current_players >= required_players:
		freeze = false
		sleeping = false
	else:
		# Wichtig: contact_monitor muss im RigidBody aktiviert sein!
		if is_on_ground():
			freeze = true
		else:
			freeze = false

# Hilfsfunktion zur sauberen Boden-Erkennung
func is_on_ground() -> bool:
	for body in get_colliding_bodies():
		if not body.is_in_group("player"):
			# Optional: Prüfen, ob die Kollision von unten kommt (Boden)
			return true
	return false
