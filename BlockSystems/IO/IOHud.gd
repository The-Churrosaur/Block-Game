extends MarginContainer


export var io_box_path : NodePath
export var port_hud_scene : PackedScene
export var inputs_path : NodePath
export var outputs_path : NodePath
export var inputs_container_path : NodePath
export var outputs_container_path :NodePath

onready var io_box = get_node_or_null(io_box_path)
onready var inputs = get_node(inputs_path)
onready var outputs = get_node(outputs_path)
onready var inputs_container = get_node(inputs_container_path)
onready var outputs_container = get_node(outputs_container_path)

signal port_selected(port, state, is_input)

func display():
	if inputs.get_child_count() <= 0: set_input_huds()
	if outputs.get_child_count() <= 0: set_output_huds()

func toggle_display():
	if visible:
		visible = false
	else:
		visible = true
		display()

func set_display(val):
	print("setting iohud display: ", val, " position at: ", get_parent().global_position)
	visible = val
	display()

func show_inputs(val):
	inputs_container.visible = val

func show_outputs(val):
	outputs_container.visible = val

func set_io_box(box):
	io_box = box

func reset_port_huds():
	for child in inputs.get_children():
		child.queue_free()
	for child in outputs.get_children():
		child.queue_free()

func set_input_huds():
	# TODO I renamed something formerly called 'box'
	for i in io_box.inputs.size():
		var input = io_box.inputs[i]
		var port_hud = port_hud_scene.instance()
		inputs.add_child(port_hud)
		port_hud.set_port(i, input["name"], true)
		port_hud.connect("button", self, "button_pressed")

func set_output_huds():
	for i in io_box.outputs.size():
		var output = io_box.outputs[i]
		var port_hud = port_hud_scene.instance()
		outputs.add_child(port_hud)
		port_hud.set_port(i, output["name"], false)
		port_hud.connect("button", self, "button_pressed")

func button_pressed(port, state, is_input):
	print("iohud button pressed: ", port, state, " is input? ", is_input)
	emit_signal("port_selected", port, state, is_input)
