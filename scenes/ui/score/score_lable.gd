extends CanvasLayer
@onready var rich_text_label: RichTextLabel = $HBoxContainer/RichTextLabel

var player
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	if player.finished and rich_text_label.get_theme_font_size("normal_font_size") < 450:
		rich_text_label.add_theme_font_size_override("normal_font_size", rich_text_label.get_theme_font_size("normal_font_size") + 4)
	rich_text_label.text = str(-int(player.global_position.z))
