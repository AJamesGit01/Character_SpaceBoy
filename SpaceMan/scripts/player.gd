extends CharacterBody2D

@export var speed = 800
@export var jump_force = -1000
@export var gravity = 1200

var screen_size
var is_jumping = false

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	var direction = Vector2.ZERO

	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Movement inputs
	if Input.is_action_pressed("move_right"):
		direction.x += 1  # Reversed direction
	if Input.is_action_pressed("move_left"):
		direction.x -= 1  # Reversed direction
	if Input.is_action_pressed("move_up") and not is_on_floor():
		direction.y -= 1  # Reversed direction
	if Input.is_action_pressed("move_down") and not is_on_floor():
		direction.y += 1  # Reversed direction
	
	velocity.x = direction.x * speed
	
	# Allow Y movement when flying
	if not is_on_floor():
		velocity.y = direction.y * speed if direction.y != 0 else velocity.y

	# Jump input
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_force
		is_jumping = true
	 
	move_and_slide()
	
	# Animation handling
	if not is_on_floor():
		if direction.x != 0 or direction.y != 0:
			$AnimatedSprite2D.animation = "FLY"
			# Flip X-axis for flying (reverse flip logic)
			$AnimatedSprite2D.flip_h = direction.x < 0  # Now flips when moving left
		else:
			$AnimatedSprite2D.animation = "JUMP"
	elif Input.is_action_pressed("move_down"):
		$AnimatedSprite2D.animation = "DOWN"
		# Flip the animation if needed
		$AnimatedSprite2D.flip_h = direction.x < 0
	elif velocity.x != 0:
		$AnimatedSprite2D.animation = "WALK"
		# Flip walking animation based on velocity
		$AnimatedSprite2D.flip_h = velocity.x < 0  # Now flips when moving left
	else:
		$AnimatedSprite2D.animation = "IDLE"
	
	$AnimatedSprite2D.play()
	
	# Check if landed
	if is_on_floor() and is_jumping:
		is_jumping = false
		$AnimatedSprite2D.animation = "IDLE"
