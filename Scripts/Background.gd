extends Node

@export var speed_scale : float = 10
@export var offset : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.global_position = Vector2(self.global_position.x, %Camera2D.get_screen_center_position().y/speed_scale)
	self.global_position += Vector2(0, offset)
