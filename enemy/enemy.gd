extends Node3D

@onready var area: Area3D = $"Detection Area"
@onready var body: CSGBox3D = $Body

var player
var active := false
@export var speed := 3.0

const BOB_FREQ = 2
const BOB_AMP = 0.08
var t_bob = 5

func _ready() -> void:
	player = get_node("/root/Main/Player/player")
	area.body_entered.connect(_on_area_body_entered)
	area.body_exited.connect(_on_area_body_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if active and player:
		var to_player = player.global_transform.origin - global_transform.origin
		to_player.y = 0
		var direction = to_player.normalized()
		
		if to_player.length() > 0.8:
			global_translate(to_player.normalized() * speed * delta)
		
		var current_rot = rotation.y
		var target_rot = atan2(direction.x, direction.z)
		var target_rotation_y = global_transform.looking_at(player.global_transform.origin, Vector3.UP).basis
		var new_y = lerp_angle(current_rot, target_rot, delta * 5.0)
		rotation = Vector3(0, new_y, 0)
		
		t_bob += delta * 5
		body.transform.origin = _headbob(t_bob)

func _on_area_body_entered(body):
	if body == player:
		active = true
		print("player entered")

func _on_area_body_exited(body):
	if body == player:
		active = false
		print("player exited")

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP + 1
	return pos
