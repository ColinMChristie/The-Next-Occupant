extends Node
class_name Projectile

@export var body : RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_alliance(alliance : bool) -> void:
	if alliance:
		# This is an Alliance Projectile
		body.set_collision_layer_value(3, true)
		body.set_collision_layer_value(4, false)# Clear enemy projectile layer
		# SCAN for Enemies (Layer 2)
		body.set_collision_mask_value(2, true)
		body.set_collision_mask_value(1, false) # IGNORE Hero (Layer 1)
	else:
		# This is an Enemy Projectile
		body.set_collision_layer_value(4, true)
		body.set_collision_layer_value(3, false) # Clear alliance projectile layer
			
		# SCAN for Hero/Alliance (Layer 1)
		body.set_collision_mask_value(1, true)
		body.set_collision_mask_value(2, false) # IGNORE other Enemies (Layer 2)
