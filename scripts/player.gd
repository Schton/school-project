extends CharacterBody2D

@export var speed = 100.0
@export var jump_force = 400.0
@export var gravity_value = 1000.0 # Our fake gravity

var z_height = 0.0
var z_velocity = 0.0
var is_jumping = false

@onready var sprite = $AnimatedSprite2D

func _physics_process(delta):
	# --- 1. Horizontal/Vertical Movement (X, Y) ---
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction != Vector2.ZERO:
		velocity = direction * speed
		update_animation(direction)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
		if not is_jumping: sprite.stop()

	# --- 2. The Jump Logic (The "Fake" Z Axis) ---
	if Input.is_action_just_pressed("jump") and not is_jumping:
		z_velocity = -jump_force # Launch upwards
		is_jumping = true

	if is_jumping:
		apply_jump_physics(delta)

	# Move the actual physics body (X and Y)
	move_and_slide()

func apply_jump_physics(delta):
	# Apply "fake" gravity to our vertical velocity
	z_velocity += gravity_value * delta
	z_height += z_velocity * delta

	if z_height >= 0:
		# We've landed!
		z_height = 0
		z_velocity = 0
		is_jumping = false
	
	# Physically offset the sprite node to show the height
	sprite.position.y = z_height

func update_animation(dir):
	# (Use the same logic from before here...)
	if abs(dir.x) > abs(dir.y):
		sprite.play("walk_right" if dir.x > 0 else "walk_left")
	else:
		sprite.play("walk_down" if dir.y > 0 else "walk_up")
