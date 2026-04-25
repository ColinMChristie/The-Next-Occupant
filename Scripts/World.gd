extends Node
class_name World

@export var inventory : PackedScene
@export var recipe_page : PackedScene
@export var blueprint_page : PackedScene
@export var inspector_page : PackedScene
@export var occupant_page : PackedScene
@export var arena_page : PackedScene

@export var hero_prefabs : Array[PackedScene]
var hero_list : Array[Hero]
var hero_spawn_list : Array[SpawnPoint]

var active_inventory : InvSlots
var active_recipe : RecipeSlots
var active_blueprint : BlueprintSlots
var active_inspector : InspectorSlots
var active_occupant : OccupantSlots
var active_arena : ArenaSlots
var active_spawn_point_holder : Node2D

var current_gold : int = 10
var bet_amount : int
var bet_alliance : bool

signal everything_spawned

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	add_inventory()
	add_recipe_page()
	add_blueprint_page()
	add_inspector_page()
	add_occupant_page()
	add_arena_page()
	everything_spawned.emit()
	get_spawn_points()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_fight() -> void:
	add_hero(0, true)
	add_hero(1, false)
	everything_spawned.emit()
	print(bet_amount)
	print(bet_alliance)

func add_inventory() -> void:
	var temp_page : FightPage = inventory.instantiate()
	temp_page.world_spawner = self
	%Pages.add_child(temp_page)

func add_recipe_page() -> void:
	var temp_page : FightPage = recipe_page.instantiate()
	temp_page.world_spawner = self
	%Pages.add_child(temp_page)

func add_blueprint_page() -> void:
	var temp_page : FightPage = blueprint_page.instantiate()
	temp_page.world_spawner = self
	%Pages.add_child(temp_page)

func add_inspector_page() -> void:
	var temp_page : FightPage = inspector_page.instantiate()
	temp_page.world_spawner = self
	%Pages.add_child(temp_page)

func add_occupant_page() -> void:
	var temp_page : FightPage = occupant_page.instantiate()
	temp_page.world_spawner = self
	%Pages.add_child(temp_page)

func add_arena_page() -> void:
	var temp_page : FightPage = arena_page.instantiate()
	temp_page.world_spawner = self
	%Pages.add_child(temp_page)

func add_hero(hero_num : int, alliance : bool) -> void:
	var temp_hero : Hero = hero_prefabs[hero_num].instantiate()
	temp_hero.world_spawner = self
	temp_hero.alliance = alliance
	temp_hero.affect_stats()
	hero_list.push_back(temp_hero)
	add_child(temp_hero)
	choose_spawn_point(temp_hero)

func get_spawn_points() -> void:
	var temp_list : Array[Node] = active_spawn_point_holder.get_children()
	for point in temp_list:
		if point is SpawnPoint:
			hero_spawn_list.push_back(point)

func choose_spawn_point(char : Character) -> void:
	var temp_spawn : SpawnPoint
	temp_spawn = hero_spawn_list[randi_range(0, hero_spawn_list.size() - 1)]
	hero_spawn_list.erase(temp_spawn)
	char.global_position = temp_spawn.global_position
