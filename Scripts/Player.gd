extends KinematicBody2D

const GRAVIDADE = 100
const VELOCIDADE_MOV = 300
const DESACELERACAO = 600
const MAX_PULO = 2
const ALTURA_PULO = 20
var ultimo_input = 0
var noChao = true
var desacelera = 0
var contaPulo = 0
var movimento = Vector2()
var idle = true
var andando = true
var inimigosMortos = 0
func _input(event):
	if event.is_action_pressed("ui_up") and contaPulo < MAX_PULO:
		movimento.y = -ALTURA_PULO
		contaPulo += 1

func _fixed_process(delta):
	var velocidade= Vector2(0,0)
	var input = 0
	if Input.is_action_pressed("ui_left"):
		input = -1
		get_node("spritesheet").set_flip_h(true)
	elif Input.is_action_pressed("ui_right"):
		input = 1
		get_node("spritesheet").set_flip_h(false)
	if input == 0:
		andando = true
	
	if(input):
		movimento.x = VELOCIDADE_MOV*delta*input
	elif ultimo_input == -input:
		movimento.x = DESACELERACAO*delta*ultimo_input
		
	movimento.y += GRAVIDADE*delta

	
	
	var velocidade = Vector2(movimento.x,movimento.y)
	var movimento_restante = move(velocidade)
	#calcula normal e implementa deslize

	if is_colliding():
		if get_collider().is_in_group("Inimigo"):
			inimigosMortos += 1
			get_node("Label").set_text("Inimigo ="+str(inimigosMortos))
			get_collider().queue_free()
			movimento.y = -ALTURA_PULO
		if andando and input:
			get_node("AnimationPlayer").play("andando")
			andando = false
			idle = true
		if abs(velocidade.x) == 0 and idle:
			get_node("AnimationPlayer").play("Idle")
			idle = false
		contaPulo = 0
		noChao = true
		var normal = get_collision_normal()
		var movimento_final = normal.slide(movimento_restante)
		movimento = normal.slide(movimento)
		move(movimento_final)
	else:
		get_node("AnimationPlayer").play("pulando")
		idle = true
		andando = true
	ultimo_input = input
	
func _ready():
	set_fixed_process(true)
	set_process_input(true)