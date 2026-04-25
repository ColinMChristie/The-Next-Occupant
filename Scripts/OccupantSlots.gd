extends Node
class_name OccupantSlots

@export var slots : Array[Slot]
@export var occupant_slot : Slot
var item_prefab_list : Array[PackedScene]
var archer_ids : Array[int] = [1,13]
var fire_wizard_ids : Array[int] = [2]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().world_spawner.active_occupant = self
	item_prefab_list = get_parent().world_spawner.active_inventory.item_prefab_list
	for slot in slots:
		slot.weapon_slot = true

#Get the mouse's hovering slot, if anything
func get_slot_hovering() -> Slot:
	for slot in slots:
		if slot.mouse_hovering:
			return slot
	return null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_occupant(occupant_id : int, weapon_stats : Array[int], weapon_resistances : Array[int], weapon_behavior : String) -> void:
	for slot in slots:
		if slot.item_held != null:
			slot.item_held.queue_free()
			slot.item_held = null
	var temp_occupant : Item = item_prefab_list[occupant_id - 1].instantiate()
	var temp_inv_slots : InvSlots = get_parent().world_spawner.active_inventory
	temp_inv_slots.add_child(temp_occupant)
	temp_occupant.weapon_behavior = weapon_behavior
	temp_occupant.weapon_resistances = weapon_resistances
	temp_occupant.weapon_stats = weapon_stats
	temp_occupant.current_stack_size = 1
	temp_occupant.inv_slots = temp_inv_slots
	temp_occupant.parent_slot = occupant_slot
	temp_occupant.global_position = occupant_slot.global_position
	occupant_slot.item_held = temp_occupant
	temp_occupant.z_index = 1

func get_occupant_id() -> int:
	var temp_id : int = slots[0].item_held.item_id
	#Archer
	for id in archer_ids:
		if temp_id == id:
			return 1001
	#Fire Wizard
	for id in fire_wizard_ids:
		if temp_id == id:
			return 1002
	return 0

func get_occupant_stats() -> Array[int]:
	var temp_total_stats : Array[int] = [0,0,0,0,0,0]
	for slot in slots:
		if slot.item_held != null:
			for i in range(slot.item_held.weapon_stats.size()):
				temp_total_stats[i] += slot.item_held.weapon_stats[i]
	return temp_total_stats

func get_occupant_resistances() -> Array[int]:
	var temp_total_resists : Array[int] = [0,0]
	if slots[0].item_held != null:
		for i in range(slots[0].item_held.weapon_resistances.size()):
			temp_total_resists[i] = slots[0].item_held.weapon_resistances[i]
	return temp_total_resists

func get_occupant_behavior() -> String:
	if slots[0].item_held != null:
		return slots[0].item_held.weapon_behavior
	return ""

func _on_build_pressed() -> void:
	spawn_occupant(get_occupant_id(), get_occupant_stats(), get_occupant_resistances(), get_occupant_behavior())
