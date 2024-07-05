extends GridContainer

@export var landChance:float = .25

# Called when the node enters the scene tree for the first time.
func _ready():
	create_map()
	_populate_2d_map()
	_tets()

func _tets():
	var file = "res://FleetStats/TESTFLEET.json"
	var data_file = FileAccess.open(file,FileAccess.READ)
	var parsed = JSON.parse_string(data_file.get_as_text())
	print(parsed)
	
func create_map():
	randomize() 
	for x in range(Global.MAPSIZE_X):
		var currentRow = []
		for z in range(Global.MAPSIZE_Z):
			var random_block_type_index = randf()
			if random_block_type_index <= landChance:
				currentRow.append(1)
			else:
				currentRow.append(0)
		Global.mapTerrain.append(currentRow)
	#generatebase
	Global.mapTerrain[0][int((Global.MAPSIZE_Z - 1)/2)] = 3
	Global.mapTerrain[0][int((Global.MAPSIZE_Z - 1 )/2)+1] = 3
		
	Global.mapTerrain[int(Global.MAPSIZE_X) - 1][int((Global.MAPSIZE_Z - 1)/2)] =3
	Global.mapTerrain[int(Global.MAPSIZE_X) - 1][int((Global.MAPSIZE_Z - 1)/2)+1] = 3
		


func _populate_2d_map():
	columns = Global.MAPSIZE_Z
	for x in range(Global.MAPSIZE_X):
		for z in range(Global.MAPSIZE_Z):
			var newTile = get_child(Global.mapTerrain[x][z]).duplicate()
			newTile.name = str(x) +","+ str(z)
			newTile.visible = true
			add_child(newTile)
