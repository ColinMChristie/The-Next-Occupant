extends TextureRect
class_name Item

#If attached to mouse or not
var on_mouse : bool = false
#Slot holding this item
var parent_slot : Slot
#Pointer to InvSlots script for accessing all inventory Slots
var inv_slots : InvSlots
#UNIQUE item ID
@export var item_id : int
#Used in multiple scripts to determine if it is classified as weapon or material
@export var is_weapon : bool
#Max stack size
@export var max_stack_size : int
#declares an occupant if true
@export var is_occupant : bool = false
#What stack size is displayed
var current_stack_size : int
#If this is true, it loses all functionality and is only for display in the recipe tab
var recipe_item : bool = false
#Durability of the weapon, max is always 100 and only applies to weapons
var weapon_durability : int = 100
#Strength, Dexterity, Constitution, Agility, Intelligence, Will; in that order.
var weapon_stats : Array[int] = [0,0,0,0,0,0]
#Fire, Ice in that order (more will be added later, view as percentages)
var weapon_resistances : Array[int] = [0,0]
#Blind is the only behavior I have implemented for now
var weapon_behavior : String

#List of tiered materials. Basic Materials are the base of everything in the game. Common Materials are made from at least 2 Basic Materials.
#Uncommon Materials have at least 1 Common Material in their recipe. Rare Materials have at least one uncommon material in their recipe, and so on.
#Common Weapons are made from at least 1 Common Material.
#Uncommon Weapons are made from the Common Weapon below it AND at least 1 Uncommon Material. Rare weapons and onwards follow this trend.
#-=+=- WORK AREA -=+=-
var basic_materials : Array[int] = [3,4,5,6,7]
var common_materials : Array[int] = [8,9,10,11]
var uncommon_materials : Array[int] = [12]
var rare_materials : Array[int] = []
var epic_materials : Array[int] = []
var legendary_materials : Array[int] =[]
var common_weapons : Array[int] = [1,2]
var uncommon_weapons : Array[int] = [13]
var rare_weapons : Array[int] = []
var epic_weapons : Array[int] = []
var legendary_weapons : Array[int] = []
#-=+=- WORK AREA END -=+=-

#Basic, Common, Uncommon, Rare, Epic, Legendary
var item_grade : String

#Description in inspector if it is a material
var material_description : String

#DONT TOUCH ANYTHING IN THIS FUNCTION
func _ready() -> void:
	#Assigning item grade
	if basic_materials.has(item_id):	item_grade = "Basic"
	elif common_materials.has(item_id) or common_weapons.has(item_id):	item_grade = "Common"
	elif uncommon_materials.has(item_id) or uncommon_weapons.has(item_id):	item_grade = "Uncommon"
	elif rare_materials.has(item_id) or rare_weapons.has(item_id):	item_grade = "Rare"
	elif epic_materials.has(item_id) or epic_weapons.has(item_id):	item_grade = "Epic"
	elif legendary_materials.has(item_id) or legendary_weapons.has(item_id):	item_grade = "Legendary"
	#if the max stack size is 1 it does not bother showing the current stack size
	if max_stack_size > 1:	%StackSize.visible = true
	#Display material description
	if not is_weapon:
		material_description = get_material_description(item_id)

#List of descriptions --- MAKE BORING ON PURPOSE, We will be auctioning off descriptions to fans of the game.
#-=+=- WORK AREA -=+=-
static func get_material_description(temp_id : int) -> String:
	var temp_desc : String = ""
	match temp_id:
		3:
			temp_desc = "Logs chopped from a tree."
		4:
			temp_desc = "Metal smelted from ore."
		5:
			temp_desc = "Woven from lots of string."
		6:
			temp_desc = "Unknown acidic liquid mixture."
		7:
			temp_desc = "Bones from an ethical source."
		8:
			temp_desc = "Plank of wood reinforced with steel."
		9:
			temp_desc = "Steel tipped arrow fletched with fabric."
		10:
			temp_desc = "A magical substance that is slightly viscous."
		11:
			temp_desc = "Leather that has been cured with chemicals."
		12:
			temp_desc = "Shiny ingot made of pure gold."
	return temp_desc
#-=+=- WORK AREA END -=+=-

#-=+=- DONT TOUCH ANYTHING BELOW THIS -=+=-
func _process(delta: float) -> void:
	
	%StackSize.text = str(current_stack_size)
	if recipe_item: return
	if on_mouse:
		var temp_array_int : Array[int] = []
		var temp_array_str : Array[String] = []
		inv_slots.get_parent().world_spawner.active_inspector.change_inspector(item_id, false, weapon_behavior, weapon_durability, weapon_stats, weapon_resistances, item_grade, material_description, temp_array_int, temp_array_str)
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
			var temp_occ_slot : Slot = inv_slots.get_parent().world_spawner.active_occupant.get_slot_hovering()
			if temp_occ_slot != null and temp_occ_slot.weapon_slot == is_weapon:
				if temp_occ_slot.item_held == null:
					parent_slot.item_held = null
					parent_slot = temp_occ_slot
					parent_slot.item_held = self
				else:
					if temp_occ_slot.item_held.item_id == item_id and temp_occ_slot != parent_slot:
						if temp_occ_slot.item_held.max_stack_size >= current_stack_size + temp_occ_slot.item_held.current_stack_size:
							parent_slot.item_held = null
							temp_occ_slot.item_held.current_stack_size += current_stack_size
							queue_free()
			if is_occupant:
				var temp_occupant_slot : Slot = inv_slots.get_parent().world_spawner.active_occupant.occupant_slot
				if temp_occupant_slot != null:
					if temp_occupant_slot.item_held == null:
						parent_slot.item_held = null
						parent_slot = temp_occupant_slot
						parent_slot.item_held = self
				var temp_occupant_slot2 : Slot = inv_slots.get_parent().world_spawner.active_arena.get_slot_hovering()
				if temp_occupant_slot2 != null:
					if temp_occupant_slot2.item_held == null:
						parent_slot.item_held = null
						parent_slot = temp_occupant_slot2
						parent_slot.item_held = self
			on_mouse = false
	else:
		global_position = parent_slot.global_position
