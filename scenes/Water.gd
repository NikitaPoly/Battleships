extends ColorRect


func _on_gui_input(event:InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var t = String(name)
		print(t)
		var comma_index = t.find(",")
		var length = t.length()
		var x :int
		var z :int
		if comma_index == 1:
			x = int(t[0])
			if length == 3:
				z = int(t[2])
			else:
				z = int(t[2] + t[3])
		else:
			x = int(t[0] + t[1])
			if length == 4:
				z = int(t[3])
			else:
				z = int(t[3] + t[4])
		print(x,z)
		Global.mapTerrain[x][z] = 2
		color = Color(0,0,0,1)
