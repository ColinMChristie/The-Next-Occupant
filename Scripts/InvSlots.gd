extends Node
class_name InvSlots

@export var slots : Array[Slot]
@export var item_prefab_list : Array[PackedScene]
var item_list_str : Array[String] = ["0|0|0|0|0|0|0|0|0|0|0|0|0|0|1,1|0|0|0|0|0|0|2,1|0|0|0|0|0|0|0|0|0|0|0|0|0", "3,5|4,5|5,5|6,5|7,5|8,1|9,1|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0"]
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
			temp_item.inv_slots = self
			temp_item.parent_slot = slots[i]
			temp_item.global_position = slots[i].global_position
			slots[i].item_held = temp_item
			temp_item.z_index = 1

func parse_items_for_string(page_num : int) -> void:
	var temp_string : String = ""
	for slot in slots:
		if slot.item_held != null:
			temp_string += str(slot.item_held.item_id) + "," + str(slot.item_held.current_stack_size) + "|"
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
