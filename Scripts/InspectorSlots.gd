extends Node
class_name InspectorSlots

var item_prefab_list : Array[PackedScene]
@export var behavior_image_list : Array[CompressedTexture2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Sets the world spawner's pointer to this script
	get_parent().world_spawner.active_inspector = self
	#Gets the item prefab list from another world spawner pointer
	item_prefab_list = get_parent().world_spawner.active_inventory.item_prefab_list
	#Sets the inpector starting state by calling the function manually
	change_inspector(1, false, "Blind", 100, [2,1,3,0,0,0], [-15, 15], "", "", [], [])

#Spawns a useless item in the inspector container
func spawn_item(item_num : int, stack_size : int) -> bool:
	for child in %ItemContainer.get_children():
		child.queue_free()
	var temp_item : Item = item_prefab_list[item_num-1].instantiate()
	temp_item.recipe_item = true
	temp_item.z_index = 1
	temp_item.current_stack_size = stack_size
	%ItemContainer.add_child(temp_item)
	if item_num > 1000:
		temp_item.global_position += Vector2(-16, -16)
	return temp_item.is_weapon

#Called elsewhere to change the inspector based on something being clicked.
func change_inspector(item_num : int, is_recipe : bool, weapon_behavior : String, weapon_durability : int, weapon_stats : Array[int], weapon_resistances : Array[int], material_grade : String, material_description : String, behavior_keys : Array[int], behavior_indexes : Array[String]) -> void:
	var is_weapon : bool = spawn_item(item_num, 1)
	match item_num:
		#-=+=- WORK AREA -=+=-
		1:
			%ItemName.text = "Common Crossbow"
		2:
			%ItemName.text = "Common Fire Book"
		3:
			%ItemName.text = "Wood"
		4:
			%ItemName.text = "Steel"
		5:
			%ItemName.text = "Fabric"
		6:
			%ItemName.text = "Chemicals"
		7:
			%ItemName.text = "Bones"
		8:
			%ItemName.text = "Reinforced Plank"
		9:
			%ItemName.text = "Arrow"
		10:
			%ItemName.text = "Magic Goo"
		11:
			%ItemName.text = "Leather"
		12:
			%ItemName.text = "Gold Ingot"
		13:
			%ItemName.text = "Uncommon Crossbow"
		14: 
			%ItemName.text = "Essence of Fire"
		15:
			%ItemName.text = "Uncommon Fire Book"
		16:
			%ItemName.text = "Planks"
		17:
			%ItemName.text = "Metal plate"
		18:
			%ItemName.text = "Nail"
		19:
			%ItemName.text = "Bone dust"
		20:
			%ItemName.text = "Linen"
		21:
			%ItemName.text = "Rare Firebook"
		22:
			%ItemName.text = "Epic Firebook"
		23:
			%ItemName.text = "Legendary Firebook"
		24:
			%ItemName.text = "Rare Crossbow"
		25:
			%ItemName.text = "Epic Crossbow"
		26:
			%ItemName.text = "Legendary Crossbow"
		1001:
			%ItemName.text = "\nArcher"
		1002:
			%ItemName.text = "\nFire Wizard"
		#-=+=- WORK AREA END -=+=-
	#Define behavior of the inspector based on what is clicked on
	if is_recipe and is_weapon:
		set_behavior_visibility(3, weapon_behavior, weapon_durability, weapon_stats, weapon_resistances, material_grade, material_description, behavior_keys, behavior_indexes)
	elif is_recipe:
		set_behavior_visibility(4, weapon_behavior, weapon_durability, weapon_stats, weapon_resistances, material_grade, material_description, behavior_keys, behavior_indexes)
	elif is_weapon:
		set_behavior_visibility(1, weapon_behavior, weapon_durability, weapon_stats, weapon_resistances, material_grade, material_description, behavior_keys, behavior_indexes)
	else:
		set_behavior_visibility(2, weapon_behavior, weapon_durability, weapon_stats, weapon_resistances, material_grade, material_description, behavior_keys, behavior_indexes)

#Sets the inspector behavior based on what it is told to do by the previous function
func set_behavior_visibility(vis : int, wb : String, wd : int, ws : Array[int], wr : Array[int], mg : String, md : String, bk : Array[int], bi : Array[String]) -> void:
	match vis:
		1:
			%Weapon.visible = true
			%Material.visible = false
			%Recipe.visible = false
			%WeaponBehaviorName.text = wb
			%WeaponBehaviorIcon.texture = match_behavior_image(wb)
			%WeaponDesc.visible = true
			%MaterialDesc.visible = false
			%RecipeDesc.visible = false
			%WeaponDurability.text = "Durability: " + str(wd) + "/100"
			%WeaponStrength.text = "Strength: " + str(ws[0])
			%WeaponDexterity.text = "Dexterity: " + str(ws[1])
			%WeaponConstitution.text = "Constitution: " + str(ws[2])
			%WeaponAgility.text ="Agility: " + str(ws[3])
			%WeaponIntelligence.text = "Intelligence: " + str(ws[4])
			%WeaponWill.text = "Will: " + str(ws[5])
			%WeaponResistances.text = "Resistances:\nFire: " + str(wr[0]) + "\nIce: " + str(wr[1])
		2:
			%Weapon.visible = false
			%Material.visible = true
			%Recipe.visible = false
			%MaterialItemDescription.text = mg + "\nMaterial"
			%WeaponDesc.visible = false
			%MaterialDesc.visible = true
			%RecipeDesc.visible = false
			%MaterialDescDescription.text = md
		3:
			%Weapon.visible = false
			%Material.visible = false
			%Recipe.visible = true
			%WeaponDesc.visible = false
			%MaterialDesc.visible = false
			%RecipeDesc.visible = true
			%RecipeIcon1.texture = match_behavior_image(bi[0])
			%RecipeIcon2.texture = match_behavior_image(bi[1])
			%RecipeIcon3.texture = match_behavior_image(bi[2])
			%RecipeIcon4.texture = match_behavior_image(bi[3])
			%RecipeDescName1.text = bi[0] + ": " + str(bk[0]) + "% Chance"
			%RecipeDescName1.text = bi[1] + ": " + str(bk[1]) + "% Chance"
			%RecipeDescName1.text = bi[2] + ": " + str(bk[2]) + "% Chance"
			%RecipeDescName1.text = bi[3] + ": " + str(bk[3]) + "% Chance"
		4:
			%Weapon.visible = false
			%Material.visible = false
			%Recipe.visible = true
			%WeaponDesc.visible = false
			%MaterialDesc.visible = true
			%RecipeDesc.visible = false
			%MaterialDescDescription.text = md

#Match behavior image with the textures in the list, use this to implement more behaviors
func match_behavior_image(behavior_string : String) -> CompressedTexture2D:
	match behavior_string:
		"Blind":
			return behavior_image_list[0]
	return null
