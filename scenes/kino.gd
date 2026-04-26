extends CanvasLayer

func _ready():
	# Получаем ссылку на AnimatedSprite2D
	var sprite = $AnimatedSprite2D
	
	# Проверяем, существует ли спрайт
	if sprite == null:
		print("ОШИБКА: Нода AnimatedSprite2D не найдена!")
		return
	
	# Подключаем сигнал окончания анимации
	sprite.animation_finished.connect(_on_animation_finished)
	
	# Запускаем анимацию
	sprite.play()
	
	print("Анимация запущена, размер экрана: ", get_viewport().get_visible_rect().size)

func _on_animation_finished():
	print("Анимация закончилась")
	
	get_tree().quit()
