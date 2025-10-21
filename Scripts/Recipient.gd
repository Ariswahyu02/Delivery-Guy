extends Area2D
signal package_delivered(correct: bool, delivered_color: int)

@export var fixed_color: ColorSets.ColorType = -1   # pilih di Inspector; -1 = tidak fixed
@onready var true_delivery: AudioStreamPlayer2D = $TrueDelivery
@onready var false_delivery: AudioStreamPlayer2D = $FalseDelivery

var desired_type: int = -1
var _pool: Array[int] = []

#@onready var want_rect: ColorRect = $ColorRect

func _ready() -> void:
	if fixed_color != -1:
		desired_type = fixed_color
		#want_rect.color = ColorSets.get_color(desired_type)

func randomize_desired(pool: Array[int]) -> void:
	_pool = pool
	if fixed_color == -1:
		desired_type = pool[randi() % pool.size()]
		#want_rect.color = ColorSets.get_color(desired_type)

func interact(player: Node) -> void:
	if not player.has_method("is_carrying"): return
	if not player.is_carrying():
		print("[Info] Player has no color.")
		emit_signal("package_delivered", false, -1)
		return

	var isSameAsRecipient: bool = player.carried_type == desired_type
	if isSameAsRecipient:
		print("[Deliver] Correct:", ColorSets.color_name(desired_type))
		true_delivery.play()
		player.clear_color()  # indikator player jadi transparan
		#if fixed_color == -1 and randomize_after_success and not _pool.is_empty():
			#randomize_desired(_pool)
	else:
		print("[Deliver] Wrong. Want=%s, Got=%s" % [
			ColorSets.color_name(desired_type),
			ColorSets.color_name(player.carried_type)
		])
		player.clear_color()
		false_delivery.play()
	emit_signal("package_delivered", isSameAsRecipient, player.carried_type)
