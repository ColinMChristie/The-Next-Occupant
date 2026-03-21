extends Projectile
class_name FireBolt

@export var lava : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node) -> void:
	if body is Hero:
		var temp_lava : Lava = lava.instantiate()
		body.world_spawner.add_child(temp_lava)
		temp_lava.body.global_position = body.global_position
		self.queue_free()
