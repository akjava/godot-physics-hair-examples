class_name PhysicalBone3ddUtils extends Object


static func get_bone_diff_pos(skeleton:Skeleton3D,bone_name1:String,bone_name2:String)->Vector3:
	var index1 = skeleton.find_bone(bone_name1)
	var index2 = skeleton.find_bone(bone_name2)
	if index1 == -1:
		print("Bone:%s is  not found in %s"%[bone_name1,skeleton.get_path()])
		return Vector3.ZERO
	if index2 == -1:
		print("Bone:%s is  not found in %s"%[bone_name2,skeleton.get_path()])
		return  Vector3.ZERO
	var bone1 = skeleton.find_bone(bone_name1)
	var bone2 = skeleton.find_bone(bone_name2)
	
	var bone_transform1 = skeleton.get_bone_global_pose  (bone1)
	var bone_transform2 = skeleton.get_bone_global_pose  (bone2)
	
	var origin1 = bone_transform1.origin
	var origin2 = bone_transform2.origin
	
	return  origin2 - origin1
	
static func save(node):
	var scene = PackedScene.new()
	scene.pack(node)
	var save_path = "res://%s_with_physical-bone3d.tscn"%node.name
	print("saved:"+save_path)
	ResourceSaver.save(scene,save_path)
	return save_path
		
# Test implement
static func add_hand_physics(skeleton:Skeleton3D,forearm_bone_name,hand_bone_name,is_right = true,min_x = -15,max_x = 15,min_y=0,max_y=0,min_z=-25,max_z=10):
	var physical_bone_forearm = add_bone_with_bone_attachment(skeleton,forearm_bone_name,hand_bone_name,0.1)
	
	var diff_pos = get_bone_diff_pos(skeleton,forearm_bone_name,hand_bone_name)
	var physical_bone_hand = add_bone(skeleton,hand_bone_name,hand_bone_name,0.5,0.3,true,diff_pos,0.5)
	
	set_dof6_limit_enabled(physical_bone_forearm,true,true,true)
	set_dof6_limit_enabled(physical_bone_hand,true,true,true)
	physical_bone_forearm.scale = Vector3(1,1,1)
	physical_bone_hand.scale = Vector3(1,1,1)
	
	physical_bone_hand.set("angular_damp",100)
	
	if is_right:
		set_angular_limit_xyz(physical_bone_hand,min_x,max_x,min_y,max_y,min_z,max_z)
	else:
		set_angular_limit_xyz(physical_bone_hand,min_x,max_x,min_y,max_y,-max_z,-min_z)
	
	
	
	

# dof
static func set_dof6_limit_enabled(physical_bone:PhysicalBone3D,x,y,z):
	physical_bone.joint_type = PhysicalBone3D.JOINT_TYPE_6DOF
	physical_bone.set("joint_constraints/x/angular_limit_enabled",x)
	physical_bone.set("joint_constraints/y/angular_limit_enabled",y)
	physical_bone.set("joint_constraints/z/angular_limit_enabled",z)
	
static func set_angular_limit_xyz(physical_bone,x_min,x_max,y_min,y_max,z_min,z_max):
	physical_bone.set("joint_constraints/x/angular_limit_upper",x_max)
	physical_bone.set("joint_constraints/x/angular_limit_lower",x_min)
	physical_bone.set("joint_constraints/y/angular_limit_upper",y_max)
	physical_bone.set("joint_constraints/y/angular_limit_lower",y_min)
	physical_bone.set("joint_constraints/z/angular_limit_upper",z_max)
	physical_bone.set("joint_constraints/z/angular_limit_lower",z_min)


static func add_bone_with_bone_attachment(skeleton:Skeleton3D,bone_name1:String,bone_name2:String,shape_height_multiply:float = 1,radius_ratio:float = 0.25,rotating = true,same_bone_offset = Vector3(0,-0.02,0),shape_location_ratio = 0.5) -> PhysicalBone3D:
	var index1 = skeleton.find_bone(bone_name1)
	var index2 = skeleton.find_bone(bone_name2)
	if index1 == -1:
		print("Bone:%s is  not found in %s"%[bone_name1,skeleton.get_path()])
		return null
	if index2 == -1:
		print("Bone:%s is  not found in %s"%[bone_name2,skeleton.get_path()])
		return null
	var bone_attachment = BoneAttachment3D.new()
	bone_attachment.name = "BoneAttachment - %s"%[bone_name1]
	bone_attachment.bone_name = bone_name1
	skeleton.add_child(bone_attachment)
	
	bone_attachment.owner = skeleton.get_parent().get_parent()
	
	var bone1 = skeleton.find_bone(bone_name1)
	var transform = skeleton.get_bone_global_pose  (bone1)
	bone_attachment.global_transform =Transform3D(transform)
	
	
	return create_physical_bone(bone_attachment,skeleton,bone_name1,bone_name2,shape_height_multiply,radius_ratio,rotating,same_bone_offset,shape_location_ratio)

	
static func add_bone(skeleton:Skeleton3D,bone_name1:String,bone_name2:String,shape_height_multiply:float = 1,radius_ratio:float = 0.25,rotating = true,same_bone_offset = Vector3(0,-0.02,0),shape_location_ratio = 0.5) -> PhysicalBone3D:
	var index1 = skeleton.find_bone(bone_name1)
	var index2 = skeleton.find_bone(bone_name2)
	if index1 == -1:
		print("Bone:%s is  not found in %s"%[bone_name1,skeleton.get_path()])
		return null
	if index2 == -1:
		print("Bone:%s is  not found in %s"%[bone_name2,skeleton.get_path()])
		return null
	return create_physical_bone(skeleton,skeleton,bone_name1,bone_name2,shape_height_multiply,radius_ratio,rotating,same_bone_offset,shape_location_ratio)

static func create_physical_bone(parent:Node3D,skeleton:Skeleton3D,bone_name1:String,bone_name2:String,shape_height_multiply:float = 1,radius_ratio:float = 0.25,rotating = true,same_bone_offset = Vector3(0,-0.02,0),shape_location_ratio = 0.5)-> PhysicalBone3D:	
	# need fix 
	if parent == null:
		print("parent is null")
		return null
	if parent.get_parent() == null:
		print("maybe parent not add node-tree %s"%[parent.get_path()])
		return null
	var owner = skeleton.get_parent().get_parent() # versy important
	if owner == null:
		print("maybe parent not add node-tree %s"%[parent.get_path()])
		return null
	
	
	var physical_bone = PhysicalBone3D.new()
	
	physical_bone.set_name("PhysicalBone " + bone_name1)
	
	physical_bone.joint_type = 1 # pin
	
	physical_bone.bone_name = bone_name1 #対象のボーン
	parent.add_child(physical_bone)
	physical_bone.set_name("PhysicalBone " + bone_name1)
	
	physical_bone.owner = owner
	
	var bone1 = skeleton.find_bone(bone_name1)
	var bone2 = skeleton.find_bone(bone_name2)
	
	var bone_transform1 = skeleton.get_bone_global_pose  (bone1)
	var bone_transform2 = skeleton.get_bone_global_pose  (bone2)
	
	
	var rot1 = bone_transform1.basis.get_euler()
	var rest = skeleton.get_bone_rest(bone1).basis.get_euler()
	
	var origin1 = bone_transform1.origin
	var origin2 = bone_transform2.origin
	
	if bone_name1 == bone_name2:
		origin2 += same_bone_offset
	
	var global_diff_pos = origin2 - origin1
	
	var cshape=CollisionShape3D.new()
	physical_bone.add_child(cshape)
	cshape.owner =owner
	
	
	
	var capsule = CapsuleShape3D.new()
	
	#just connect straight suit for back-bone
	if not rotating:
		cshape.global_transform = Transform3D()
	cshape.shape = capsule
	
	cshape.global_transform .origin = origin1 + global_diff_pos * shape_location_ratio #*height_multiply
	
	
	var distance = global_diff_pos.distance_to(Vector3.ZERO) * shape_height_multiply
	
	
	capsule.height = distance 
	capsule.radius = capsule.height*radius_ratio
	capsule.margin = 0
	
	return physical_bone
