extends KinematicBody2D

const GRAVIDADE = 100
const VELOCIDADE_MOV = 300
const DESACELERACAO = 600
const MAX_PULO = 2
const ALTURA_PULO = 20
var vidas = 4
var ultimo_input = 0
var noChao = true
var desacelera = 0
var contaPulo = 0
var movimento = Vector2()
var idle = true
var andando = true
var inimigosMortos = 0
var inicio = Vector2()
func _input(event):
	if event.is_action_pressed("ui_up") and contaPulo < MAX_PULO:
		movimento.y = -ALTURA_PULO
		contaPulo += 1

func pular():
	movimento.y = -ALTURA_PULO
	
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

func restart():
	set_global_pos(inicio)

func _ready():
	get_node("AnimationPlayer").play("teste")
	#yield(get_node("AnimationPlayer"),"finished")
	inicio = get_global_pos()
	set_fixed_process(true)
	set_process_input(true)

func _on_Pe_body_enter( body ):
	if body.is_in_group("Inimigo"):
			inimigosMortos += 1
			if noChao:
				movimento.y += -ALTURA_PULO
				noChao = false
			body.queue_free()
			noChao = true


func _on_Area2D_body_enter( body ):
	if body.is_in_group("Inimigo"):
		restart()


func _on_Abismo_body_enter( body ):
	if vidas > 0:
		vidas -= 1
		get_node("../CanvasLayer/Panel/Label 2").set_text(str(vidas))
	else:
		get_tree().quit()
	restart()
