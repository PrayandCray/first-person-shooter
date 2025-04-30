extends Node3D

@export var bullet_scene : PackedScene
@onready var muzzle: Marker3D = $muzzle
@export var fire_force := 50.0
@export var cooldown := 0.2
var player
var can_shoot = true

func _ready() -> void:
	player = get_node("/root/Main/Player/player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = -player.head.global_transform.basis.z.normalized()
	print(direction)
	if Input.is_action_just_pressed("shoot"):
		shoot()

func shoot():
	can_shoot = false
	#play audio here
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	
	bullet.global_transform = muzzle.global_transform
	
	# Calculate direction the player is facing (from muzzle)
	var direction = -muzzle.global_transform.basis.z.normalized()
	bullet.velocity = direction * bullet.speed
	
	await get_tree().create_timer(cooldown).timeout
	can_shoot = true
