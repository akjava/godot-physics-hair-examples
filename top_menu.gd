extends Control


# Called when the node enters the scene tree for the first time.
var example_names = ["01_simple","02_dynamic","03_bone_attachment","04_braid01"]
func _ready():
	pass # Replace with function body.



func _open(index):
	get_tree().change_scene_to_file("res://%s.tscn"%example_names[index])
func _on_example_1_button_pressed():
	_open(0)


func _on_example_2_button_pressed():
	_open(1)


func _on_example_3_button_pressed():
	_open(2)


func _on_example_4_button_pressed():
	_open(3)
