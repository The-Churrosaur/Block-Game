extends MarginContainer

export var box_path : NodePath
export var port_hud_scene : PackedScene

onready var box = get_node(box_path)
onready var inputs = $VBoxContainer/Inputs
onready var outputs = $VBoxContainer/Outputs

func display():
	if inputs.get_child_count() <= 0: set_input_huds()
	if outputs.get_child_count() <= 0: set_output_huds()

func toggle_display():
	if visible:
		visible = false
	else:
		visible = true
		display()

func set_input_huds():
	for i in box.inputs.size():
		var input = box.inputs[i]
		var port_hud = port_hud_scene.instance()
		inputs.add_child(port_hud)
		port_hud.set_port(i, input["name"])

func set_output_huds():
	for i in box.outputs.size():
		var output = box.outputs[i]
		var port_hud = port_hud_scene.instance()
		outputs.add_child(port_hud)
		port_hud.set_port(i, output["name"])

func button_pressed(port, state):
	pass
