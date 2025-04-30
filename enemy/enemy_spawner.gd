extends Node3D

@onready var spawn_timer: Timer = $"Spawn Timer"
const ENEMY = preload("res://enemy/enemy.tscn")

func _ready() -> void:
	spawn_timer.start()
	
func _process(delta: float) -> void:
	pass

func _on_spawn_timer_timeout() -> void:
	var enemy_instance = ENEMY.instantiate()
	enemy_instance.global_position.z += 1
	enemy_instance.global_position.y -= 1
	add_child(enemy_instance)
	print("spawned")
