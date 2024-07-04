extends Button



var BattleScene = "res://scenes/BattleScene.tscn"

func _on_pressed():
	var result = get_tree().change_scene_to_file(BattleScene)
	if result != OK:
		print("Error changing scene: ", result)
