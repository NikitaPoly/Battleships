extends GridMap

@export var grid_size: Vector3 = Vector3(10, 1, 20)
var chanceOfLand = .25

func _ready():
	randomize()  # Seed the random number generator

	# Loop through each cell in the grid
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			for z in range(grid_size.z):
				# Randomly select a block type from the library
				var random_block_type_index = randf()
				if(random_block_type_index <=chanceOfLand):
				# Set the block at the specified grid position
					set_cell_item(Vector3(x,y,z),1)
				else:
					set_cell_item(Vector3(x,y,z),0)
