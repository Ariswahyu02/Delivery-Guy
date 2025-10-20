extends Area2D

var _pool: Array[int] = []
var _current_type: int = -1
@onready var indicator: ColorRect = $ColorRect   # ganti path sesuai node-mu

func set_colors(cs: Array[int]) -> void:
	_pool = cs.duplicate()
	_roll_next()
	_refresh_indicator()

func interact(player: Node) -> void:
	# TIDAK ada pengecekan kecocokan di truck.
	if not player.has_method("is_carrying"):
		return
	if player.is_carrying():
		# Player sudah membawa warna → truck tidak memberi warna baru.
		print("[Truck] Player already carrying:", ColorSets.color_name(player.carried_type))
		return
	if _current_type == -1:
		print("[Truck] No color queued")
		return

	# Beri warna saat ini ke player
	player.set_color(_current_type)
	print("[Truck] Give:", ColorSets.color_name(_current_type))

	# Antrikan warna berikutnya dan update indikator
	_roll_next()
	_refresh_indicator()

func _roll_next() -> void:
	_current_type = -1 if _pool.is_empty() else _pool[randi() % _pool.size()]

func _refresh_indicator() -> void:
	if indicator and _current_type != -1:
		indicator.color = ColorSets.get_color(_current_type)
		indicator.color.a = 1.0
