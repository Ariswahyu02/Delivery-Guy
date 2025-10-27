extends SpineSprite

var data : SpineSkeletonDataResource
var custom_skin : SpineSkin
var skin_base : SpineSkin

func _ready():
	data = get_skeleton().get_data()
	custom_skin = new_skin("custom-skin")
	skin_base = data.find_skin("skin-base")
	
	
	set_to_default_skin()
	#apply_use_skill_skin()
	#for el in custom_skin.get_attachments():
		#var entry: SpineSkinEntry = el
		#print(str(entry.get_slot_index()) + " " + entry.get_name())

	get_animation_state().set_animation("idle", true, 0)
	get_animation_state().set_animation("blink", true, 1)
	
	
#func _process(delta: float) -> void:
	#if(Input.is_action_just_pressed("move_left")) :
		#get_animation_state().set_animation("walk", true, 0)
	#
	#if(Input.is_action_just_released("move_left")) : 
		#get_animation_state().set_animation("idle", true, 0)
		#
	#if(Input.is_action_just_pressed("move_right")) :
		#get_animation_state().set_animation("walk", true, 0)
	#
	#if(Input.is_action_just_released("move_right")) : 
		#get_animation_state().set_animation("idle", true, 0)

func change_skin():
	custom_skin.remove_attachment(get_skeleton().find_slot("hair-patch").get_data().get_index(), "hair/brown")

func set_to_default_skin():
	custom_skin = new_skin("custom-skin")
	
	custom_skin.add_skin(skin_base)
	custom_skin.add_skin(data.find_skin("nose/short"))
	custom_skin.add_skin(data.find_skin("eyelids/girly"))
	custom_skin.add_skin(data.find_skin("eyes/violet"))
	custom_skin.add_skin(data.find_skin("hair/brown"))
	custom_skin.add_skin(data.find_skin("clothes/hoodie-blue-and-scarf"))
	custom_skin.add_skin(data.find_skin("legs/pants-jeans"))
	custom_skin.add_skin(data.find_skin("accessories/bag"))
	custom_skin.add_skin(data.find_skin("accessories/hat-red-yellow"))
	
	
	get_skeleton().set_skin(custom_skin);
	get_skeleton().set_to_setup_pose();

func apply_use_skill_skin():
	custom_skin = new_skin("custom-skin")
	
	custom_skin.add_skin(data.find_skin("full-skins/girl"))
	
	get_skeleton().set_skin(custom_skin);
	get_skeleton().set_to_setup_pose();
