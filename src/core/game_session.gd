extends Node
## Identity is four slides on the projector. Not 16,000 scenes.

signal identity_changed
signal saved

var sex: String = "male"
var race_id: String = "lumenari"
var frame_id: String = "skirmisher"
var mod_id: String = "centroid"
var player_id: String = ""

func _ready() -> void:
	player_id = _ensure_id()
	_load()

func identity() -> Dictionary:
	return {
		"sex": sex, "race": race_id, "frame": frame_id, "mod": mod_id,
		"player_id": player_id,
	}

func set_identity(s: String, r: String, f: String, m: String) -> void:
	sex = s
	race_id = r
	frame_id = f
	mod_id = m
	identity_changed.emit()
	persist()

func persist() -> void:
	var f := FileAccess.open("user://session.json", FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify(identity()))
	saved.emit()

func _load() -> void:
	if not FileAccess.file_exists("user://session.json"):
		return
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string("user://session.json"))
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	var d: Dictionary = parsed
	sex = str(d.get("sex", sex))
	race_id = str(d.get("race", race_id))
	frame_id = str(d.get("frame", frame_id))
	mod_id = str(d.get("mod", mod_id))

func _ensure_id() -> String:
	if FileAccess.file_exists("user://player_id.txt"):
		return FileAccess.get_file_as_string("user://player_id.txt").strip_edges()
	var id := "ph_%s" % str(Time.get_unix_time_from_system()).sha256_text().substr(0, 12)
	var f := FileAccess.open("user://player_id.txt", FileAccess.WRITE)
	if f:
		f.store_string(id)
	return id
