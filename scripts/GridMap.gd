extends GridMap

@export var grid_size: Vector3 = Vector3(10, 1, 20)
var chanceOfLand = .25
var actionSelected: String
const RAY_LENGTH = 100

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		if actionSelected == "delete":
			delete_block_under_mouse()

func _ready():
	randomize()  # Seed the random number generator

	# Loop through each cell in the grid
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			for z in range(grid_size.z):
				# Randomly select a block type from the library
				var random_block_type_index = randf()
				if random_block_type_index <= chanceOfLand:
					# Set the block at the specified grid position
					set_cell_item(Vector3(x, y, z), 1)
				else:
					set_cell_item(Vector3(x, y, z), 0)
				# Add collision shape and debug outline for the block
				add_collision_shape(Vector3(x, y, z))

func _on_button_delete_block_pressed():
	print("Delete button")
	actionSelected = "delete"

func _on_button_effect_pressed():
	print("Effect button")
	actionSelected = "effect"

func delete_block_under_mouse():
	var camera =$"../PlayerCamera" 
	if not camera:
		return
	
	var mouse_position = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_position)
	var to = from + camera.project_ray_normal(mouse_position) * RAY_LENGTH

	print("Ray from: ", from)
	print("Ray to: ", to)

	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	#ray_query.collision_mask = 1  # Adjust the collision mask if necessary

	var space_state = get_world_3d().direct_space_state
	var result = space_state.intersect_ray(ray_query)

	print("Raycast result: ", result)

	if result and result.has("position"):
		var cell = local_to_map(result.position)
		print("Deleting cell at: ", cell)
		set_cell_item(cell, -1)  # Remove the block
		# The children (collision shape and outline) will be deleted automatically
		get_node(str(cell)).queue_free()
		
	else:
		print("No collision detected")

func add_collision_shape(cell_position: Vector3):
	var static_body = StaticBody3D.new()
	static_body.name = str(cell_position)
	var collision_shape = CollisionShape3D.new()
	# Assuming a box shape, you can adjust the size according to your block size
	var box_shape = BoxShape3D.new()
	box_shape.size = Vector3(1.9, 1.9, 1.9)  # Adjust the size if necessary
	collision_shape.shape = box_shape
	static_body.add_child(collision_shape)
	static_body.transform.origin = map_to_local(cell_position)
	add_child(static_body)
