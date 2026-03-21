extends Weapon
class_name FireBook

@export var fire : PackedScene
@export var self_node : Node2D
var shot_speed : float = 1000.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fire_bolt(dir : Vector2, char : Character) -> void:
	self_node.rotation = char.body.rotation
	var temp_bolt : FireBolt = fire.instantiate()
	char.world_spawner.add_child(temp_bolt)
	temp_bolt.body.global_position = self_node.global_position
	temp_bolt.body.apply_central_impulse(dir * shot_speed)
	temp_bolt.body.rotation = char.body.rotation
	temp_bolt.set_alliance(true)
