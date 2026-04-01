extends NinePatchRect
class_name FightPage

var world_spawner : World

var bet : int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_fight(ba : bool) -> void:
	world_spawner.bet_amount = bet
	world_spawner.bet_alliance = ba
	world_spawner.spawn_fight()
	self.queue_free()
