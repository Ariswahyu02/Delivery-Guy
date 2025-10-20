extends CharacterBody2D

@export var speed: float = 220.0
var carried_type: int = -1  # -1 = tidak membawa warna

@onready var interact_area: Area2D = $"Interact Detect"
@onready var carry_rect: ColorRect = $ColorRect
const EMPTY_COLOR := Color(1,1,1,0)

func _ready() -> void:
	carry_rect.color = EMPTY_COLOR

func _physics_process(delta: float) -> void:
	var dir := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		0
	)
	velocity = dir.normalized() * speed
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact_color"):
		_try_interact()

func _try_interact() -> void:
	var areas := interact_area.get_overlapping_areas()
	if areas.is_empty():
		print("[Player] No areas in range")
		return
	for area in areas:
		if area.has_method("interact"):
			area.interact(self)
			return

func is_carrying() -> bool:
	return carried_type != -1

func set_color(t: int) -> void:
	carried_type = t
	carry_rect.color = ColorSets.get_color(t)
	carry_rect.color.a = 1.0

func clear_color() -> void:
	carried_type = -1
	carry_rect.color = EMPTY_COLOR
