extends Node
class_name InvSlots

@export var slots : Array[Slot]
@export var item_prefab_list : Array[PackedScene]
var item_list_str : Array[String] = ["1,1,100,Blind,2.1.3.1.1.2,-15.15|2,1,100,Blind,1.1.1.2.3.2,15.-15|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0", "3,10|4,10|5,10|6,10|7,10|3,10|4,10|5,10|6,10|7,10|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0"]
var current_page : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().world_spawner.active_inventory = self
	parse_string_for_items(item_list_str[0])
	change_is_weapon(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_is_weapon(weapon : bool) -> void:
	for slot in slots:
		slot.weapon_slot = weapon

func get_slot_hovering() -> Slot:
	for slot in slots:
		if slot.mouse_hovering:
			return slot
	return null

func parse_string_for_items(item_list : String) -> void:
	var item_nums = item_list.split("|")
	for i in range(item_nums.size() - 1):
		var temp_pair = item_nums[i].split(",")
		if int(temp_pair[0]) > 0:
			var temp_item : Item = item_prefab_list[int(temp_pair[0]) - 1].instantiate()
			%InvSlots.add_child(temp_item)
			temp_item.current_stack_size = int(temp_pair[1])
			if temp_pair.size() > 2:
				temp_item.weapon_durability = int(temp_pair[2])
				temp_item.weapon_behavior = temp_pair[3]
				var temp_stat_str = temp_pair[4].split(".")
				for j in range(temp_stat_str.size()):
					temp_item.weapon_stats[j] = int(temp_stat_str[j])
				var temp_resist_str = temp_pair[5].split(".")
				for k in range(temp_resist_str.size()):
					temp_item.weapon_resistances[k] = int(temp_resist_str[k])
			temp_item.inv_slots = self
			temp_item.parent_slot = slots[i]
			temp_item.global_position = slots[i].global_position
			slots[i].item_held = temp_item
			temp_item.z_index = 1

func parse_items_for_string(page_num : int) -> void:
	var temp_string : String = ""
	for slot in slots:
		if slot.item_held != null:
			temp_string += str(slot.item_held.item_id) + "," + str(slot.item_held.current_stack_size)
			if slot.item_held.is_weapon:
				temp_string += "," + str(slot.item_held.weapon_durability) + "," + slot.item_held.weapon_behavior + ","
				for i in range(6):
					temp_string += str(slot.item_held.weapon_stats[i]) 
					if i < 5:
						temp_string += "."
				temp_string += ","
				for i in range(slot.item_held.weapon_resistances.size()):
					temp_string += str(slot.item_held.weapon_resistances[i])
					if i < slot.item_held.weapon_resistances.size() - 1:
						temp_string += "."
			temp_string += "|"
			slot.item_held.queue_free()
			slot.item_held = null
		else:
			temp_string += "0|"
	item_list_str[page_num] = temp_string

func match_page_title(page_num : int) -> void:
	match page_num:
		0:
			%SectionName.text = "Weapons & Armor"
			change_is_weapon(true)
		1:
			%SectionName.text = "Materials"
			change_is_weapon(false)

func _on_right_arrow_pressed() -> void:
	parse_items_for_string(current_page)
	if current_page == item_list_str.size() - 1:
		current_page = 0
	else:
		current_page += 1
	match_page_title(current_page)
	parse_string_for_items(item_list_str[current_page])


func _on_left_arrow_pressed() -> void:
	parse_items_for_string(current_page)
	if current_page == 0:
		current_page = item_list_str.size() - 1
	else:
		current_page -= 1
	match_page_title(current_page)
	parse_string_for_items(item_list_str[current_page])
