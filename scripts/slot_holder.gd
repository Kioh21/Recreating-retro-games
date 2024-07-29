extends Node2D

var clear_slot:Array

func _process(_delta):
	if Global.check == true:
		Global.check = false
		sweep(Global.check_row, Global.check_col)

func restart():
	while $GridContainer.get_children().size() > 0:
		$GridContainer.remove_child($GridContainer.get_child(0))
	for i in range(425):
		var slot = preload("res://scenes/slot.tscn")
		var instance = slot.instantiate()
		$GridContainer.add_child(instance)
		$GridContainer.get_child(i).row = int(i/17.0)
		$GridContainer.get_child(i).col = int(i%17)
		$GridContainer.get_child(i).label.text = ""
	mine_placing()

func mine_placing():
	var list = []
	for i in range(Global.mine_amount):
		var old = true
		var temp:int
		while old == true:
			old = false
			temp = randi_range(0,424)
			for j in range(list.size()):
				if list[j] == temp:
					old = true
		list.append(temp)
	var mine_ = preload("res://sprites/mine.png")
	for i in range(list.size()):
		var mine_slot = $GridContainer.get_child(list[i])
		mine_slot.mine = true
		mine_slot.background.texture = mine_
		mine_slot.label.text = "·"
		var effect = mine(mine_slot.row,mine_slot.col)
		for j in range(effect.size()):
			var box = $GridContainer
			if box.get_child(effect[j][0]*17+effect[j][1]).mine != true:
				if box.get_child(effect[j][0]*17+effect[j][1]).label.text == "":
					box.get_child(effect[j][0]*17+effect[j][1]).label.text = "1"
				else:
					box.get_child(effect[j][0]*17+effect[j][1]).label.text = str(int(box.get_child(effect[j][0]*17+effect[j][1]).label.text) + 1)
		
func mine(row:int,col:int):
	var check:Array = []
	var type:String = ""
	
	if row == 0 and col == 0:
		type = "left_top_corner"
	elif row == 0 and col == 16:
		type = "right_top_corner"
	elif row == 0:
		type = "top"
	elif row == 24 and col == 0:
		type = "left_bottom_corner"
	elif col == 0:
		type = "left"
	elif row == 24 and col == 16:
		type = "right_bottom_corner"
	elif row == 24:
		type = "bottom"
	elif col == 16:
		type = "right"
	else:
		type = "around"

	match type:
		"left_top_corner":
			check.append([int(row),int(col+1)])
			check.append([int(row+1),int(col)])
			check.append([int(row+1),int(col+1)])
		"right_top_corner":
			check.append([int(row),int(col-1)])
			check.append([int(row+1),int(col)])
			check.append([int(row+1),int(col-1)])
		"top":
			check.append([int(row),int(col-1)])
			check.append([int(row),int(col+1)])
			check.append([int(row+1),int(col-1)])
			check.append([int(row+1),int(col)])
			check.append([int(row+1),int(col+1)])
		"left_bottom_corner":
			check.append([int(row-1),int(col)])
			check.append([int(row-1),int(col+1)])
			check.append([int(row),int(col+1)])
		"left":
			check.append([int(row-1),int(col)])
			check.append([int(row-1),int(col+1)])
			check.append([int(row),int(col+1)])
			check.append([int(row+1),int(col)])
			check.append([int(row+1),int(col+1)])
		"right_bottom_corner":
			check.append([int(row-1),int(col-1)])
			check.append([int(row-1),int(col)])
			check.append([int(row),int(col-1)])
		"bottom":
			check.append([int(row-1),int(col-1)])
			check.append([int(row-1),int(col)])
			check.append([int(row-1),int(col+1)])
			check.append([int(row),int(col-1)])
			check.append([int(row),int(col+1)])
		"right":
			check.append([int(row-1),int(col-1)])
			check.append([int(row-1),int(col)])
			check.append([int(row),int(col-1)])
			check.append([int(row+1),int(col-1)])
			check.append([int(row+1),int(col)])
		"around":
			check.append([int(row-1),int(col-1)])
			check.append([int(row-1),int(col)])
			check.append([int(row-1),int(col+1)])
			check.append([int(row),int(col-1)])
			check.append([int(row),int(col+1)])
			check.append([int(row+1),int(col-1)])
			check.append([int(row+1),int(col)])
			check.append([int(row+1),int(col+1)])
			
	return check

func around(row:int, col:int):
	var check:Array = []
	var type:String = "around"
	var box = $GridContainer
	if row == 0 and col == 0:
		type = "left_top_corner"
	elif row == 0 and col == 16:
		type = "right_top_corner"
	elif row == 0:
		type = "top"
	elif row == 24 and col == 0:
		type = "left_bottom_corner"
	elif col == 0:
		type = "left"
	elif row == 24 and col == 16:
		type = "right_bottom_corner"
	elif row == 24:
		type = "bottom"
	elif col == 16:
		type = "right"
	else:
		type = "around"

	match type:
		"left_top_corner":
			check.append([int(row),int(col+1)])
			check.append([int(row+1),int(col)])
			if box.get_child((row+1)*17 + col+1).label.text != "":
				check.append([int(row+1),int(col+1)])
		"right_top_corner":
			check.append([int(row),int(col-1)])
			check.append([int(row+1),int(col)])
			if box.get_child((row+1)*17 + col - 1).label.text != "":
				check.append([int(row+1),int(col-1)])
		"top":
			check.append([int(row),int(col-1)])
			check.append([int(row),int(col+1)])
			if box.get_child((row+1)*17 + col - 1).label.text != "":
				check.append([int(row+1),int(col-1)])
			check.append([int(row+1),int(col)])
			if box.get_child((row+1)*17 + col + 1).label.text != "":
				check.append([int(row+1),int(col+1)])
		"left_bottom_corner":
			check.append([int(row-1),int(col)])
			check.append([int(row-1),int(col+1)])
			if box.get_child((row - 1)*17 + col + 1).label.text != "":
				check.append([int(row),int(col+1)])
		"left":
			check.append([int(row-1),int(col)])
			if box.get_child((row-1)*17 + col + 1).label.text != "":
				check.append([int(row-1),int(col+1)])
			check.append([int(row),int(col+1)])
			check.append([int(row+1),int(col)])
			if box.get_child((row+1)*17 + col + 1).label.text != "":
				check.append([int(row+1),int(col+1)])
		"right_bottom_corner":
			if box.get_child((row-1)*17 + col - 1).label.text != "":
				check.append([int(row-1),int(col-1)])
			check.append([int(row-1),int(col)])
			check.append([int(row),int(col-1)])
		"bottom":
			if box.get_child((row-1)*17 + col - 1).label.text != "":
				check.append([int(row-1),int(col-1)])
			check.append([int(row-1),int(col)])
			if box.get_child((row-1)*17 + col + 1).label.text != "":
				check.append([int(row-1),int(col+1)])
			check.append([int(row),int(col-1)])
			check.append([int(row),int(col+1)])
		"right":
			if box.get_child((row-1)*17 + col - 1).label.text != "":
				check.append([int(row-1),int(col-1)])
			check.append([int(row-1),int(col)])
			check.append([int(row),int(col-1)])
			if box.get_child((row+1)*17 + col - 1).label.text != "":
				check.append([int(row+1),int(col-1)])
			check.append([int(row+1),int(col)])
		"around":
			if box.get_child((row+1)*17 + col - 1).label.text != "":
				check.append([int(row+1),int(col-1)])
			check.append([int(row-1),int(col)])
			if box.get_child((row-1)*17 + col + 1).label.text != "":
				check.append([int(row-1),int(col+1)])
			check.append([int(row),int(col-1)])
			check.append([int(row),int(col+1)])
			if box.get_child((row+1)*17 + col - 1).label.text != "":
				check.append([int(row+1),int(col-1)])
			check.append([int(row+1),int(col)])
			if box.get_child((row+1)*17 + col + 1).label.text != "":
				check.append([int(row+1),int(col+1)])
			
	return check

func sweep(row:int, col:int):
	var open = []
	var final = []
	var box = $GridContainer
	var check = around(row,col)
	if box.get_child(Global.check_row*17 + Global.check_col).label.text == "":
		if box.get_child(Global.check_row*17 + Global.check_col).mine == false:
			for i in range(len(check)):
					open.append(check[i])
		var added = -1
		while added != 0:
			added = 0
			for i in range(open.size()):
				var temp = []
				if box.get_child(open[i][0]*17 + open[i][1]).label.text == "":
					temp = around(open[i][0],open[i][1])
				var same = false
				for j in range(temp.size()):
					for k in range(open.size()):
						if temp[j] == open[k]:
							same = true
					if same == true:
						same = false
					else:
						open.append(temp[j])
						added += 1
		var cnt = 0
		if open.size() > 0:
			final.append(open[0])
			while cnt != open.size():
				var same = false
				for i in range(final.size()):
					if open[cnt] == final[i]:
						same = true
				if same == false:
					final.append(open[cnt])
				cnt += 1
		for i in range(final.size()):
			if box.get_child(final[i][0]*17 + final[i][1]).disabled == false:
				clear_slot.append(final[i])
		clear()
	elif box.get_child(Global.check_row*17+Global.check_col).mine == true:
		$ColorRect.visible = true
		game_over(row,col)
	check_won()

func clear():
	var rect = $ColorRect
	rect.visible = true
	var box = $GridContainer
	if clear_slot.size() > 0:
		while clear_slot.size() != 0:
			await get_tree().create_timer(0.01).timeout
			box.get_child(clear_slot[0][0]*17 + clear_slot[0][1])._effect()
			clear_slot.erase(clear_slot[0])
	rect.visible = false

func game_over(row:int, col:int):
	Global.time_stop = true
	var open = []
	var final = []
	var check = around(row,col)
	var box = $GridContainer
	for i in range(check.size()):
		open.append(check[i])
	var added = -1
	while added != 0:
		added = 0
		for i in range(open.size()):
			var temp = []
			temp = mine(open[i][0], open[i][1])
			var same = false
			for j in range(temp.size()):
				for k in range(open.size()):
					if temp[j] == open[k]:
						same = true
				if same == true:
					same = false
				else:
					open.append(temp[j])
					added += 1
	var cnt = 0
	if open.size() > 0:
		final.append(open[0])
		while cnt != open.size():
			var same = false
			for i in range(final.size()):
				if open[cnt] == final[i]:
					same = true
			if same == false:
				final.append(open[cnt])
			cnt += 1
	for i in range(final.size()):
		if box.get_child(final[i][0]*17 + final[i][1]).disabled == false:
			clear_slot.append(final[i])
	await clear()
	Global.lose = true
	$ColorRect.visible = false

func check_won():
	var left_cnt: int = 0
	for i in range($GridContainer.get_children().size()):
		if $GridContainer.get_child(i).disabled == false:
			left_cnt += 1
	if left_cnt == Global.mine_amount:
		Global.time_stop = true
		var open = []
		var final = []
		var check = around(Global.check_row,Global.check_col)
		var box = $GridContainer
		for i in range(check.size()):
			open.append(check[i])
		var added = -1
		while added != 0:
			added = 0
			for i in range(open.size()):
				var temp = []
				temp = mine(open[i][0], open[i][1])
				var same = false
				for j in range(temp.size()):
					for k in range(open.size()):
						if temp[j] == open[k]:
							same = true
					if same == true:
						same = false
					else:
						open.append(temp[j])
						added += 1
		var cnt = 0
		if open.size() > 0:
			final.append(open[0])
			while cnt != open.size():
				var same = false
				for i in range(final.size()):
					if open[cnt] == final[i]:
						same = true
				if same == false:
					final.append(open[cnt])
				cnt += 1
		for i in range(final.size()):
			if box.get_child(final[i][0]*17 + final[i][1]).disabled == false:
				clear_slot.append(final[i])
		await clear()
		$ColorRect.visible = false
		Global.won = true
