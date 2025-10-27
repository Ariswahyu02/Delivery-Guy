extends CharacterBody2D

@export var speed_origin: float = 220.0
var current_speed: float = 220.0
var carried_type: int = -1                 # -1 = tidak membawa warna

var interact_target: Area2D = null         # target yang sedang di-range
var dir: Vector2
var current_anim_name :String = ""

var speed_boost_timer: SceneTreeTimer
var is_speed_boost_active : bool = false

@onready var interact_area: Area2D = $"Interact Detect"
@onready var carry_rect: ColorRect = $ColorRect
@onready var interact_key: Label = %"Interact Key"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var spine_sprite: Node = $SpineSprite

const EMPTY_COLOR := Color(1,1,1,0)

func _ready() -> void:
	carry_rect.color = EMPTY_COLOR
	current_speed = speed_origin
	
	if interact_key != null: 
		interact_key.visible = false

	interact_area.area_entered.connect(_on_area_entered)
	interact_area.area_exited.connect(_on_area_exited)

func _physics_process(delta: float) -> void:
	dir = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		0
	)
	velocity = dir.normalized() * current_speed
	move_and_slide()

func _process(delta: float) -> void:
	_sprite_handle(dir)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact_color") and interact_target:
		if interact_target.has_method("interact"):
			interact_target.interact(self)
			
	if event.is_action_pressed("use_skill"):
		if not is_speed_boost_active :
			_use_speed_boost()

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
		
		spine_sprite.get_skeleton().set_scale_x(1)
		_play_anim_once("walk")
	elif direction.x < 0 :
		spine_sprite.get_skeleton().set_scale_x(-1)
		_play_anim_once("walk")
	else : 
		_play_anim_once("idle")
		pass

func _play_anim_once(name: String, loop := true) -> void:
	if current_anim_name == name:
		return  
	
	spine_sprite.get_animation_state().set_animation(name, loop, 0)
	current_anim_name = name

func _use_speed_boost():
	# Ambil skill data dari SkillDB (autoload)
	var skill = PlayerSkills.skills.get("boost_move_speed", null)
	if skill == null:
		push_warning("Skill boost_move_speed tidak ditemukan")
		return

	var bonus = float(skill["value"])        # +5
	var duration = float(skill["duration"])  # 15 detik

	if is_speed_boost_active:
		# refresh timer biar durasi diperpanjang
		if speed_boost_timer:
			speed_boost_timer.time_left = duration
		return

	# apply boost
	is_speed_boost_active = true
	current_speed = speed_origin + bonus
	if(spine_sprite.has_method("apply_use_skill_skin")):
		spine_sprite.apply_use_skill_skin()
	
	print("Boost Activated, Current Speed:  " + str(current_speed))
	print("Previous Speed:  " + str(speed_origin))

	# buat timer otomatis reset
	speed_boost_timer = get_tree().create_timer(duration)
	speed_boost_timer.timeout.connect(_on_boost_timeout)

func _on_boost_timeout():
	is_speed_boost_active = false
	current_speed = speed_origin
	speed_boost_timer = null
	
	if(spine_sprite.has_method("set_to_default_skin")):
		spine_sprite.set_to_default_skin()
