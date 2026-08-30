extends Node
## Body memory. Recall Walk is unlabeled on purpose. Never print the sequence.

signal recall_completed

enum Stage { IDLE, BACK7, TURN_L, BACK3, TURN_R, CROUCH, RISE }

var stage: int = Stage.IDLE
var pace_count: int = 0
var last_pos: Vector3 = Vector3.ZERO
var last_yaw: float = 0.0
var stage_age: float = 0.0
var discovered: bool = false

func _ready() -> void:
	if FileAccess.file_exists("user://recall_found.flag"):
		discovered = true

func feed(pos: Vector3, yaw: float, moving_back: bool, crouched: bool, delta: float) -> void:
	stage_age += delta
	var dist := pos.distance_to(last_pos)
	var yaw_delta := _wrap(yaw - last_yaw)
	match stage:
		Stage.IDLE:
			if moving_back:
				stage = Stage.BACK7
				pace_count = 0
				stage_age = 0.0
		Stage.BACK7:
			if not moving_back:
				_reset()
			elif dist > 0.55:
				pace_count += 1
				last_pos = pos
				if pace_count >= 7:
					stage = Stage.TURN_L
					stage_age = 0.0
		Stage.TURN_L:
			if stage_age > 4.0:
				_reset()
			elif absf(yaw_delta) > 2.6:
				stage = Stage.BACK3
				pace_count = 0
				stage_age = 0.0
				last_yaw = yaw
		Stage.BACK3:
			if not moving_back:
				_reset()
			elif dist > 0.55:
				pace_count += 1
				last_pos = pos
				if pace_count >= 3:
					stage = Stage.TURN_R
					stage_age = 0.0
		Stage.TURN_R:
			if stage_age > 4.0:
				_reset()
			elif absf(yaw_delta) > 2.6:
				stage = Stage.CROUCH
				stage_age = 0.0
		Stage.CROUCH:
			if crouched:
				stage = Stage.RISE
				stage_age = 0.0
			elif stage_age > 8.0:
				_reset()
		Stage.RISE:
			if not crouched:
				_fire()
	if stage == Stage.IDLE:
		last_pos = pos
		last_yaw = yaw

func _fire() -> void:
	_reset()
	if not discovered:
		discovered = true
		var f := FileAccess.open("user://recall_found.flag", FileAccess.WRITE)
		if f:
			f.store_string("1")
		if has_node("/root/SecretBridge"):
			SecretBridge.report("recall_walk")
		if has_node("/root/Hope"):
			Hope.say("You already knew the way home.")
	if has_node("/root/LayerRouter"):
		LayerRouter.recall_to_subliminal()
	recall_completed.emit()

func _reset() -> void:
	stage = Stage.IDLE
	pace_count = 0
	stage_age = 0.0

func _wrap(a: float) -> float:
	while a > PI:
		a -= TAU
	while a < -PI:
		a += TAU
	return a
