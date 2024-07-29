extends Button

@onready var label:Label = $Label
@onready var background:Sprite2D = $BackGround
@onready var texture:Sprite2D = $Sprite2D
@onready var row:int
@onready var col:int
@onready var mine:bool = false

func _on_pressed():
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		self.disabled = true
		texture.texture = null
		Global.check_row = row
		Global.check_col = col
		Global.check = true
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		var flag = load("res://sprites/flag.png")
		var normal = load("res://sprites/slot.png")
		if texture.texture != flag:
			texture.texture = flag
			Global.flag_num += 1
		else:
			texture.texture = normal
			Global.flag_num -= 1

func _effect():
	var animator = $AnimationPlayer
	self.disabled = true
	animator.play("sweep")
