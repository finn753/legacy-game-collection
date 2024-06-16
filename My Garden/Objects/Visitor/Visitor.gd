extends RigidBody2D

const TYPE = "Visitor"

const MESSAGES = [
"""Did you know that you can water flowers and they begin to grow?
If you place them near each other they even reproduce themselves.
Isn't that fascinating?""",
"You have a beautiful garden",
"Your flowers are so pretty",
"You are a wonderful person",
"Have you already found your favorite flower?",
"Have you tried meditation before?",
"The best way to get started is to quit talking and begin doing",
"The pessimist sees difficulty in every opportunity. The optimist sees opportunity in every difficulty",
"Don’t let yesterday take up too much of today",
"You learn more from failure than from success. Don’t let it stop you. Failure builds character",
"If you are working on something that you really care about, you don’t have to be pushed. The vision pulls you",
"People who are crazy enough to think they can change the world, are the ones who do",
"Imagine your life is perfect in every respect. What would it look like?",
"We generate fears while we sit. We overcome them by action",
"The only limit to our realization of tomorrow will be our doubts of today",
"Develop an attitude of gratitude. Say thank you to everyone you meet for everything they do for you",
"You are never too old to set another goal or to dream a new dream",
"When you arise in the morning think of what a privilege it is to be alive, to think, to enjoy, to love",
"The next message you need is always right where you are",
"I close my eyes in order to see",
"The least of things with a meaning is worth more in life than the greatest of things without it",
"Those who are free of resentful thoughts surely find peace",
"The less you want, the richer you are",
"Neither seek nor avoid, take what comes",
"Learning to ignore things is one of the great paths to inner peace",
"This is my secret. I don’t mind what happens",
"Mind is like a mad monkey",
"Wise people don’t judge. They seek to understand",
"When thoughts arise, then do all things arise. When thoughts vanish, then do all things vanish",
"Wherever you are, it’s the place you need to be",
"Rest and be kind, you don’t have to prove anything",
"Nothing ever goes away until it has taught us what we need to know",
"Life is a balance of holding on and letting go",
"Keep looking up… that’s the secret of life",
"Being positive is a sign of intelligence",
"If you are positive, you’ll see opportunities instead of obstacles",
"The first step is you have to say that you can",
"We can change our lives. We can do, have, and be exactly what we wish",
"A problem is a chance for you to do your best",
"Problems are not stop signs, they are guidelines",
"A little progress each day adds up to big results",
"I am thankful to all who said no to me. It is because of them that I’m doing it myself",
"Be thankful for what you have and you’ll end up having more",
"Try to be a rainbow in someone’s cloud"]

const VISITORS = ["Sabrina","Dors","Blar","Gasa","Gero"]

onready var sprite = $AnimatedSprite

#export var min_day = 2

var msg = 0
var vstr = 0

func _ready():
	var err = Global.connect("new_day",self,"new_day")
	if err == 0:
		err = 0
	
	sprite.animation = VISITORS[vstr]

func new_day():
	randomize()
	msg = randi()%MESSAGES.size()
	vstr = randi()%VISITORS.size()
	
	sprite.animation = VISITORS[vstr]

func grab():
	pass

func ungrab():
	pass

func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y,
		"msg" : msg,
		"vstr" : vstr,
	}
	return save_dict

func get_type():
	return TYPE


func _on_Area2D_body_entered(body):
	if body.has_method("get_type") && body.get_type() == "Player":
		if body.position.x < position.x:
			sprite.set_flip_h(true)
		elif body.position.x > position.x:
			sprite.set_flip_h(false)
		
		Global.new_message(MESSAGES[msg])

func _on_Area2D_body_exited(body):
	if body.has_method("get_type") && body.get_type() == "Player":
		if body.position.x < position.x:
			sprite.set_flip_h(true)
		elif body.position.x > position.x:
			sprite.set_flip_h(false)
		
		Global.new_message("")
