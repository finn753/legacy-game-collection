extends TextureRect

onready var tween = $Tween

func _ready():
	visible = false
	Global.connect("captured",self,"play_capture")

func play_capture():
	rect_pivot_offset = Vector2(rect_size.x/2,rect_size.y-32)
	var capture = Global.capture
	if capture == null:
		return
	
	var image_texture = ImageTexture.new()
	image_texture.create_from_image(capture)
	set_texture(image_texture)
	
	rect_scale = Vector2(1,1)
	visible = true
	
	tween.remove_all()
	tween.interpolate_property(self,"rect_scale",null,Vector2(0,0),1.0,Tween.TRANS_BACK,Tween.EASE_OUT_IN)
	tween.start()
