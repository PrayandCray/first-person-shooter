extends Node3D

@export var bullet_scene : PackedScene
@onready var muzzle: Marker3D = $muzzle
@export var fire_force := 50.0
@export var cooldown := 0.2
var player: CharacterBody3D
var player_camera: Camera3D
var can_shoot = true
var gun_offset = Vector3(0.2, 0.8, 0.0)

func _ready() -> void:
	player = get_node("/root/Main/Player/player")
	player_camera = get_node("/root/Main/Player/player/Head/Camera")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not player:
		return
	
	var result = player.crosshair_raycast()
	var origin = muzzle.global_transform.origin
	
	var target_point: Vector3
	if result:
		target_point = result.position
	else:
		var forward = player_camera.global_transform.basis.z
		target_point = origin + forward * 1000
		
	look_at(target_point, Vector3.UP)
	
	if Input.is_action_just_pressed("shoot"):
		shoot()

func shoot():
	if player == null or not can_shoot:
		return
	
	#can_shoot = false
	#play audio here
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_transform.origin = muzzle.global_transform.origin
	
	var forward = -muzzle.global_transform.basis.z.normalized()
	bullet.direction = forward
	bullet.look_at(muzzle.global_transform.origin + forward, Vector3.UP)
	
	bullet.velocity = bullet.direction * fire_force
