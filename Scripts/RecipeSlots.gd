extends Node
class_name RecipeSlots

#First slot is what the recipe is making, the next 4 are the components of the recipe.
@export var slots : Array[Slot]
#UNIQUE recipe ID
var current_recipe : int = 1
#Items from InvSlots
var item_prefab_list : Array[PackedScene]
#Keeps track of if its making a weapon
var is_weapon_recipe : bool
#Keeps track of the odds of each behavior being attached to the weapon on pressing build. each set of odds subtracts the one before it from itself.
#EX: [30, 40, 70, 100] --- the string associated with the 2nd index, 40, would only have a 10% chance of hitting, due to the number 30 before it.
var behavior_odds : Dictionary[int, String]
#Keeps track of the base stats of the weapon (multiplied by ten, so a base multiplier of 2 if unaffected by the behavior would be 20).
var stat_multiplier : int
#resistances of the weapon
var current_resistances : Array[int] = [0,0]
#bool to keep order of operations for spawn correct
var everything_spawned : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#set world spawner pointer
	get_parent().world_spawner.active_recipe = self
	#grab item prefab list
	item_prefab_list = get_parent().world_spawner.active_inventory.item_prefab_list
	#change all slots to recipe slots
	change_is_recipe(true)
	#Change the base recipe to 1
	change_recipe(1)

#Change all slots to recipe slots
func change_is_recipe(recipe : bool) -> void:
	for slot in slots:
		slot.recipe_slot = recipe

#Change the recipe based on the recipe id given
func change_recipe(recipe_num) -> void:
	#Clear all items shown
	for item in %RecipeItemContainer.get_children():
		item.queue_free()
	for item in %ComponentItemContainer.get_children():
		item.queue_free()
	for slot in slots:
		slot.item_held = null
		slot.slot_id = 0
	#change id to given id
	current_recipe = recipe_num
	match current_recipe:
		#-=+=- WORK AREA -=+=-
		1:
			#WEAPON TEMPLATE
			#Name of item
			%SectionName.text = "Common Crossbow"
			#is a weapon
			is_weapon_recipe = true
			#Keeps track of the odds of each behavior being attached to the weapon on pressing build. Each set of odds subtracts the one before it from itself.
			#EX: [30, 40, 70, 100] --- the string associated with the 2nd index, 40, would only have a 10% chance of hitting, due to the number 30 before it.
			behavior_odds = {25 : "Blind", 50 : "Blind", 75 : "Blind", 100 : "Blind"}
			#Multiplier associated with the weapon. A common weapon will have 1, uncommon 2, etc. This is before the behavior affects the multiplier.
			stat_multiplier = 1
			#Resistances to Fire, Ice. Negative bad, positive good
			current_resistances = [-15, 15]
			#Item_id of what is being made
			slots[0].slot_id = 1
			#if recipe creates multiple, you can increase this number to how many it should create
			slots[0].stack_consume_size = 1
			#Rest are the items being consumed
			slots[1].slot_id = 8
			slots[1].stack_consume_size = 1
			slots[2].slot_id = 9
			slots[2].stack_consume_size = 1
		2:
			#MATERIAL TEMPLATE
			#Material name
			%SectionName.text = "Reinforced Plank"
			#Not a weapon
			is_weapon_recipe = false
			#Whats being made
			slots[0].slot_id = 8
			#How many are being made at once
			slots[0].stack_consume_size = 1
			#Rest is what is being consumed
			slots[1].slot_id = 3
			slots[1].stack_consume_size = 2
			slots[2].slot_id = 4
			slots[2].stack_consume_size = 1
		3:
			%SectionName.text = "Arrow"
			is_weapon_recipe = false
			slots[0].slot_id = 9
			slots[0].stack_consume_size = 1
			slots[1].slot_id = 4
			slots[1].stack_consume_size = 1
			slots[2].slot_id = 3
			slots[2].stack_consume_size = 1
			slots[3].slot_id = 5
			slots[3].stack_consume_size = 1
		4:
			%SectionName.text = "Common Fire Book"
			is_weapon_recipe = true
			behavior_odds = {25 : "Blind", 50 : "Blind", 75 : "Blind", 100 : "Blind"}
			stat_multiplier = 1
			current_resistances = [15, -15]
			slots[0].slot_id = 2
			slots[0].stack_consume_size = 1
			slots[1].slot_id = 10
			slots[1].stack_consume_size = 1
			slots[2].slot_id = 11
			slots[2].stack_consume_size = 1
			slots[3].slot_id = 5
			slots[3].stack_consume_size = 2
		5:
			%SectionName.text = "Magic Goo"
			is_weapon_recipe = false
			slots[0].slot_id = 10
			slots[0].stack_consume_size = 1
			slots[1].slot_id = 6
			slots[1].stack_consume_size = 1
			slots[2].slot_id = 7
			slots[2].stack_consume_size = 1
		6:
			%SectionName.text = "Leather"
			is_weapon_recipe = false
			slots[0].slot_id = 11
			slots[0].stack_consume_size = 1
			slots[1].slot_id = 6
			slots[1].stack_consume_size = 1
			slots[2].slot_id = 5
			slots[2].stack_consume_size = 2
		7:
			%SectionName.text = "Gold Ingot"
			is_weapon_recipe = false
			slots[0].slot_id = 12
			slots[0].stack_consume_size = 1
			slots[1].slot_id = 4
			slots[1].stack_consume_size = 3
			slots[2].slot_id = 10
			slots[2].stack_consume_size = 1
			slots[3].slot_id = 6
			slots[3].stack_consume_size = 1
		8:
			%SectionName.text = "Uncommon Crossbow"
			is_weapon_recipe = true
			behavior_odds = {25 : "Blind", 50 : "Blind", 75 : "Blind", 100 : "Blind"}
			stat_multiplier = 2
			current_resistances = [-15, 15]
			slots[0].slot_id = 13
			slots[0].stack_consume_size = 1
			slots[1].slot_id = 1
			slots[1].stack_consume_size = 1
			slots[2].slot_id = 12
			slots[2].stack_consume_size = 1
			slots[3].slot_id = 10
			slots[3].stack_consume_size = 2
		#-=+=- WORK AREA END -=+=-
	#Spawns new recipe items based on the new recipe
	spawn_recipe_item(slots[0].slot_id, slots[0].stack_consume_size, false)
	spawn_recipe_item(slots[1].slot_id, slots[1].stack_consume_size, true)
	spawn_recipe_item(slots[2].slot_id, slots[2].stack_consume_size, true)
	if slots[3].slot_id > 0:
		spawn_recipe_item(slots[3].slot_id, slots[3].stack_consume_size, true)
	if slots[4].slot_id > 0:
		spawn_recipe_item(slots[4].slot_id, slots[4].stack_consume_size, true)
	#deal with the inspector
	var temp_indexes : Array[String]
	for i in range(behavior_odds.size()):
		temp_indexes.push_back(behavior_odds[behavior_odds.keys()[i]])
	var temp_keys : Array[int]
	for i in range(behavior_odds.size()):
		if i == 0:
			temp_keys.push_back(behavior_odds.keys()[i])
		else:
			temp_keys.push_back(behavior_odds.keys()[i] - behavior_odds.keys()[i - 1])
	if not everything_spawned:
		await get_parent().world_spawner.everything_spawned
		everything_spawned = true
	var temp_array : Array[int] = []
	get_parent().world_spawner.active_inspector.change_inspector(slots[0].slot_id, true, "", 0, temp_array, temp_array, "", Item.get_material_description(slots[0].slot_id), temp_keys, temp_indexes)

#Does what it says
func spawn_recipe_item(item_num : int, stack_size : int, component : bool) -> void:
	var temp_item : Item = item_prefab_list[item_num-1].instantiate()
	temp_item.recipe_item = true
	temp_item.z_index = 1
	temp_item.current_stack_size = stack_size
	if component:
		%ComponentItemContainer.add_child(temp_item)
	else:
		%RecipeItemContainer.add_child(temp_item)

#Get the mouse's hovering slot, if anything
func get_slot_hovering() -> Slot:
	for slot in slots:
		if slot.mouse_hovering:
			return slot
	return null

#Check if the specific slot has the right conditions to press build
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

#Get how many recipe items are needed
func get_recipe_item_num() -> int:
	var temp_num : int = 2
	if slots[3].slot_id > 0:
		temp_num = 3
	if slots[4].slot_id > 0:
		temp_num = 4
	return temp_num

#Check if can build the recipe
func check_if_can_build() -> bool:
	for i in range(get_recipe_item_num() + 1):
		if not check_slot_consume(i):
			return false
	return true

#Build the recipe and consume the items to make the recipe item
func build_recipe() -> void:
	if check_if_can_build():
		if slots[0].item_held == null:
			var temp_item : Item = item_prefab_list[slots[0].slot_id - 1].instantiate()
			var temp_inv_slots : InvSlots = get_parent().world_spawner.active_inventory
			temp_inv_slots.add_child(temp_item)
			if is_weapon_recipe:
				var behavior_chances = randi() % 100 + 1
				for i in range(behavior_odds.size()):
					if behavior_chances <= behavior_odds.keys()[i]:
						temp_item.weapon_behavior = behavior_odds[behavior_odds.keys()[i]]
				var total_stat_pool : int
				match temp_item.weapon_behavior:
					"Blind":
						#increases the stat pool by 20
						total_stat_pool = 10 * (stat_multiplier + 2)
				for j in range(total_stat_pool):
					var stat_chances = randi() % 6
					temp_item.weapon_stats[stat_chances] += 1
				temp_item.weapon_durability = 100
				temp_item.weapon_resistances = current_resistances
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

#When the build button is pressed
func _on_build_pressed() -> void:
	build_recipe()
