extends TextureButton


onready var main = self.owner
export var block = preload("res://Blocks/TestBlock.tscn")

signal send_block_template(block)

func _ready():
	connect("send_block_template", main, "on_block_select_button_pressed")
	connect("button_down", self, "on_button_down")
	
	#TODO bad but works
	var instance = block.instance()
	if instance.display_name:
		$Label.text = instance.display_name
	else:
		$Label.text = instance.name
	
	instance.queue_free()

func on_button_down():
	emit_signal("send_block_template", block)
