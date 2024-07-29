extends Node2D

@onready var slot_holder = $slot_holder
@onready var timer = $Timer
@onready var time = $Control/options/time
@onready var option = $Control/options
@onready var menu = $Control/menu
@onready var mine_flag = $Control/options/mine_flag
@onready var result_ = $Control/result

var cnt = 0

func _ready():
	randomize()
	slot_holder.visible = false
	option.visible = false
	menu.visible = true
	result_.visible = false

func _process(_delta):
	if Global.time_stop == true:
		timer.stop()
		Global.time_stop = false
	mine_flag.text = "Mines - " + str(Global.mine_amount) + "\nFlags - " + str(Global.flag_num) + "/" + str(Global.mine_amount) 
	if Global.won == true or Global.lose == true:
		result()
		Global.won = false
		Global.lose = false
	
	
func game_start():
	cnt = 0
	slot_holder.restart()
	slot_holder.visible = true
	option.visible = true
	result_.visible = false
	menu.visible = false
	timer.start()


func _on_restart_pressed():
	timer.stop()
	option.visible = false
	slot_holder.visible = false
	menu.visible = true
	result_.visible = false
	cnt = 0
	time.text = "time\n" + str(int(cnt/600.0)) + " " + str(int(cnt/60.0)%10) + " : " + str(int((cnt%60)/10.0)) + " " + str(cnt%10)


func _on_timer_timeout():
	cnt += 1
	time.text = "time\n" + str(int(cnt/600.0)) + " " + str(int(cnt/60.0)%10) + " : " + str(int((cnt%60)/10.0)) + " " + str(cnt%10)

func _on_button_pressed():
	game_start()

func result():
	result_.visible = true
	slot_holder.visible = false
	option.visible = false
	menu.visible = false
	if Global.won == true:
		$Control/result/VBoxContainer/win_lose.text = "you won !"
	else:
		$Control/result/VBoxContainer/win_lose.text = "you lose !"
	$Control/result/VBoxContainer/played_time.text = "played time : " + str(int(cnt/600.0)) + " " + str(int(cnt/60.0)%10) + " : " + str(int((cnt%60)/10.0)) + " " + str(cnt%10)

func _on_back_menu_pressed():
	result_.visible = false
	slot_holder.visible = false
	option.visible = false
	menu.visible = true
	print("clicked")


func _on_h_slider_value_changed(value):
	Global.difficulty = value
	var label = $Control/menu/VBoxContainer/Label2
	if value == 0:
		Global.mine_amount = 20
		label.text = "easy\nthere will be 20 mines!"
	elif value == 1:
		Global.mine_amount = 40
		label.text = "medium\nthere will be 40 mines!"
	elif value == 2:
		Global.mine_amount = 60
		label.text = "hard\nthere will be 60 mines!"
	else:
		Global.mine_amount = 80
		label.text = "impossible!\nthere will be 80 mines!"
