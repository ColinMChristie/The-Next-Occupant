extends Node
class_name BlueprintSlots

var weapon_blueprints : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_page() -> void:
	weapon_blueprints = not weapon_blueprints
	if weapon_blueprints:
		%SectionName.text = "Weapons & Armor"
	else:
		%SectionName.text = "Materials"
	%WeaponBlueprints.visible = weapon_blueprints
	%MaterialBlueprints.visible = not weapon_blueprints

func _on_right_arrow_pressed() -> void:
	change_page()

func _on_left_arrow_pressed() -> void:
	change_page()

func change_recipe(recipe_num) -> void:
	var temp_recipe_slots : RecipeSlots = get_parent().world_spawner.active_recipe
	for slot in temp_recipe_slots.slots:
		if slot.item_held != null:
			return
	temp_recipe_slots.change_recipe(recipe_num)
