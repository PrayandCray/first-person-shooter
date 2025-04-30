extends Node3D

var velocity = Vector3.ZERO
@export var lifetime := 3.5
@export var damage := 10
@export var speed = 100.0

func _ready() -> void:
	
	#apply_impulse(Vector3.ZERO, transform.basis.z * -speed) # to fire forward from origin on the axis and move away from
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta):
	translate(velocity * delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
