extends Node3D

@onready var player: CharacterBody3D = $Player
@onready var hud: Label = $HUD/Status
@onready var hope_lbl: Label = $HUD/HopeLine
@onready var env: WorldEnvironment = $WorldEnvironment

func _ready() -> void:
	Hope.spoke.connect(func(t): hope_lbl.text = "HOPE  " + t)
	hope_lbl.text = "HOPE  " + Hope.last_line
	LayerRouter.layer_changed.connect(func(_f, _t): _paint())
	_paint()
	_spawn_props()

func _process(_d: float) -> void:
	var lens := OmniDexTables.compose(Session.sex, Session.race_id, Session.frame_id, Session.mod_id)
	hud.text = "%s  |  %s  |  stance %s  |  coins %d chips %d prestige %d  |  party %d/3  |  wander %.0fs/%.0fs" % [
		str(LayerRouter.info().get("name", LayerRouter.current)),
		lens.get("label", ""),
		Consistency.stance,
		Wallet.coins, Wallet.chips, Wallet.prestige,
		Party.bound.size(),
		LayerRouter.wander_s, LayerRouter.pull_threshold,
	]

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		_use()
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_1:
				LayerRouter.enter("subliminal", "dev")
			KEY_2:
				LayerRouter.enter("liminal", "dev")
			KEY_3:
				LayerRouter.enter("supraliminal", "dev")
			KEY_4:
				LayerRouter.enter("hyperliminal", "dev")
			KEY_5:
				LayerRouter.enter("extraliminal", "dev")
			KEY_6:
				LayerRouter.enter("periliminal", "dev")
			KEY_H:
				Consistency.record_deed("help")
			KEY_G:
				Consistency.record_deed("attack")
			KEY_C:
				if LayerRouter.current == "hyperliminal":
					if Wallet.chips < 5:
						Wallet.coins_to_chips(20)
					CasinoBridge.request_ticket("slots", 5)
			KEY_V:
				VoteBridge.cast("toe_spine_01", "sovereign_crown")

func _use() -> void:
	match LayerRouter.current:
		"subliminal":
			LayerRouter.enter("liminal", "door")
		"liminal":
			LayerRouter.enter("supraliminal", "arch")
		"supraliminal":
			LayerRouter.enter("liminal", "hidden")
		"hyperliminal":
			if Wallet.chips < 5:
				Wallet.coins_to_chips(20)
			CasinoBridge.request_ticket("slots", 5)
		"extraliminal":
			LayerRouter.enter("liminal", "guild_door")
		"periliminal":
			LayerRouter.blessing_exit()

func _paint() -> void:
	var sky := env.environment
	if sky:
		sky.background_mode = Environment.BG_COLOR
		sky.background_color = LayerRouter.fog()
		sky.ambient_light_color = LayerRouter.fog().lightened(0.2)
		sky.fog_enabled = true
		sky.fog_light_color = LayerRouter.fog()

func _spawn_props() -> void:
	for i in range(8):
		var mesh := MeshInstance3D.new()
		var box := BoxMesh.new()
		box.size = Vector3(1.4, 2.2, 1.4)
		mesh.mesh = box
		mesh.position = Vector3(sin(i) * 10.0, 1.1, cos(i) * 10.0)
		add_child(mesh)
		var body := StaticBody3D.new()
		var col := CollisionShape3D.new()
		var shape := BoxShape3D.new()
		shape.size = Vector3(1.4, 2.2, 1.4)
		col.shape = shape
		body.add_child(col)
		mesh.add_child(body)
