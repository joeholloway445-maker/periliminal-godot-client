extends CharacterBody3D
## Sparse crowd. Dialogue from archetype x layer, then WordOfMouth.

var npc_id: String = ""
var archetype: String = "reflection"
var spoken: bool = false

func setup(id: String, arch: String, pos: Vector3) -> void:
	npc_id = id
	archetype = arch
	position = pos
	var mesh := MeshInstance3D.new()
	var cap := CapsuleMesh.new()
	cap.radius = 0.28
	cap.height = 1.6
	mesh.mesh = cap
	var mat := StandardMaterial3D.new()
	mat.albedo_color = _tint(arch)
	mesh.material_override = mat
	add_child(mesh)
	var col := CollisionShape3D.new()
	var shape := CapsuleShape3D.new()
	shape.radius = 0.28
	shape.height = 1.6
	col.shape = shape
	add_child(col)

func talk() -> void:
	var line := WordOfMouth.greeting(npc_id, archetype)
	Hope.say(line)
	WordOfMouth.hear(npc_id, "spoke on %s" % LayerRouter.current)
	Consistency.record_deed("witness")
	spoken = true

func _tint(arch: String) -> Color:
	match arch:
		"barista":
			return Color(0.72, 0.48, 0.32)
		"archivist":
			return Color(0.42, 0.48, 0.62)
		"authority":
			return Color(0.28, 0.30, 0.34)
		"lover":
			return Color(0.62, 0.36, 0.44)
		_:
			return Color(0.50, 0.52, 0.48)
