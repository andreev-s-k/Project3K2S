extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 8.5
var jumps=0
var max_jumps=2
var line = 0
var finished = 0
@onready var fast_run: Node3D = $"Fast Run"
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D


func _ready() -> void:
	fast_run.get_node("AnimationPlayer").play("mixamo_com")

func finish_game():
	finished = 1

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		jumps = 0
	if not finished:
		fast_run.get_node("AnimationPlayer").play("mixamo_com")
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or jumps < max_jumps) and not finished:
		jumps += 1
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#
		#velocity.x = direction.x * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
	if Input.is_action_just_pressed("ui_left") and not finished:
		if line > -1: line-= 1
	if Input.is_action_just_pressed("ui_right") and not finished:
		if line < 1: line+= 1
	
	if abs(global_position.x - 3 * line) > 0.25:
		if global_position.x - 3 * line > 0:
			velocity.x = -SPEED * 3
		elif global_position.x - 3 * line < 0:
			velocity.x = SPEED * 3
	else:
		velocity.x = 0
	if not finished:
		velocity.z = -(SPEED + SPEED * abs(global_position.z) / 1000)
	else:
		velocity.z = 0
	move_and_slide()


func _on_timer_timeout() -> void:
	if audio_stream_player_3d.finished and not finished:
		audio_stream_player_3d.play()
