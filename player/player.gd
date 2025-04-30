extends CharacterBody3D

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera

const SENSITIVITY = 0.0065

var SPEED
const WALK_SPEED = 3.45
const RUN_SPEED = 6.0
const JUMP_VELOCITY = 4.5

var jumping = false
var jump_stored = false

const BOB_FREQ = 2
const BOB_AMP = 0.08
var t_bob = 0

const BASE_FOV = 80.0
const FOV_CHANGE = 3

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().root.set("player_ref", self)

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("esc"):
		get_tree().quit()
		
	if Input.is_action_pressed("jump") and is_on_floor() == false and velocity.y < -3 and velocity.y > -10:
		jump_stored = true
		
	if Input.is_action_pressed("sprint"):
		if is_on_floor():
			SPEED = RUN_SPEED
	else:
		SPEED = WALK_SPEED

	var input_dir := Input.get_vector("left_strafe", "right_strafe", "forward", "backward")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		jumping = false

		if direction:
			velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 10.0)
			velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 10.0)
		else:
			velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 3.0)

	if Input.is_action_pressed("jump") or jump_stored == true:
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			jumping = true
			jump_stored = false

	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)

	var velocity_clamped = clamp(velocity.length(), 0.5, RUN_SPEED / 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	if jumping == false:
		camera.fov = lerp(camera.fov, target_fov, delta * 8.5)

	move_and_slide()


func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos

func crosshair_raycast():
	var screen_center = get_viewport().get_visible_rect().size * 0.5
	var ray_origin = camera.project_ray_origin(screen_center)
	var ray_direction = camera.project_ray_normal(screen_center)
	
	var ray_params = PhysicsRayQueryParameters3D.create(ray_origin, ray_origin + ray_direction * 1000)
	return get_world_3d().direct_space_state.intersect_ray(ray_params)
