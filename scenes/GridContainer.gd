extends GridContainer

@export var landProbobility : float = 30
@export var shipProbobility : float = 30
var rng = RandomNumberGenerator.new()

func _ready():
	set_all_tiles()

func set_all_tiles():
	for x in range(columns):
		for y in range(columns):
			var newTile = get_water_or_land()
			newTile.name = str(x) + str(y)
			newTile.visible = true
			add_child(newTile)
			
func get_water_or_land():
	var percent = rng.randf_range(0, 100)
	if percent <= 30:
		percent = rng.randf_range(0, 100)
		if percent <= shipProbobility:
			return $ShipTile.duplicate()
		return $LandTile.duplicate()
	else:
		return $WaterTile.duplicate()
