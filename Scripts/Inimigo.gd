extends KinematicBody2D
var Tipo = "INIMIGO"
const GRAVIDADE = 100
const MAX_VELOCIDADE = 150
const lado = 1
var velocidade = Vector2()
func _ready():
	get_node("AnimationPlayer").play("andando")
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	velocidade.y += GRAVIDADE*delta
	velocidade.x = MAX_VELOCIDADE*delta*lado
	var mov_restante = move(velocidade)
	
	if is_colliding():
		var normal = get_collision_normal()
		var movimento_final = normal.slide(mov_restante)
		var movf = move(movimento_final)
		if movf.x != 0:
			lado *= -1
			
		if lado == 1:
			get_node("slime").set_flip_h(true)
		else: get_node("slime").set_flip_h(false)