extends Node

var terrain_block = preload("res://scenes/world/terrain_block.tscn")

var terrain_pool = []
var player
var flag = true
const obstacle_limit = 10

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	for i in range(10):
		_on_terrain_generator_timer_timeout()
	
func _process(delta: float) -> void:
	if int(player.global_position.z) % 10 == 0 and flag:
		flag = false
		check_player_position()
	else:
		flag = true
	
func check_player_position():
	for i in terrain_pool.duplicate():
		#print(int(player.global_position.z) / 10)
		i.global_position.z = int(player.global_position.z) + -10 * i.get_index()

func _on_terrain_generator_timer_timeout() -> void:
	if obstacle_limit <= get_children().size(): return
	
	var new_terrain_block = terrain_block.instantiate()
	add_child(new_terrain_block)
	new_terrain_block.global_position.z = -10 * new_terrain_block.get_index()
	terrain_pool.append(new_terrain_block)
