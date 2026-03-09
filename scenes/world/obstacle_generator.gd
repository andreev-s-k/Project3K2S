extends Node

var obstacle_block = preload("res://scenes/obstacle/obstacle_block.tscn")

var terrain_pool = []
var player
var flag = true
const columns_in_one_line = 2
const distance_between_obstacles = 20
const obstacle_limit = 30
var next_obstacle_pos_z

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	next_obstacle_pos_z = int(player.global_position.z) + -20
	for i in range(5): _on_obstacle_generator_timer_timeout()
func check_obstacles():
	var for_delete = []
	for i in terrain_pool:
		if i.global_position.z >  int(player.global_position.z) + 4:
			for_delete.append(i)
	for i in for_delete:
		terrain_pool.erase(i)
		i.queue_free()

func _on_obstacle_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.finish_game()

func _process(delta: float) -> void:
	if int(player.global_position.z) % distance_between_obstacles == 0:
		_on_obstacle_generator_timer_timeout()

func create_obstacle(pos):
	for i in [-1,0,1]:
		var new_terrain_block = obstacle_block.instantiate()
		add_child(new_terrain_block)
		new_terrain_block.global_position.z = next_obstacle_pos_z
		
		new_terrain_block.global_position.y = randf_range(-0.5, 0)
		new_terrain_block.global_position.x = pos + i
		new_terrain_block.get_child(0).radius *= randf_range(1.5, 2)
		new_terrain_block.get_child(0).rotation += Vector3(0,0,randf_range(-0.2, 0.2))
		new_terrain_block.get_child(0).height *= randf_range(0.7, 2)
		
		var area = new_terrain_block.get_node_or_null("Area3D") as Area3D
		if area:
			area.body_entered.connect(_on_obstacle_area_body_entered)
		
		terrain_pool.append(new_terrain_block)

func _on_obstacle_generator_timer_timeout() -> void:
	check_obstacles()
	if obstacle_limit <= terrain_pool.size(): return
	var available_pos = [-3, 0, 3]
	for i in range(columns_in_one_line):
		var chosen_pos = available_pos.pick_random()
		available_pos.erase(chosen_pos)
		create_obstacle(chosen_pos)
	
	next_obstacle_pos_z -= distance_between_obstacles
