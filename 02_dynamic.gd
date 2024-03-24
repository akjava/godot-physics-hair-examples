extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var skeletons = find_nodes_by_type(self,"Skeleton3D")
	var skeleton = skeletons.front()
	
	
	PhysicalBone3ddUtils.add_bone(skeleton,"bone00","bone01",0.6,0.15)
	PhysicalBone3ddUtils.add_bone(skeleton,"bone01","bone02",0.85,0.15)
	
	# set collisiotn shape center
	var diff = PhysicalBone3ddUtils.get_bone_diff_pos(skeleton,"bone01","bone02")
	PhysicalBone3ddUtils.add_bone(skeleton,"bone02","bone02",0.85,0.15,true,diff)
	
	
	#skeleton.get_parent().rotate_x(deg_to_rad(45))
	skeleton.physical_bones_start_simulation(["bone01"])
	



func find_nodes_by_type(node:Node,type:String,list:Array = [],ignore_self:bool = false):
	if ignore_self == false and node.get_class() == type:
		list.append(node)
		
	for child in node.get_children():
		find_nodes_by_type(child,type,list)
			
	return list

func _on_ragdoll_button_pressed():
	var skeletons = find_nodes_by_type(self,"Skeleton3D")
	var skeleton = skeletons.front()
	
	skeleton.physical_bones_start_simulation(["bone00"])


func _on_stop_button_pressed():
	var skeletons = find_nodes_by_type(self,"Skeleton3D")
	var skeleton = skeletons.front()
	skeleton.physical_bones_stop_simulation()


func _on_start_button_pressed():
	var skeletons = find_nodes_by_type(self,"Skeleton3D")
	var skeleton = skeletons.front()
	
	skeleton.physical_bones_start_simulation(["bone01"])


func _on_save_button_pressed():
	var node_name = "simple-hair01"
	#var node_name = "braid01_black"
	var node = find_child(node_name)
	if not node:
		find_child("ResultLabel").text = "Node not found %s"%node_name
		return
	var result = PhysicalBone3ddUtils.save(node)
	find_child("ResultLabel").text = "Saved %s"%[result]
