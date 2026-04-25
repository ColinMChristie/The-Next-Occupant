extends Node
class_name ArenaSlots

@export var occupant_slots : Array[Slot]
var item_prefab_list : Array[PackedScene]
@export var hero_prefabs : Array[PackedScene]
var hero_list : Array[Hero]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().world_spawner.active_spawn_point_holder = %SpawnPointHolder
	get_parent().world_spawner.active_arena = self
	item_prefab_list = get_parent().world_spawner.active_inventory.item_prefab_list
	spawn_occupant(1002, [0,0,0,1,3,2], [15,-15], "Blind")
	occupant_slots[0].disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_hero(hero_num : int, alliance : bool, occupant_slot : int) -> void:
	var temp_hero : Hero = hero_prefabs[hero_num].instantiate()
	temp_hero.world_spawner = get_parent().world_spawner
	temp_hero.alliance = alliance
	temp_hero.affect_stats()
	hero_list.push_back(temp_hero)
	add_child(temp_hero)
	temp_hero.global_position = occupant_slots[occupant_slot].global_position

#Get the mouse's hovering slot, if anything
func get_slot_hovering() -> Slot:
	for slot in occupant_slots:
		if slot.mouse_hovering:
			return slot
	return null

func spawn_occupant(occupant_id : int, weapon_stats : Array[int], weapon_resistances : Array[int], weapon_behavior : String) -> void:
	var temp_occupant : Item = item_prefab_list[occupant_id - 1].instantiate()
	var temp_inv_slots : InvSlots = get_parent().world_spawner.active_inventory
	temp_inv_slots.add_child(temp_occupant)
	temp_occupant.weapon_behavior = weapon_behavior
	temp_occupant.weapon_resistances = weapon_resistances
	temp_occupant.weapon_stats = weapon_stats
	temp_occupant.current_stack_size = 1
	temp_occupant.inv_slots = temp_inv_slots
	temp_occupant.parent_slot = occupant_slots[0]
	temp_occupant.global_position = occupant_slots[0].global_position
	occupant_slots[0].item_held = temp_occupant
	temp_occupant.z_index = 1


func _on_bet_pressed() -> void:
	for i in range(occupant_slots.size()):
		occupant_slots[i].visible = false
		if occupant_slots[i].item_held != null:
			add_hero(occupant_slots[i].item_held.item_id - 1001, occupant_slots[i].disabled, i)
			occupant_slots[i].item_held.queue_free()
			occupant_slots[i].item_held = null
