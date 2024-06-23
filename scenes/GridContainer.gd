extends GridContainer

@export var landProbobility : float = 30
var rng = RandomNumberGenerator.new()

func _ready():
	set_all_tiles()

func set_all_tiles():
	print(columns)
	for row in range(columns):
		for column in range(columns):
			var newTile :ColorRect = get_water_or_land()
			newTile.visible = true
			add_child(newTile)
			
func get_water_or_land():
	var percent = rng.randf_range(0, 100)
	if percent <= 30:
		return $LandTile.duplicate()
	else:
		return $WaterTile.duplicate()
