extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var skeletons = find_nodes_by_type(self,"Skeleton3D")
	var skeleton = skeletons.front()
	
	skeleton.get_parent().rotate_x(deg_to_rad(45))
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
