extends Camera3D

@export var zoom_speed: float = 10.0
@export var move_speed: float = 10.0
@export var rotation_speed: float = 0.005

var is_right_clicking = false
var is_left_clicking = false
var last_mouse_pos = Vector2()

func _ready():
	set_process_input(true)
	set_process(true)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_in()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_out()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				is_right_clicking = true
				last_mouse_pos = event.position
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			else:
				is_right_clicking = false
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		elif event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_left_clicking = true
				last_mouse_pos = event.position
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			else:
				is_left_clicking = false
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	elif event is InputEventMouseMotion:
		var mouse_delta = event.relative
		if is_right_clicking:
			rotate_camera(mouse_delta)
		elif is_left_clicking:
			pan_camera(mouse_delta)

func _process(delta):
	var movement = Vector3()
	
	if Input.is_action_pressed("pan_up"):
		movement += Vector3(0, 0, -1)
	if Input.is_action_pressed("pan_down"):
		movement += Vector3(0, 0, 1)
	if Input.is_action_pressed("pan_left"):
		movement += Vector3(-1, 0, 0)
	if Input.is_action_pressed("pan_right"):
		movement += Vector3(1, 0, 0)

	if movement != Vector3():
		pan_camera_keyboard(movement * delta * move_speed)

func zoom_in():
	translate(Vector3(0, 0, -zoom_speed * get_process_delta_time()))

func zoom_out():
	translate(Vector3(0, 0, zoom_speed * get_process_delta_time()))

func rotate_camera(mouse_delta):
	# Apply yaw rotation around the y-axis
	var yaw = -mouse_delta.x * rotation_speed
	rotate_y(yaw)
	
	# Apply pitch rotation around the x-axis
	var pitch = -mouse_delta.y * rotation_speed * 100
	var new_rotation = rotation_degrees + Vector3(pitch, 0, 0)
	new_rotation.x = clamp(new_rotation.x, -90, 90) # Prevent flipping
	rotation_degrees = new_rotation

func pan_camera(mouse_delta):
	var pan_amount = Vector3(-mouse_delta.x, mouse_delta.y, 0) * move_speed * get_process_delta_time()
	translate(pan_amount)

func pan_camera_keyboard(movement):
	translate(movement)
