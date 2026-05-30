extends CharacterBody2D


const SPEED : float = 500
const JUMP_VELOCITY : float = -500.0
const GRAVITY_MULTIPLIER : float = 2.0

var in_win_zone = false
var has_key = false
var was_on_floor = false

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority(): return
	
	# Add the gravity.
	was_on_floor = is_on_floor()
	if not is_on_floor():
		velocity += get_gravity() * delta * GRAVITY_MULTIPLIER


	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
	
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.is_in_group("object"):
			collider.apply_central_impulse(-collision.get_normal() * 10)
			
	
	if in_win_zone and Input.is_action_just_pressed("jump") and has_key and was_on_floor:
		win()

func win():
	print("You Win!")
