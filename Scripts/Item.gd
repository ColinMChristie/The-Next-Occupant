extends TextureRect
class_name Item

var on_mouse : bool = false
var parent_slot : Slot
var inv_slots : InvSlots
@export var item_id : int
@export var is_weapon : bool
@export var max_stack_size : int
var current_stack_size : int
var recipe_item : bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if max_stack_size == 1: %StackSize.visible = false
	%StackSize.text = str(current_stack_size)
	if recipe_item: return
	if on_mouse:
		global_position = get_global_mouse_position() + Vector2(-16, -16)
		if Input.is_action_just_released("left_click"):
			var temp_slot : Slot = inv_slots.get_slot_hovering()
			if temp_slot != null and temp_slot.weapon_slot == is_weapon:
				if temp_slot.item_held == null:
					parent_slot.item_held = null
					parent_slot = temp_slot
					parent_slot.item_held = self
				else:
					if temp_slot.item_held.item_id == item_id and temp_slot != parent_slot:
						if temp_slot.item_held.max_stack_size >= current_stack_size + temp_slot.item_held.current_stack_size:
							parent_slot.item_held = null
							temp_slot.item_held.current_stack_size += current_stack_size
							queue_free()
			var temp_recipe_slots : RecipeSlots = inv_slots.get_parent().world_spawner.active_recipe
			if temp_recipe_slots != null:
				var temp_recipe_slot : Slot = temp_recipe_slots.get_slot_hovering()
				if temp_recipe_slot != null and temp_recipe_slot.slot_id == item_id:
					if temp_recipe_slot.item_held == null:
						parent_slot.item_held = null
						parent_slot = temp_recipe_slot
						parent_slot.item_held = self
					else:
						if temp_recipe_slot.item_held.item_id == item_id and temp_recipe_slot != parent_slot:
							if temp_recipe_slot.item_held.max_stack_size >= current_stack_size + temp_recipe_slot.item_held.current_stack_size:
								parent_slot.item_held = null
								temp_recipe_slot.item_held.current_stack_size += current_stack_size
								queue_free()
			on_mouse = false
	else:
		global_position = parent_slot.global_position
