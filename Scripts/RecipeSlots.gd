extends Node
class_name RecipeSlots

@export var slots : Array[Slot]
var current_recipe : int = 1
var item_prefab_list : Array[PackedScene]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().world_spawner.active_recipe = self
	item_prefab_list = get_parent().world_spawner.active_inventory.item_prefab_list
	change_is_recipe(true)
	change_recipe(3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_is_recipe(recipe : bool) -> void:
	for slot in slots:
		slot.recipe_slot = recipe

func change_recipe(recipe_num) -> void:
	current_recipe = recipe_num
	match current_recipe:
		1:
			%SectionName.text = "Crossbow"
			slots[0].slot_id = 1
			#if recipe creates multiple, you can increase this number to how many it should create
			slots[0].stack_consume_size = 1
			slots[1].slot_id = 8
			slots[1].stack_consume_size = 1
			slots[2].slot_id = 9
			slots[2].stack_consume_size = 1
		2:
			%SectionName.text = "Reinforced Plank"
			slots[0].slot_id = 8
			slots[0].stack_consume_size = 1
			slots[1].slot_id = 3
			slots[1].stack_consume_size = 2
			slots[2].slot_id = 4
			slots[2].stack_consume_size = 1
		3:
			%SectionName.text = "Arrow"
			slots[0].slot_id = 9
			slots[0].stack_consume_size = 1
			slots[1].slot_id = 4
			slots[1].stack_consume_size = 1
			slots[2].slot_id = 3
			slots[2].stack_consume_size = 1
			slots[3].slot_id = 5
			slots[3].stack_consume_size = 1
	spawn_recipe_item(slots[0].slot_id, slots[0].stack_consume_size, false)
	spawn_recipe_item(slots[1].slot_id, slots[1].stack_consume_size, true)
	spawn_recipe_item(slots[2].slot_id, slots[2].stack_consume_size, true)
	if slots[3].slot_id > 0:
		spawn_recipe_item(slots[3].slot_id, slots[3].stack_consume_size, true)
	if slots[4].slot_id > 0:
		spawn_recipe_item(slots[4].slot_id, slots[4].stack_consume_size, true)

func spawn_recipe_item(item_num : int, stack_size : int, component : bool) -> void:
	var temp_item : Item = item_prefab_list[item_num-1].instantiate()
	temp_item.recipe_item = true
	temp_item.z_index = 1
	temp_item.current_stack_size = stack_size
	if component:
		%ComponentItemContainer.add_child(temp_item)
	else:
		%RecipeItemContainer.add_child(temp_item)

func get_slot_hovering() -> Slot:
	for slot in slots:
		if slot.mouse_hovering:
			return slot
	return null

func check_slot_consume(slot_num) -> bool:
	if slot_num == 0:
		if slots[slot_num].item_held == null:
			return true
		else:
			if slots[slot_num].item_held.current_stack_size + slots[slot_num].stack_consume_size <= slots[slot_num].item_held.max_stack_size:
				return true
	else:
		if slots[slot_num].item_held != null:
			if slots[slot_num].item_held.current_stack_size >= slots[slot_num].stack_consume_size:
				return true
	return false

func get_recipe_item_num() -> int:
	var temp_num : int = 2
	if slots[3].slot_id > 0:
		temp_num = 3
	if slots[4].slot_id > 0:
		temp_num = 4
	return temp_num

func check_if_can_build() -> bool:
	for i in range(get_recipe_item_num()):
		if not check_slot_consume(i):
			return false
	return true

func build_recipe() -> void:
	if check_if_can_build():
		if slots[0].item_held == null:
			var temp_item : Item = item_prefab_list[slots[0].slot_id - 1].instantiate()
			var temp_inv_slots : InvSlots = get_parent().world_spawner.active_inventory
			temp_inv_slots.add_child(temp_item)
			temp_item.current_stack_size = slots[0].stack_consume_size
			temp_item.inv_slots = temp_inv_slots
			temp_item.parent_slot = slots[0]
			temp_item.global_position = slots[0].global_position
			slots[0].item_held = temp_item
			temp_item.z_index = 1
		else:
			slots[0].item_held.current_stack_size += slots[0].stack_consume_size
		for i in range(get_recipe_item_num()):
			slots[i + 1].item_held.current_stack_size -= slots[i + 1].stack_consume_size
			if slots[i + 1].item_held.current_stack_size == 0:
				slots[i + 1].item_held.queue_free()
				slots[i + 1].item_held = null

func _on_build_pressed() -> void:
	build_recipe()
