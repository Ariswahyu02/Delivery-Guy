extends CharacterBody2D

@export var speed: float = 220.0
var carried_type: int = -1                 # -1 = tidak membawa warna
var interact_target: Area2D = null         # target yang sedang di-range
var dir: Vector2

@onready var interact_area: Area2D = $"Interact Detect"
@onready var carry_rect: ColorRect = $ColorRect
@onready var interact_key: Label = %"Interact Key"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


const EMPTY_COLOR := Color(1,1,1,0)

func _ready() -> void:
	carry_rect.color = EMPTY_COLOR
	interact_key.visible = false

	interact_area.area_entered.connect(_on_area_entered)
	interact_area.area_exited.connect(_on_area_exited)

func _physics_process(delta: float) -> void:
	dir = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		0
	)
	velocity = dir.normalized() * speed
	move_and_slide()

func _process(delta: float) -> void:
	_sprite_handle(dir)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact_color") and interact_target:
		if interact_target.has_method("interact"):
			interact_target.interact(self)

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("interact"):
		interact_target = area
		interact_key.visible = true

func _on_area_exited(area: Area2D) -> void:
	if area == interact_target:
		interact_target = null
		interact_key.visible = false

func is_carrying() -> bool:
	return carried_type != -1

func set_color(t: int) -> void:
	carried_type = t
	carry_rect.color = ColorSets.get_color(t)
	carry_rect.color.a = 1.0

func clear_color() -> void:
	carried_type = -1
	carry_rect.color = EMPTY_COLOR

func _sprite_handle(direction: Vector2) :
	if direction.x > 0 :
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.play("Run")
	elif direction.x < 0 :
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("Run")
	else : 
		animated_sprite_2d.play("Idle")
