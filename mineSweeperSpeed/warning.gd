extends Area2D

var total = 0
var destroyed = false
var used = false
var distFromHome = 0
var distFromPlayer = 0
var totalScore = 0
var steps = 0
var top = false
var bot = false
var right = false
var left = false
var isHole = false
var usedBySnek = false
var mouseIn = false
var addMine = false

func addMine():
	if addMine == false:
		addMine = true
		$hidden/mine.show()
	else:
		addMine = false
		$hidden/mine.hide()
func countNeighbors():
	for i in get_parent().get_children():
		if "danger" in i.name:
			if i.position == position + Vector2(-32,0):
				total += 1
			if i.position == position + Vector2(-32,32):
				total += 1
			if i.position == position + Vector2(0,32):
				total += 1
			if i.position == position + Vector2(32,32):
				total += 1
			if i.position == position + Vector2(32,0):
				total += 1
			if i.position == position + Vector2(32,-32):
				total += 1
			if i.position == position + Vector2(0,-32):
				total += 1
			if i.position == position + Vector2(-32,-32):
				total += 1
#	if total == 1:
#		$cystalSprites/crystal1.show()
#	if total == 2:
#		$cystalSprites/crystal2.show()
#	if total == 3:
#		$cystalSprites/crystal3.show()
#	if total == 4:
#		$cystalSprites/crystal4.show()
#	if total == 5:
#		$cystalSprites/crystal5.show()
#	if total == 6:
#		$cystalSprites/crystal6.show()
#	if total == 7:
#		$cystalSprites/crystal7.show()
#	if total == 8:
#		$cystalSprites/crystal8.show()
				
			
#		if i.position == position + Vector2(-32,0):
#			if $hitOnce.visible == true:
#				left = true
#		if i.position == position + Vector2(32,0):
#			if $hitOnce.visible == true:
#				right = true
#		if i.position == position + Vector2(0,32):
#			if $hitOnce.visible == true:
#				bot = true
#		if i.position == position + Vector2(0,-32):
#			if $hitOnce.visible == true:
#				top = true
#
#
#	if top and !right and !bot and !left:
#		for k in $hidden.get_children():
#			k.hide()
#		$hidden/notTop.show()
#	elif right and !top and !bot and !left:
#		for k in $hidden.get_children():
#			k.hide()
#		$hidden/notRight.show()
#	elif left and !top and !bot and !right:
#		for k in $hidden.get_children():
#			k.hide()
#		$hidden/notLeft.show()
#	elif bot and !top and !left and !right:
#		for k in $hidden.get_children():
#			k.hide()
#		$hidden/notBot.show()
#	elif top and right and !left and !bot:
#		for k in $hidden.get_children():
#			k.hide()
#		$hidden/botLeft.show()
#	elif right and bot and !top and !left:
#		for k in $hidden.get_children():
#			k.hide()
#		$hidden/topLeft.show()
#	elif left and bot and !right and !top:
#		for k in $hidden.get_children():
#			k.hide()
#		$hidden/topRight.show()
#	elif left and top and !right and !bot:
#		for k in $hidden.get_children():
#			k.hide()
#		$hidden/rightBot.show()
#	elif right and top and bot and !left:
#		for k in $hidden.get_children():
#			k.hide()
#		$hidden/left.show()
#	elif top and right and left and !bot:
#		for k in $hidden.get_children():
#			k.hide()
#		$hidden/bot.show()
#	elif top and bot and left and !right:
#		for k in $hidden.get_children():
#			k.hide()
#		$hidden/right.show()
#	elif right and bot and left and !top:
#		for k in $hidden.get_children():
#			k.hide()
#		$hidden/top.show()
func unhide():
#	print(dir)
#	if $hidden.visible == true:
#		$hidden.hide()
#		if dir == 'top':
#			$hitOnce/hitTop.show()
#		elif dir == 'bot':
#			$hitOnce/hitBot.show()
#		elif dir == 'right':
#			$hitOnce/hitRight.show()
#		elif dir == 'left':
#			$hitOnce/hitLeft.show()
	if $hidden.visible == true:
		showText()
		$hidden.hide()
		$hidden.visible = false
#		$Particles2D.emitting = true

func showText():

	$Label.show()
	$Label.text = str(total)

#func becomeHole():
#	isHole = true
#	$cystalSprites.hide()
#	$hole.show()


func _on_warning_mouse_entered():
	mouseIn = true


func _on_warning_mouse_exited():
	mouseIn = false
