extends CanvasLayer

onready var btn_notebook = $"Button Notebook"
onready var notebook = $Notebook

onready var notifications = $Notifications

onready var notification_res = preload("res://UI/Notification/Notification.tscn")

func _ready():
	notebook.visible = false

func _process(delta):
	if UI.new_notifications != []:
		var new_notification = notification_res.instance()
		new_notification.text = UI.new_notifications.pop_front()
		notifications.add_child(new_notification)

func _on_Button_Notebook_button_down():
	if notebook.visible:
		notebook.visible = false
	else:
		notebook.open()
