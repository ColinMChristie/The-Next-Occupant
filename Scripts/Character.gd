extends Node
class_name Character

@export var character_class : String
@export var character_race : String
@export var character_quirks : Array[String]

@export var weapon_prefab : PackedScene

@export var character_sprite : AnimatedSprite2D

var world_spawner : World

var alliance : bool

var detection_range : float = 700.0
var lock_range : float = 500.0
var max_speed : float = 2000.0
var hp : int = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
