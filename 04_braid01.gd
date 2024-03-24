extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var hair = find_child("braid01_black")
	var skeleton = hair.find_child("Skeleton3D")

	var players = find_nodes_by_type(self,"AnimationPlayer")
	var animation_player = players.back()
	var animation_name = "ArmatureAction"
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
