extends GridMap

@export var grid_size: Vector3 = Vector3(10, 1, 20)
@export var chanceOfLand = .25
var actionSelected: String
const RAY_LENGTH:int = 100
const HIT_BOX_SIZE:Vector3= Vector3(1.9, 1.9, 1.9)

@onready var  camera =$"../PlayerCamera"


func _ready():
	_populate_map()
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		if actionSelected == "delete":
			delete_block_under_mouse()
		elif actionSelected == "effect":
			pass

func _on_button_effect_pressed():
	print("Effect button")
	actionSelected = "effect"

func delete_block_under_mouse():
	
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

func _on_button_delete_block_pressed():
	print("Delete button")
	actionSelected = "delete"

func _populate_map():
	for x in range(Global.MAPSIZE_X):
		for z in range(Global.MAPSIZE_Z):
			if Global.mapTerrain[x][z] == 2:
				#ship
				set_cell_item(Vector3( x,1,Global.MAPSIZE_Z - z),Global.mapTerrain[x][z])
				add_collision_shape(Vector3( x,1,Global.MAPSIZE_Z -z))
				#water terrain
				set_cell_item(Vector3( x,0,Global.MAPSIZE_Z - z),0)
				add_collision_shape(Vector3( x,0,Global.MAPSIZE_Z -z))
			elif Global.mapTerrain[x][z] == 3:
				#base
				set_cell_item(Vector3( x,1,Global.MAPSIZE_Z - z),Global.mapTerrain[x][z])
				add_collision_shape(Vector3( x,1,Global.MAPSIZE_Z -z))
				#water terrain
				set_cell_item(Vector3( x,0,Global.MAPSIZE_Z - z),1)
				add_collision_shape(Vector3( x,0,Global.MAPSIZE_Z -z))
			else:
				set_cell_item(Vector3( x,0,Global.MAPSIZE_Z - z),Global.mapTerrain[x][z])
				add_collision_shape(Vector3( x,0,Global.MAPSIZE_Z -z))

func add_collision_shape(cell_position: Vector3):
	var static_body = StaticBody3D.new()
	static_body.name = str(cell_position)
	var collision_shape = CollisionShape3D.new()
	# Assuming a box shape, you can adjust the size according to your block size
	var box_shape = BoxShape3D.new()
	box_shape.size =  HIT_BOX_SIZE # Adjust the size if necessary
	collision_shape.shape = box_shape
	static_body.add_child(collision_shape)
	static_body.transform.origin = map_to_local(cell_position)
	add_child(static_body)




