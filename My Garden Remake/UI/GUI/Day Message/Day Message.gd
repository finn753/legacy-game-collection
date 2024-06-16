extends Label

var quotes = ["Water your sprouts","Watered flowers can mate","Plants grow overnight","The game saves automatically","You make life happy","Make each day a masterpiece","Impossible is for the unwilling","It's never too late","Dream big and dare to fail","You're enough","Keep going","Leave no stone unturned","Simplicity","No one becomes poor by giving","You can if you think you can"]
var available_quotes

func _ready():
	Global.connect("new_day",self,"play_animation")
	Global.connect("loaded",self,"day_update")
	
	available_quotes = quotes.duplicate(true)
	
	day_update()
	visible = false
	#play_animation()

func before_day_update():
	text = "Day " + str(Global.day - 1)

func day_update():
	text = "Day " + str(Global.day)

func quote_update():
	print(quotes)
	if available_quotes.size() < 1:
		available_quotes = quotes.duplicate(true)
	
	randomize()
	var quote_pos = randi()%available_quotes.size()
	var new_quote = available_quotes[quote_pos]
	available_quotes.remove(quote_pos)
	
	$Motivation.text = new_quote

func play_animation():
	before_day_update()
	quote_update()
	$AnimationPlayer.play("NewDay")
