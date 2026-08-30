extends CharacterBody3D
## Meat only. Stats come from OmniDex compose.

var yaw := 0.0
var pitch := 0.15
@onready var cam: Camera3D = $Camera3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	var lens := OmniDexTables.compose(Session.sex, Session.race_id, Session.frame_id, Session.mod_id)
	var speed := float(lens.get("speed", 8.0))
	var wish := Vector3(
		Input.get_axis("move_left", "move_right"),
		0.0,
		Input.get_axis("move_forward", "move_back")
	)
	wish = (Basis(Vector3.UP, yaw) * wish)
	if wish.length() > 1.0:
		wish = wish.normalized()
	velocity.x = wish.x * speed
	velocity.z = wish.z * speed
	if not is_on_floor():
		velocity.y -= LayerRouter.gravity() * delta
	elif Input.is_action_just_pressed("ui_accept"):
		velocity.y = 7.4
	move_and_slide()
	if cam:
		cam.rotation.x = -pitch
		rotation.y = yaw

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		yaw -= event.relative.x * 0.0024
		pitch = clampf(pitch + event.relative.y * 0.002, -1.2, 0.6)
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event.is_action_pressed("attack"):
		Consistency.record_deed("attack")
		if Party.slots_free() > 0 and randf() < 0.25:
			Party.bind("shade_%d" % Party.bound.size(), "Bound Shade")
			Hope.say("It yielded. Slot taken.")
