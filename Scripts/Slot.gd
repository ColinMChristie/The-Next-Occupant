extends TextureButton
class_name Slot

var item_held : Item = null
var mouse_hovering : bool = false
var weapon_slot : bool = false
var recipe_slot : bool = false
var slot_id : int = 0
var stack_consume_size : int = 0
@export var is_occupant_slot : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if disabled: return
	if mouse_hovering:
		if Input.is_action_just_pressed("left_click"):
			if item_held != null:
				item_held.on_mouse = true


func _on_mouse_entered() -> void:
	mouse_hovering = true


func _on_mouse_exited() -> void:
	mouse_hovering = false
