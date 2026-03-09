extends CanvasLayer
@onready var rich_text_label: RichTextLabel = $HBoxContainer/RichTextLabel

var player
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	rich_text_label.text = str(-int(player.global_position.z))
