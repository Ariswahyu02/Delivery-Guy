extends CanvasLayer

@onready var high_scores: Label = $Control/Panel/HighScores
@onready var play: Button = $Control/Panel/Play
@onready var exit: Button = $Control/Panel/Exit
@onready var guide_btn: Button = $Control/Panel/Guide

@onready var panel: Panel = $Control/Panel
@onready var back: Button = $Control/Guide/Back
@onready var guide: Panel = $Control/Guide

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	high_scores.text = "%d" %PlayerData.highscore
	
	play.pressed.connect(_on_play)
	exit.pressed.connect(_on_exit)
	
	guide_btn.pressed.connect(_on_guide_button_pressed)
	back.pressed.connect(_on_back_button_pressed)
	
	guide.visible = false

func _on_play() -> void:
	print("Play")
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _on_exit() -> void:
	print("Exit")
	get_tree().quit()

func _on_guide_button_pressed() -> void:
	panel.visible = false
	guide.visible = true

func _on_back_button_pressed() -> void:
	panel.visible = true
	guide.visible = false
