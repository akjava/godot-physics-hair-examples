extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var hair = find_child("simple-hair01_scale2")
	var skeleton = hair.find_child("Skeleton3D")


	var animation_players = find_nodes_by_type(self,"AnimationPlayer")
	var animation_player = animation_players.back()
	var animation_name = "01neck-move"
	var animation = animation_player.get_animation(animation_name)
	animation.loop = true
	animation_player.play(animation_name)
	
	skeleton.physical_bones_start_simulation(["bone01"])




func find_nodes_by_type(node:Node,type:String,list:Array = [],ignore_self:bool = false):
	if ignore_self == false and node.get_class() == type:
		list.append(node)
		
	for child in node.get_children():
		find_nodes_by_type(child,type,list)
			
	return list


func _on_stop_button_pressed():
	var hair = find_child("simple-hair01_scale2")
	var skeleton = hair.find_child("Skeleton3D")
	
	skeleton.physical_bones_stop_simulation()


func _on_start_button_pressed():
	var hair = find_child("simple-hair01_scale2")
	var skeleton = hair.find_child("Skeleton3D")
	
	
	skeleton.physical_bones_start_simulation(["bone01"])
