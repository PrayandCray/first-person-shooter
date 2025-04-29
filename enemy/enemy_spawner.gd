extends Node3D

@onready var spawn_timer: Timer = $"Spawn Timer"
const ENEMY = preload("res://enemy/enemy.tscn")

func _ready() -> void:
	spawn_timer.start()
	
func _on_spawn_timer_timeout() -> void:
	var enemy_instance = ENEMY.instantiate()
	add_child(enemy_instance)
	print("spawned")
