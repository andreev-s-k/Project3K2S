extends Node

var obstacle_block = preload("res://scenes/obstacle/obstacle_block.tscn")

var terrain_pool = []
var player
var flag = true
const columns_in_one_line = 8

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	
func check_obstacles():
	var for_delete = []
	for i in terrain_pool:
		if i.global_position.z >  int(player.global_position.z) + 40:
			for_delete.append(i)
	for i in for_delete:
		terrain_pool.erase(i)
		i.queue_free()

func create_obstacle(pos):
	var new_terrain_block = obstacle_block.instantiate()
	add_child(new_terrain_block)
	new_terrain_block.global_position.z = int(player.global_position.z) + -80
	
	new_terrain_block.global_position.y = randf_range(-0.5, 0)
	new_terrain_block.global_position.x = pos
	new_terrain_block.get_child(0).radius *= 0.94
	new_terrain_block.get_child(0).rotation += Vector3(0,0,randf_range(-0.1, 0.1))
	new_terrain_block.get_child(0).height *= randf_range(0.7, 4)
	terrain_pool.append(new_terrain_block)

func _on_obstacle_generator_timer_timeout() -> void:
	var available_pos = []
	for i in range(-5, 6):
		available_pos.append(i)
	for i in range(columns_in_one_line):
		var chosen_pos = available_pos.pick_random()
		available_pos.erase(chosen_pos)
		create_obstacle(chosen_pos)
	check_obstacles()
