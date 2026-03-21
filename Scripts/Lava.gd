extends Projectile
class_name Lava

var from_hero : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_alliance(a : bool) -> void:
	from_hero = a


func _on_body_entered(body: Node) -> void:
	pass # Replace with function body.
