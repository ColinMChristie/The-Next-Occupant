extends Character
class_name Hero

@export var body : RigidBody2D
var weapon : Weapon
var ranged : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_matching_weapon()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	detect_objects()

func detect_objects() -> void:
	var temp_enemies : Array[Hero] = world_spawner.hero_list
	var closest_dist : int = lock_range
	var current_locked : Hero = null
	for enemy in temp_enemies:
		if enemy == self: continue
		var temp_dist : Vector2 = enemy.global_position - self.global_position
		var total_dist : float = sqrt(pow(temp_dist.x, 2) + pow(temp_dist.y, 2))
		if total_dist <= detection_range:
			body.apply_central_force(temp_dist.normalized() * max_speed / total_dist)
			body.rotation = body.linear_velocity.angle()
		if total_dist <= closest_dist:
			closest_dist = total_dist
			current_locked = enemy
	if not current_locked == null:
		body.look_at(current_locked.global_position)

func affect_stats() -> void:
	if alliance:
		# This is an Alliance
		body.set_collision_layer_value(1, true)
		body.set_collision_layer_value(2, false)# Clear enemy projectile layer
		# SCAN for Enemies (Layer 2)
		body.set_collision_mask_value(2, true)
		body.set_collision_mask_value(1, false) # IGNORE Hero (Layer 1)
	else:
		# This is an Enemy
		body.set_collision_layer_value(2, true)
		body.set_collision_layer_value(1, false) # Clear alliance projectile layer
			
		# SCAN for Hero/Alliance (Layer 1)
		body.set_collision_mask_value(1, true)
		body.set_collision_mask_value(2, false) # IGNORE other Enemies (Layer 2)

func spawn_matching_weapon() -> void:
	character_sprite.play("default")
	weapon = weapon_prefab.instantiate()
	body.add_child(weapon)
	ranged = weapon.projectile_based

func fire_weapon() -> void:
	if weapon.projectile_based:
		character_sprite.play("fired")
		await character_sprite.animation_finished
		weapon.fire_bolt(body.global_transform.x, self)
		character_sprite.play("reload")
		await character_sprite.animation_finished
		character_sprite.play("default")


func _on_fire_timer_timeout() -> void:
	fire_weapon()
