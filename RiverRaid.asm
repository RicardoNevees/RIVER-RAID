# River Raid - Clone Otimizado com Double Buffering ("buffer duplo": Técnica usada para evitar que a imagem fique piscando).

# Desenvolvedores: Ricardo e Julio

######### CONFIGURACOES DO BITMAP DISPLAY: ####################
#   Unit Width   = 4
#   Unit Height  = 4
#   Display Width  = 512
#   Display Height = 512
#   Base Address   = 0x10010000 (static data)
###############################################################

############# COMANDOS PARA JOGAR: ############################
# TECLAS:
# A = Move Avião para Esquerda
# D = Move Avião para Direita
# ESPAÇO = Avião Atira
###############################################################

.data
display: .space 65536      # 0x10010000 - Tela visivel pelo MARS
framebuffer: .space 65536  # 0x10020000 - Tela oculta (Double Buffer) onde o jogo eh desenhado

txtTitulo: .asciiz "RIVER RAID"
txtAutores: .asciiz "AUTORES:"
txtAlunos: .asciiz "RICARDO E JULIO"

txtPressSpace: .asciiz "PRESS SPACE TO START"
txtPerdeu: .asciiz "GAME OVER!!!"
txtVenceu: .asciiz "VITORIA!"
txtPontos200:      .asciiz "PONTOS: 200"
txtPlayAgain1:  .asciiz "PRESS SPACE"
txtPlayAgain2:  .asciiz "TO PLAY AGAIN"

playerX: .word 64
playerY: .word 108
playerDir: .word 0
playerMoveFrames: .word 0

###############################################################################
# SISTEMA DE TIROS
###############################################################################

.eqv MAX_TIROS 20	# Qtd Máxima de Tiros na Tela

tiroAtivo:
.word 0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0	# Cada zero representa 1 Tiro. SEMPRE que aumentar a Qtd Máxima de balas, deve tbm colocar o nº de zeros igual à Qtd Máxima de balas

tiroX:
.word 0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0	# Cada zero representa 1 Tiro. Cada zero representa 1 Tiro. SEMPRE que aumentar a Qtd Máxima de balas, deve tbm colocar o nº de zeros igual à Qtd Máxima de balas

tiroY:
.word 0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0	# Cada zero representa 1 Tiro. Cada zero representa 1 Tiro. SEMPRE que aumentar a Qtd Máxima de balas, deve tbm colocar o nº de zeros igual à Qtd Máxima de balas



enemy1X: .word 54
enemy1Y: .word 12
enemy1Dir: .word 1
enemy2X: .word 88
enemy2Y: .word 42
enemy2Dir: .word -1

shipX: .word 64
shipY: .word 78
shipDir: .word 1

fuelX: .word 63
fuelY: .word -24

score: .word 0
fuel: .word 100
frame: .word 0
scenario: .word 1
cenarioOffset: .word 0
gameOver: .word 0
gameWin: .word 0
seed: .word 31

###############################################################################
# CONFIGURAÇÃO DAS FONTES
###############################################################################

fonteEscala: .word 1

txtGameOver: .asciiz "GAME OVER"
txtPressione: .asciiz "PRESSIONE ESPACO"
txtParaIniciar: .asciiz "PARA INICIAR"
txtScore: .asciiz "SCORE"
txtFuel: .asciiz "FUEL"

###############################################################################

# Cores
corPreto: .word 0x00000000
corAzul: .word 0x000000ff
corVerde: .word 0x0000aa00
corVerde2: .word 0x0000cc00
corAmarelo: .word 0x00ffff00
corVermelho: .word 0x00ff0000
corBranco: .word 0x00ffffff
corCinza: .word 0x00909090
corAzulEscuro: .word 0x000000aa
corCiano: .word 0x0060c8ff
corVerdeEscuro: .word 0x00005500
corPedra: .word 0x00808080
corMarrom: .word 0x00704020

# --- MATRIZES DE SPRITES (PIXEL ART) ---
# 0=Transparente, 1=Amarelo, 2=Vermelho, 3=Branco, 4=AzulEscuro, 5=Cinza, 6=Verde, 7=Preto, 8=Ciano

spriteAviao: 	# Formato Avião Jogador
    .word 0,0,0,0,0,0,0,0,0,0,0,0,0
    .word 0,0,0,0,0,0,0,0,0,0,0,0,0
    .word 0,0,0,0,0,0,1,1,0,0,0,0,0
    .word 0,0,0,0,0,0,1,1,0,0,0,0,0
    .word 0,0,0,0,1,1,1,1,1,1,1,0,0
    .word 0,0,1,1,1,1,1,1,1,1,1,1,0
    .word 0,1,1,1,0,1,1,0,1,1,0,1,1
    .word 0,0,0,0,0,0,1,1,0,0,0,0,0
    .word 0,0,0,0,0,0,1,1,0,0,0,0,0
    .word 0,0,0,0,1,1,1,1,1,1,0,0,0
    .word 0,0,0,0,1,0,1,1,0,1,0,0,0
    .word 0,0,0,0,0,0,0,0,0,0,0,0,0
    .word 0,0,0,0,0,0,0,0,0,0,0,0,0

spriteHeli:	# Formato Helicóptero
    .word 0,0,0,0,0,1,1,1,0,0,0,0,0
    .word 0,0,1,1,1,1,1,1,1,1,1,0,0
    .word 0,0,0,0,0,0,1,0,0,0,0,0,0
    .word 0,0,0,4,4,4,4,4,4,0,0,0,0
    .word 6,6,0,4,4,4,4,4,4,4,0,6,6
    .word 0,0,0,0,6,6,6,6,0,0,7,7,0
    .word 0,0,0,0,0,4,4,4,6,6,6,0,0
    .word 0,0,0,0,7,0,7,0,7,0,0,0,0
    .word 0,0,0,0,0,0,0,0,0,0,0,0,0

spriteInimigo: 	# Formato Avião Inimigo
    .word 0,0,0,0,0,0,0,8,8,0,0,0,0,0,0
    .word 0,0,0,0,0,8,8,8,8,8,0,0,0,0,0
    .word 0,0,0,8,8,8,8,8,8,8,8,0,0,0,0
    .word 8,8,8,8,8,3,3,8,8,8,8,8,8,8,0
    .word 0,0,0,0,8,8,8,8,8,8,0,0,0,0,0
    .word 0,0,0,0,0,0,8,8,0,0,0,0,0,0,0
    .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

spriteNavio:	# Formato Navio
    .word 0,0,0,0,0,0,0,7,0,0,0,0,0,0,0
    .word 0,0,0,0,0,0,7,7,7,0,0,0,0,0,0
    .word 0,0,0,0,7,7,7,7,7,7,7,0,0,0,0
    .word 0,0,2,2,2,2,2,2,2,2,2,2,2,0,0
    .word 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
    .word 0,0,0,8,8,8,8,8,8,8,8,8,0,0,0
    .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

spriteFuel:	# Formato Tanque que Recarrega Combustível
    .word 0,2,2,2,2,2,2,2,0
    .word 2,3,4,4,4,4,3,3,2
    .word 2,3,4,3,3,3,3,3,2
    .word 2,3,4,4,4,3,3,3,2
    .word 2,3,4,3,4,3,3,3,2
    .word 2,3,4,3,4,3,3,3,2
    .word 2,3,4,4,4,3,3,3,2
    .word 2,3,4,3,3,3,3,3,2
    .word 2,3,4,3,3,3,3,3,2
    .word 2,3,4,4,4,4,3,3,2
    .word 0,2,2,2,2,2,2,2,0
    

##############################################################################
.text
.globl main

main:

    jal TelaInicial
    jal ReiniciarJogo

# --- NOVO GAME LOOP (DOUBLE BUFFERING) ---
LoopJogo:

    jal LerTeclado
    jal AtualizarJogo
    jal ChecarColisoes

    jal DesenharCenarioCompleto
    jal DesenharObjetos
    jal SwapBuffers

    jal SleepFrame

    # Verifica vitória
    lw $t0, gameWin
    bne $t0, $zero, MostrarVitoria

    # Verifica derrota
    lw $t0, gameOver
    beq $t0, $zero, LoopJogo

    jal TelaPerdeu
    li $v0, 10
    syscall

MostrarVitoria:
    jal TelaVitoria
    j EsperaReinicio

# --- MOTOR DE DOUBLE BUFFERING ---
SwapBuffers:
    la $t0, framebuffer
    la $t1, display
    li $t2, 16384
LoopSwap:
    lw $t3, 0($t0)
    sw $t3, 0($t1)
    addiu $t0, $t0, 4
    addiu $t1, $t1, 4
    addiu $t2, $t2, -1
    bgtz $t2, LoopSwap
    jr $ra

ReiniciarJogo:
    li $t0, 64
    sw $t0, playerX
    li $t0, 108
    sw $t0, playerY
    la $t1, tiroAtivo
    li $t2,MAX_TIROS
    mul $t2,$t2,3
LimparTirosReinicio:
    sw $zero, 0($t1)
    addiu $t1, $t1, 4
    addiu $t2, $t2, -1
    bgtz $t2, LimparTirosReinicio
    sw $zero, playerDir
    sw $zero, playerMoveFrames
    sw $zero, score
    sw $zero, frame
    sw $zero, cenarioOffset
    sw $zero, gameOver
    sw $zero, gameWin
    li $t0, 100
    sw $t0, fuel
    li $t0, 1
    sw $t0, scenario
    li $t0, 54
    sw $t0, enemy1X
    li $t0,-20
    sw $t0, enemy1Y
    li $t0, 1
    sw $t0, enemy1Dir
    li $t0, 88
    sw $t0, enemy2X
    li $t0, -60
    sw $t0, enemy2Y
    li $t0, -1
    sw $t0, enemy2Dir
    li $t0, 68
    sw $t0, shipX
    li $t0, -100
    sw $t0, shipY
    li $t0, 1
    sw $t0, shipDir
    li $t0, 63
    sw $t0, fuelX
    li $t0, -24
    sw $t0, fuelY
    jr $ra

InicializarLogo:

    jr $ra

TelaInicial:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)

    jal LimparTela

#==================================================
    # TÍTULO
#==================================================
    li $t0, 2
    sw $t0, fonteEscala
    li $a0, 10
    li $a1, 20
    la $a2, txtTitulo
    lw $a3, corAmarelo
    
    jal EscreverTexto

#==================================================
    # AUTORES:
#==================================================
    
    jal DesenharSublinhadoTitulo   # <-- CHAMADA DO SUBLINHADO
    
    li $t0,1
    sw $t0,fonteEscala

    li $a0,41
    li $a1,52
    la $a2,txtAutores
    lw $a3,corBranco
    jal EscreverTexto
    
    jal DesenharSublinhadoAlunos
    
    #==================================================
    # ALUNOS:
    #==================================================
    li $t0, 1
    sw $t0, fonteEscala
    
    li $a0, 19
    li $a1, 64	
    la $a2, txtAlunos
    lw $a3, corBranco
    jal EscreverTexto
    
    #==================================================
    # PRESS SPACE
    #==================================================
    li $t0, 1
    sw $t0, fonteEscala

    li $a0, 5          # posição X
    li $a1, 85          # posição Y
    la $a2, txtPressSpace
    lw $a3, corAzul
    jal EscreverTexto
    
    jal DesenharSublinhadoPressSpace
    
    jal SwapBuffers
AguardaInicio:
    jal TeclaPronta
    beq $v0, $zero, AguardaInicioSleep
    li $t0, 119
    beq $v1, $t0, FimTelaInicial
    li $t0, 87
    beq $v1, $t0, FimTelaInicial
    li $t0, 32
    bne $v1, $t0, AguardaInicioSleep
    j FimTelaInicial
AguardaInicioSleep:
    jal SleepFrame
    j AguardaInicio
FimTelaInicial:
    li $t0, 1
    sw $t0, fonteEscala
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra

TelaPerdeu:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)
    jal LimparTela
    li $a0, 28
    li $a1, 60
    la $a2, txtPerdeu
    lw $a3, corVermelho
    jal EscreverTexto
    jal SwapBuffers
    li $a0, 1600
    jal SleepMs
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra

TelaVitoria:
    addiu $sp,$sp,-4
    sw $ra,0($sp)

    jal LimparTela

####################################################
# VITORIA!
####################################################

    li $t0,2
    sw $t0,fonteEscala

    li $a0,23
    li $a1,24
    la $a2,txtVenceu
    lw $a3,corAmarelo
    jal EscreverTexto

####################################################
# PONTOS:  200
####################################################

    li $t0,1
    sw $t0,fonteEscala

    li $a0,30
    li $a1,52
    la $a2,txtPontos200		# Tela Vitória
    lw $a3,corBranco
    jal EscreverTexto

####################################################
# PRESS SPACE
####################################################
    li $t0,1
    sw $t0,fonteEscala

    li $a0,30
    li $a1,95
    la $a2,txtPlayAgain1
    lw $a3,corAzul
    jal EscreverTexto

    jal DesenharSublinhadoPlayAgain1

####################################################
# TO PLAY AGAIN
####################################################
    li $t0,1
    sw $t0,fonteEscala

    li $a0,25
    li $a1,108
    la $a2,txtPlayAgain2
    lw $a3,corAzul
    jal EscreverTexto

    jal DesenharSublinhadoPlayAgain2

    jal SwapBuffers
    
    lw $ra,0($sp)
    addiu $sp,$sp,4
    jr $ra

####################################################
# AGUARDA ESPAÇO PARA REINICIAR O JOGO
####################################################

EsperaReinicio:

LoopEsperaReinicio:

    jal TeclaPronta
    beq $v0,$zero,SemTeclaReinicio

    li $t0,32          # Espaço
    bne $v1,$t0,SemTeclaReinicio

####################################################
# Reinicia o jogo
####################################################

    jal ReiniciarJogo

    j LoopJogo

SemTeclaReinicio:

    jal SleepFrame

    j LoopEsperaReinicio

TeclaPronta:
    li $t0, 0xffff0000
    lw $t1, 0($t0)
    andi $t1, $t1, 1
    beq $t1, $zero, SemTecla
    lw $v1, 4($t0)
    li $v0, 1
    jr $ra
SemTecla:
    move $v0, $zero
    move $v1, $zero
    jr $ra

LerTeclado:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)

LoopLerTeclado:
    jal TeclaPronta
    beq $v0, $zero, FimLerTeclado  # Se não houver mais teclas na fila, sai do loop

    lw $t0, playerX                # Carrega a posição atual do avião

    li $t1, 97
    beq $v1, $t1, TeclaEsq
    li $t1, 65
    beq $v1, $t1, TeclaEsq
    li $t1, 100
    beq $v1, $t1, TeclaDir
    li $t1, 68
    beq $v1, $t1, TeclaDir
    li $t1, 32
    beq $v1, $t1, TeclaTiro
    j LoopLerTeclado               # Se for uma tecla inútil, ignora e lê a próxima

TeclaEsq:
    addiu $t0, $t0, -7             # Tenta mover para a esquerda
    
    lw $t1, scenario               # Verifica qual o cenário atual
    li $t2, 26                     # Limite esquerdo do rio largo
    li $t3, 2
    bne $t1, $t3, AplicaLimiteEsq
    li $t2, 22                     # Limite esquerdo do rio largo
    
AplicaLimiteEsq:
    bge $t0, $t2, SalvaPlayerX
    move $t0, $t2                  # Trava na margem exata se tentar passar
SalvaPlayerX:
    sw $t0, playerX
    j LoopLerTeclado               

TeclaDir:
    addiu $t0, $t0, 7              # Tenta mover para a direita
    
    lw $t1, scenario               # Verifica qual o cenário atual
    li $t2, 101                    # Limite direito do rio largo
    li $t3, 2
    bne $t1, $t3, AplicaLimiteDir
    li $t2, 105                    # Limite direito do rio largo
    
AplicaLimiteDir:
    ble $t0, $t2, SalvaPlayerX2
    move $t0, $t2                  # Trava na margem exata se tentar passar
SalvaPlayerX2:
    sw $t0, playerX
    j LoopLerTeclado

###############################################################################
# DISPARA UM NOVO TIRO
###############################################################################

TeclaTiro:

    la   $t0, tiroAtivo
    la   $t1, tiroX
    la   $t2, tiroY

    li   $t6, MAX_TIROS

ProcuraSlotLivre:

    lw   $t3, 0($t0)

    beq  $t3, $zero, CriarNovoTiro

    addiu $t0, $t0, 4
    addiu $t1, $t1, 4
    addiu $t2, $t2, 4

    addiu $t6, $t6, -1
    bgtz  $t6, ProcuraSlotLivre

    j LoopLerTeclado

CriarNovoTiro:

    li   $t3, 1
    sw   $t3, 0($t0)

    lw   $t4, playerX
    sw   $t4, 0($t1)

    lw   $t5, playerY
    addiu $t5, $t5, -12
    sw   $t5, 0($t2)

    j LoopLerTeclado

FimLerTeclado:
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra

AtualizarJogo:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)

    lw $t0, frame
    addiu $t0, $t0, 1
    sw $t0, frame

    andi $t1, $t0, 1
    bne $t1, $zero, SemScrollCenario
    lw $t2, cenarioOffset
    addiu $t2, $t2, 1
    li $t3, 116
    blt $t2, $t3, SalvarScrollCenario
    move $t2, $zero
SalvarScrollCenario:
    sw $t2, cenarioOffset
SemScrollCenario:

    li $t1, 360
    div $t0, $t1
    mflo $t2
    andi $t2, $t2, 1
    addiu $t2, $t2, 4	# Velocidade com que o Cenário se Movimenta pra Baixo
    sw $t2, scenario

    li $t1, 5		# Velocidade de Redução do Ponteiro Marcador do Combustível (Nº Maiores, Diminuel / Nº Menores, Aumentam)
    div $t0, $t1
    mfhi $t2
    bne $t2, $zero, SemGasto
    lw $t3, fuel
    addiu $t3, $t3, -1
    sw $t3, fuel
    bgtz $t3, SemGasto
    sw $zero, fuel
    li $t4, 1
    sw $t4, gameOver
SemGasto:

    jal AtualizarTiro
    jal AtualizarInimigos

    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra

###############################################################################
# Atualiza todos os tiros
###############################################################################

AtualizarTiro:

    la $t0, tiroAtivo
    la $t1, tiroY

    li   $t2, MAX_TIROS

LoopAtualizaTiros:

    lw   $t3,0($t0)

    beq  $t3,$zero,ProximoTiro

    lw   $t4,0($t1)

    addiu $t4,$t4,-5

    sw   $t4,0($t1)

    bgtz $t4,ProximoTiro

    sw   $zero,0($t0)

ProximoTiro:

    addiu $t0,$t0,4
    addiu $t1,$t1,4

    addiu $t2,$t2,-1

    bgtz $t2,LoopAtualizaTiros

    jr $ra
    
###############################################################################
# Procura um slot livre para um novo tiro
#
# Entrada:
#   nenhuma
#
# Saída:
#   v0 = índice do slot livre
#   v0 = -1 se não existir slot disponível
###############################################################################

AtualizarInimigos:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)

    jal MoverHelicoptero
    jal MoverAviaoInimigoNPC
    jal MoverNavioNPC
    jal MoverFuel

    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra

MoverHelicoptero:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)

    lw $t0, enemy1Y
    addiu $t0, $t0, 2
    sw $t0, enemy1Y

    lw $t1, enemy1X
    lw $t2, enemy1Dir
    addu $t1, $t1, $t2
    sw $t1, enemy1X

    lw $t3, scenario
    li $t4, 2
    beq $t3, $t4, LimitesHeliCenario2
    li $t5, 27
    li $t6, 101
    j TestaLimitesHeli
LimitesHeliCenario2:
    li $t5, 23
    li $t6, 105
TestaLimitesHeli:
    blt $t1, $t5, HeliBateuEsquerda
    bgt $t1, $t6, HeliBateuDireita
    j ChecaResetHeli
HeliBateuEsquerda:
    sw $t5, enemy1X
    li $t2, 1
    sw $t2, enemy1Dir
    j ChecaResetHeli
HeliBateuDireita:
    sw $t6, enemy1X
    li $t2, -1
    sw $t2, enemy1Dir
ChecaResetHeli:
    li $t1, 116
    blt $t0, $t1, FimMoverHelicoptero
    jal NovoXNoRio
    sw $v0, enemy1X
    li $t2, -18
    sw $t2, enemy1Y
FimMoverHelicoptero:
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra

MoverAviaoInimigoNPC:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)

    lw $t0, enemy2Y
    addiu $t0, $t0, 3
    sw $t0, enemy2Y

    lw $t1, enemy2X
    lw $t2, enemy2Dir
    addu $t1, $t1, $t2
    addu $t1, $t1, $t2
    sw $t1, enemy2X

    li $t5, 8
    li $t6, 120
    blt $t1, $t5, AviaoNPCBateuEsquerda
    bgt $t1, $t6, AviaoNPCBateuDireita
    j ChecaResetAviaoNPC
AviaoNPCBateuEsquerda:
    sw $t5, enemy2X
    li $t2, 1
    sw $t2, enemy2Dir
    j ChecaResetAviaoNPC
AviaoNPCBateuDireita:
    sw $t6, enemy2X
    li $t2, -1
    sw $t2, enemy2Dir
ChecaResetAviaoNPC:
    li $t1, 116
    blt $t0, $t1, FimMoverAviaoNPC
    jal NovoXNaTela
    sw $v0, enemy2X
    li $t2, -24
    sw $t2, enemy2Y
FimMoverAviaoNPC:
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra

MoverNavioNPC:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)

    lw $t0, shipY
    addiu $t0, $t0, 2
    sw $t0, shipY

    lw $t1, shipX
    lw $t2, shipDir
    addu $t1, $t1, $t2
    sw $t1, shipX

    lw $t3, scenario
    li $t4, 2
    beq $t3, $t4, LimitesNavioCenario2
    li $t5, 28
    li $t6, 100
    j TestaLimitesNavio
LimitesNavioCenario2:
    li $t5, 24
    li $t6, 104
TestaLimitesNavio:
    blt $t1, $t5, NavioBateuEsquerda
    bgt $t1, $t6, NavioBateuDireita
    j ChecaResetNavio
NavioBateuEsquerda:
    sw $t5, shipX
    li $t2, 1
    sw $t2, shipDir
    j ChecaResetNavio
NavioBateuDireita:
    sw $t6, shipX
    li $t2, -1
    sw $t2, shipDir
ChecaResetNavio:
    li $t1, 116
    blt $t0, $t1, FimMoverNavio
    jal NovoXNoRio
    sw $v0, shipX
    li $t2, -34
    sw $t2, shipY
FimMoverNavio:
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra

MoverFuel:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)
    lw $t0, fuelY
    addiu $t0, $t0, 2
    sw $t0, fuelY
    li $t1, 116
    blt $t0, $t1, FimMoverFuel
    jal NovoXNoRio
    sw $v0, fuelX
    li $t2, -16
    sw $t2, fuelY
FimMoverFuel:
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra

NovoXNoRio:
    lw $t0, seed
    li $t1, 53
    mul $t0, $t0, $t1
    addiu $t0, $t0, 17
    andi $t0, $t0, 255
    sw $t0, seed
    lw $t2, scenario
    li $t3, 2
    beq $t2, $t3, NovoXEstreito
    li $t4, 74
    div $t0, $t4
    mfhi $t0
    addiu $v0, $t0, 27
    jr $ra
NovoXEstreito:
    li $t4, 82
    div $t0, $t4
    mfhi $t0
    addiu $v0, $t0, 23
    jr $ra

NovoXNaTela:
    lw $t0, seed
    li $t1, 29
    mul $t0, $t0, $t1
    addiu $t0, $t0, 7
    andi $t0, $t0, 255
    sw $t0, seed
    li $t4, 109
    div $t0, $t4
    mfhi $t0
    addiu $v0, $t0, 10
    jr $ra

ChecarColisoes:
    addiu $sp, $sp, -20
    sw $ra, 16($sp)
    sw $s0, 12($sp)
    sw $s1, 8($sp)
    sw $s2, 4($sp)
    sw $s3, 0($sp)

    lw $t0, fuel
    bgtz $t0, ColisaoObjetos
    sw $zero, fuel
    li $t1, 1
    sw $t1, gameOver
    j FimColisoes

ColisaoObjetos:
    lw $a0, playerX
    lw $a1, playerY
    lw $a2, enemy1X
    lw $a3, enemy1Y
    jal Colide12
    bne $v0, $zero, PerdePorColisao

    lw $a0, playerX
    lw $a1, playerY
    lw $a2, enemy2X
    lw $a3, enemy2Y
    jal Colide12
    bne $v0, $zero, PerdePorColisao

    lw $a0, playerX
    lw $a1, playerY
    lw $a2, shipX
    lw $a3, shipY
    jal Colide12
    bne $v0, $zero, PerdePorColisao

    lw $a0, playerX
    lw $a1, playerY
    lw $a2, fuelX
    lw $a3, fuelY
    jal Colide12
    beq $v0, $zero, ChecarTiroInimigo
    li $t0, 100
    sw $t0, fuel
    jal ReposicionarFuel

ChecarTiroInimigo:
    la $s0, tiroAtivo
    la $s1, tiroX
    la $s2, tiroY
    li $s3, MAX_TIROS

LoopChecarTiros:
    lw $t0, 0($s0)
    beq $t0, $zero, ProximoTiroColisao
    lw $a0, 0($s1)
    lw $a1, 0($s2)
    lw $a2, enemy1X
    lw $a3, enemy1Y
    jal Colide10
    bne $v0, $zero, AcertouEnemy1

    lw $a0, 0($s1)
    lw $a1, 0($s2)
    lw $a2, enemy2X
    lw $a3, enemy2Y
    jal Colide10
    bne $v0, $zero, AcertouEnemy2

    lw $a0, 0($s1)
    lw $a1, 0($s2)
    lw $a2, shipX
    lw $a3, shipY
    jal Colide10
    bne $v0, $zero, AcertouNavio

ProximoTiroColisao:
    addiu $s0, $s0, 4
    addiu $s1, $s1, 4
    addiu $s2, $s2, 4
    addiu $s3, $s3, -1
    bgtz $s3, LoopChecarTiros
    j FimColisoes

AcertouEnemy1:
    sw $zero, 0($s0)
    lw $t0, score
    addiu $t0, $t0, 10
    sw $t0, score
    la $a0, enemy1X
    jal ReposicionarObjeto
    j VerificarVitoria

AcertouEnemy2:
    sw $zero, 0($s0)
    lw $t0, score
    addiu $t0, $t0, 10
    sw $t0, score
    jal ReposicionarAviaoInimigoNPC
    j VerificarVitoria

AcertouNavio:
    sw $zero, 0($s0)
    lw $t0, score
    addiu $t0, $t0, 10
    sw $t0, score
    jal ReposicionarNavio
    j VerificarVitoria

PerdePorColisao:
    li $t0, 1
    sw $t0, gameOver

####################################################
# Verifica vitória
####################################################

VerificarVitoria:

    lw  $t0, score
    li  $t1, 200	# Pontuação que o jogador vence o jogo
    blt $t0, $t1, FimColisoes

    li  $t2, 1
    sw  $t2, gameWin

    j FimColisoes

FimColisoes:
    lw $s3, 0($sp)
    lw $s2, 4($sp)
    lw $s1, 8($sp)
    lw $s0, 12($sp)
    lw $ra, 16($sp)
    addiu $sp, $sp, 20
    jr $ra

ReposicionarFuel:
    la $a0, fuelX
    j ReposicionarObjeto

ReposicionarAviaoInimigoNPC:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)
    jal NovoXNaTela
    sw $v0, enemy2X
    li $t0, -24
    sw $t0, enemy2Y
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra

ReposicionarNavio:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)
    jal NovoXNoRio
    sw $v0, shipX
    li $t0, -34
    sw $t0, shipY
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra

ReposicionarObjeto:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)
    jal NovoXNoRio
    sw $v0, 0($a0)
    li $t0, -16
    sw $t0, 4($a0)
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra

XNoRio:
    lw $t0, scenario
    li $t1, 2
    beq $t0, $t1, XNoRioEstreito
    li $t2, 20
    li $t3, 107
    j TestaXNoRio
XNoRioEstreito:
    li $t2, 16
    li $t3, 111
TestaXNoRio:
    li $v0, 0
    blt $a0, $t2, FimXNoRio
    bgt $a0, $t3, FimXNoRio
    li $v0, 1
FimXNoRio:
    jr $ra

Colide12:
    li $t4, 12
    j ColideGenerico
Colide10:
    li $t4, 10
ColideGenerico:
    subu $t0, $a0, $a2
    abs $t0, $t0
    subu $t1, $a1, $a3
    abs $t1, $t1
    li $v0, 0
    bgt $t0, $t4, FimColide
    bgt $t1, $t4, FimColide
    li $v0, 1
FimColide:
    jr $ra

DesenharObjetos:
    addiu $sp, $sp, -20
    sw $ra, 16($sp)
    sw $s0, 12($sp)
    sw $s1, 8($sp)
    sw $s2, 4($sp)
    sw $s3, 0($sp)

    jal DesenharHUD

    lw $a0, enemy1X
    lw $a1, enemy1Y
    jal DesenharHelicoptero

    lw $a0, enemy2X
    lw $a1, enemy2Y
    jal DesenharAviaoInimigo

    lw $a0, shipX
    lw $a1, shipY
    jal DesenharNavio

    lw $a0, fuelX
    lw $a1, fuelY
    jal DesenharDeposito

    la $s0, tiroAtivo
    la $s1, tiroX
    la $s2, tiroY
    li $s3, MAX_TIROS

LoopDesenharTiros:
    lw $t0, 0($s0)
    beq $t0, $zero, ProximoDesenharTiro

    lw $a0, 0($s1)
    lw $a1, 0($s2)
    jal DesenharTiro

ProximoDesenharTiro:
    addiu $s0, $s0, 4
    addiu $s1, $s1, 4
    addiu $s2, $s2, 4
    addiu $s3, $s3, -1
    bgtz $s3, LoopDesenharTiros

    lw $a0, playerX
    lw $a1, playerY
    jal DesenharPlayer

    lw $s3, 0($sp)
    lw $s2, 4($sp)
    lw $s1, 8($sp)
    lw $s0, 12($sp)
    lw $ra, 16($sp)
    addiu $sp, $sp, 20
    jr $ra

DesenharSprite:
    addiu $sp, $sp, -28
    sw $ra, 24($sp)
    sw $s0, 20($sp)
    sw $s1, 16($sp)
    sw $s2, 12($sp)
    sw $s3, 8($sp)
    sw $s4, 4($sp)
    sw $s5, 0($sp)

    move $s0, $a0
    move $s1, $a1
    move $s2, $a2 
    move $s3, $a3 
    move $s4, $t9 

    li $s5, 0 
SpriteLoopY:
    bge $s5, $s4, FimSprite
    li $t0, 0 
SpriteLoopX:
    bge $t0, $s3, ProxSpriteLinha
    
    lw $t1, 0($s2) 
    addiu $s2, $s2, 4 
    
    beq $t1, $zero, PulaPixelVisivel 
    
    li $t2, 1
    beq $t1, $t2, SetAmarelo
    li $t2, 2
    beq $t1, $t2, SetVermelho
    li $t2, 3
    beq $t1, $t2, SetBranco
    li $t2, 4
    beq $t1, $t2, SetAzulEscuro
    li $t2, 5
    beq $t1, $t2, SetCinza
    li $t2, 6
    beq $t1, $t2, SetVerdeSprite
    li $t2, 7
    beq $t1, $t2, SetPretoSprite
    li $t2, 8
    beq $t1, $t2, SetCianoSprite
    j PulaPixelVisivel

SetAmarelo:
    lw $a2, corAmarelo
    j DesenhaPontoSprite
SetVermelho:
    lw $a2, corVermelho
    j DesenhaPontoSprite
SetBranco:
    lw $a2, corBranco
    j DesenhaPontoSprite
SetAzulEscuro:
    lw $a2, corAzulEscuro
    j DesenhaPontoSprite
SetCinza:
    lw $a2, corCinza
    j DesenhaPontoSprite
SetVerdeSprite:
    lw $a2, corVerde2
    j DesenhaPontoSprite
SetPretoSprite:
    lw $a2, corPreto
    j DesenhaPontoSprite
SetCianoSprite:
    lw $a2, corCiano

DesenhaPontoSprite:
    addu $a0, $s0, $t0 
    addu $a1, $s1, $s5 
    jal Pixel

PulaPixelVisivel:
    addiu $t0, $t0, 1
    j SpriteLoopX

ProxSpriteLinha:
    addiu $s5, $s5, 1
    j SpriteLoopY

FimSprite:
    lw $s5, 0($sp)
    lw $s4, 4($sp)
    lw $s3, 8($sp)
    lw $s2, 12($sp)
    lw $s1, 16($sp)
    lw $s0, 20($sp)
    lw $ra, 24($sp)
    addiu $sp, $sp, 28
    jr $ra

DesenharPlayer:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)
    addiu $a0, $a0, -6
    addiu $a1, $a1, -6
    la $a2, spriteAviao
    li $a3, 13
    li $t9, 13
    jal DesenharSprite
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra

DesenharHelicoptero:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)
    addiu $a0, $a0, -6
    addiu $a1, $a1, -4
    la $a2, spriteHeli
    li $a3, 13
    li $t9, 9
    jal DesenharSprite
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra

DesenharAviaoInimigo:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)
    addiu $a0, $a0, -7
    addiu $a1, $a1, -3
    la $a2, spriteInimigo
    li $a3, 15
    li $t9, 7
    jal DesenharSprite
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra

DesenharNavio:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)
    addiu $a0, $a0, -7
    addiu $a1, $a1, -3
    la $a2, spriteNavio
    li $a3, 15
    li $t9, 7
    jal DesenharSprite
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra

DesenharDeposito:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)
    addiu $a0, $a0, -4
    addiu $a1, $a1, -5
    la $a2, spriteFuel
    li $a3, 9
    li $t9, 11
    jal DesenharSprite
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra

DesenharTiro:
    addiu $a0, $a0, -1
    li $a2, 1		# Largura da Bala
    li $a3, 4		# Altura da Bala
    lw $t8, corBranco
    j RetanguloRapido

DesenharCenarioCompleto:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)

    

    lw $t0, scenario
    li $t1, 2
    beq $t0, $t1, DesenharCenario2

DesenharCenario1:
    li $a0, 0
    li $a1, 0
    li $a2, 20
    li $a3, 116
    lw $t8, corVerde
    jal RetanguloRapido
    li $a0, 20
    li $a1, 0
    li $a2, 88
    li $a3, 116
    lw $t8, corAzul
    jal RetanguloRapido
    li $a0, 108
    li $a1, 0
    li $a2, 20
    li $a3, 116
    lw $t8, corVerde
    jal RetanguloRapido
    j CenarioCompletoFim

DesenharCenario2:
    li $a0, 0
    li $a1, 0
    li $a2, 16
    li $a3, 116
    lw $t8, corVerde2
    jal RetanguloRapido
    li $a0, 16
    li $a1, 0
    li $a2, 96
    li $a3, 116
    lw $t8, corAzul
    jal RetanguloRapido
    li $a0, 112
    li $a1, 0
    li $a2, 16
    li $a3, 116
    lw $t8, corVerde2
    jal RetanguloRapido

CenarioCompletoFim:
    jal DesenharDecoracoes
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra

DesenharDecoracoes:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)

    lw $t0, scenario
    li $t1, 2
    beq $t0, $t1, DecoracoesCenario2

    li $a0, 6
    li $a1, 18
    jal DesenharArvoreRolando
    li $a0, 12
    li $a1, 53
    jal DesenharArvoreRolando
    li $a0, 7
    li $a1, 90
    jal DesenharArvoreRolando
    li $a0, 116
    li $a1, 28
    jal DesenharArvoreRolando
    li $a0, 121
    li $a1, 72
    jal DesenharArvoreRolando
    li $a0, 13
    li $a1, 35
    jal DesenharPedraRolando
    li $a0, 111
    li $a1, 96
    jal DesenharPedraRolando
    j FimDecoracoes

DecoracoesCenario2:
    li $a0, 5
    li $a1, 24
    jal DesenharArvoreRolando
    li $a0, 10
    li $a1, 82
    jal DesenharArvoreRolando
    li $a0, 117
    li $a1, 38
    jal DesenharArvoreRolando
    li $a0, 122
    li $a1, 91
    jal DesenharArvoreRolando
    li $a0, 3
    li $a1, 58
    jal DesenharPedraRolando
    li $a0, 114
    li $a1, 64
    jal DesenharPedraRolando

FimDecoracoes:
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra

DesenharArvoreRolando:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)
    jal AjustarYDecoracao
    jal DesenharArvore
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra

DesenharPedraRolando:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)
    jal AjustarYDecoracao
    jal DesenharPedra
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra

AjustarYDecoracao:
    lw $t0, cenarioOffset
    addu $a1, $a1, $t0
    li $t1, 116
    blt $a1, $t1, FimAjustarYDecoracao
    subu $a1, $a1, $t1
FimAjustarYDecoracao:
    jr $ra

DesenharArvore:
    addiu $sp, $sp, -12
    sw $ra, 8($sp)
    sw $s0, 4($sp)
    sw $s1, 0($sp)
    move $s0, $a0
    move $s1, $a1

    move $a0, $s0
    move $a1, $s1
    lw $a2, corVerdeEscuro
    jal Pixel

    addiu $a0, $s0, -1
    addiu $a1, $s1, 1
    li $a2, 3
    li $a3, 2
    lw $t8, corVerdeEscuro
    jal RetanguloRapido

    addiu $a0, $s0, -2
    addiu $a1, $s1, 3
    li $a2, 5
    li $a3, 2
    lw $t8, corVerdeEscuro
    jal RetanguloRapido

    move $a0, $s0
    addiu $a1, $s1, 5
    li $a2, 1
    li $a3, 2
    lw $t8, corMarrom
    jal RetanguloRapido

    lw $s1, 0($sp)
    lw $s0, 4($sp)
    lw $ra, 8($sp)
    addiu $sp, $sp, 12
    jr $ra

DesenharPedra:
    addiu $sp, $sp, -12
    sw $ra, 8($sp)
    sw $s0, 4($sp)
    sw $s1, 0($sp)
    move $s0, $a0
    move $s1, $a1

    move $a0, $s0
    move $a1, $s1
    li $a2, 4
    li $a3, 2
    lw $t8, corPedra
    jal RetanguloRapido

    addiu $a0, $s0, 1
    move $a1, $s1
    lw $a2, corBranco
    jal Pixel

    lw $s1, 0($sp)
    lw $s0, 4($sp)
    lw $ra, 8($sp)
    addiu $sp, $sp, 12
    jr $ra

DesenharHUD:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)

    li $t0, 1
    sw $t0, fonteEscala

    li $a0, 0
    li $a1, 116
    li $a2, 128
    li $a3, 12
    lw $t8, corCinza
    jal RetanguloRapido

    jal DesenharPontuacaoHUD

    li $a0, 39
    li $a1, 121
    li $a2, 50
    li $a3, 7
    lw $t8, corPreto
    jal RetanguloRapido

    li $a0, 41
    li $a1, 122
    li $a2, 46
    li $a3, 5
    lw $t8, corCinza
    jal RetanguloRapido

    li $a0, 43
    li $a1, 122
    li $a2, 69
    lw $a3, corPreto
    jal DesenharChar

    li $a0, 57
    li $a1, 122
    li $a2, 49
    lw $a3, corPreto
    jal DesenharChar

    li $a0, 68
    li $a1, 122
    li $a2, 50
    lw $a3, corPreto
    jal DesenharChar

    li $a0, 80
    li $a1, 122
    li $a2, 70
    lw $a3, corPreto
    jal DesenharChar

    jal DesenharBarraMeioHUD

    lw $t0, fuel
    blez $t0, FuelHUDZero
    li $t1, 100
    ble $t0, $t1, FuelHUDBounded
    move $t0, $t1
    j FuelHUDBounded
FuelHUDZero:
    move $t0, $zero
FuelHUDBounded:
    li $t1, 35
    mul $t0, $t0, $t1
    li $t1, 100
    div $t0, $t1
    mflo $t0
    addiu $a0, $t0, 49
    li $a1, 122
    li $a2, 3
    li $a3, 5
    lw $t8, corAmarelo
    jal RetanguloRapido

    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra

DesenharBarraMeioHUD:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)

    lw $a2, corPreto
    li $a0, 62
    li $a1, 126
    jal Pixel
    li $a0, 63
    li $a1, 125
    jal Pixel
    li $a0, 64
    li $a1, 124
    jal Pixel
    li $a0, 65
    li $a1, 123
    jal Pixel
    li $a0, 66
    li $a1, 122
    jal Pixel

    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra

DesenharPontuacaoHUD:
    addiu $sp, $sp, -20
    sw $ra, 16($sp)
    sw $s0, 12($sp)
    sw $s1, 8($sp)
    sw $s2, 4($sp)
    sw $s3, 0($sp)

    lw $s0, score
    li $t0, 10000
    div $s0, $t0
    mfhi $s0

    li $s2, 52
    li $s3, 116

    li $s1, 1000
    div $s0, $s1
    mflo $t1
    mfhi $s0
    move $a0, $s2
    move $a1, $s3
    addiu $a2, $t1, 48
    lw $a3, corAmarelo
    jal DesenharChar

    addiu $s2, $s2, 6
    li $s1, 100
    div $s0, $s1
    mflo $t1
    mfhi $s0
    move $a0, $s2
    move $a1, $s3
    addiu $a2, $t1, 48
    lw $a3, corAmarelo
    jal DesenharChar

    addiu $s2, $s2, 6
    li $s1, 10
    div $s0, $s1
    mflo $t1
    mfhi $s0
    move $a0, $s2
    move $a1, $s3
    addiu $a2, $t1, 48
    lw $a3, corAmarelo
    jal DesenharChar

    addiu $s2, $s2, 6
    move $a0, $s2
    move $a1, $s3
    addiu $a2, $s0, 48
    lw $a3, corAmarelo
    jal DesenharChar

    lw $s3, 0($sp)
    lw $s2, 4($sp)
    lw $s1, 8($sp)
    lw $s0, 12($sp)
    lw $ra, 16($sp)
    addiu $sp, $sp, 20
    jr $ra

LimparTela:
    li $a0, 0
    li $a1, 0
    li $a2, 128
    li $a3, 128
    lw $t8, corPreto
    j RetanguloRapido

RetanguloRapido:
    addiu $sp, $sp, -28
    sw $ra, 24($sp)
    sw $s0, 20($sp)
    sw $s1, 16($sp)
    sw $s2, 12($sp)
    sw $s3, 8($sp)
    sw $s4, 4($sp)
    sw $s5, 0($sp)

    bltz $a0, FimRetRapido
    bltz $a1, FimRetRapido
    li $t0, 128
    bge $a0, $t0, FimRetRapido
    bge $a1, $t0, FimRetRapido

    la $s0, framebuffer
    sll $s1, $a1, 7
    addu $s1, $s1, $a0
    sll $s1, $s1, 2
    addu $s0, $s0, $s1
    move $s2, $a2
    move $s3, $a3
    move $s4, $zero

LinhaRetRapido:
    bge $s4, $s3, FimRetRapido
    move $s5, $s0
    move $t0, $zero
ColunaRetRapido:
    bge $t0, $s2, ProximaLinhaRetRapido
    sw $t8, 0($s5)
    addiu $s5, $s5, 4
    addiu $t0, $t0, 1
    j ColunaRetRapido
ProximaLinhaRetRapido:
    addiu $s0, $s0, 512
    addiu $s4, $s4, 1
    j LinhaRetRapido

FimRetRapido:
    lw $s5, 0($sp)
    lw $s4, 4($sp)
    lw $s3, 8($sp)
    lw $s2, 12($sp)
    lw $s1, 16($sp)
    lw $s0, 20($sp)
    lw $ra, 24($sp)
    addiu $sp, $sp, 28
    jr $ra

Pixel:
    bltz $a0, FimPixel
    bltz $a1, FimPixel
    li $t4, 127
    bgt $a0, $t4, FimPixel
    bgt $a1, $t4, FimPixel
    sll $t4, $a1, 7
    addu $t4, $t4, $a0
    sll $t4, $t4, 2
    la $t5, framebuffer
    addu $t5, $t5, $t4
    sw $a2, 0($t5)
FimPixel:
    jr $ra

EscreverTexto:
    addiu $sp, $sp, -20
    sw $ra, 16($sp)
    sw $a0, 12($sp)
    sw $a1, 8($sp)
    sw $a2, 4($sp)
    sw $a3, 0($sp)
TextoLoop:
    lw $t0, 4($sp)
    lb $t1, 0($t0)
    beq $t1, $zero, FimTexto
    lw $a0, 12($sp)
    lw $a1, 8($sp)
    move $a2, $t1
    lw $a3, 0($sp)
    jal DesenharChar
    lw $t0, 4($sp)
    addiu $t0, $t0, 1
    sw $t0, 4($sp)
    lw $t2, 12($sp)
    lw $t3, fonteEscala
    li $t4, 5
    mul $t4, $t4, $t3
    addiu $t4, $t4, 1
    addu $t2, $t2, $t4
    sw $t2, 12($sp)
    j TextoLoop
FimTexto:
    lw $ra, 16($sp)
    addiu $sp, $sp, 20
    jr $ra

DesenharChar:
    addiu $sp, $sp, -44
    sw $ra, 40($sp)
    sw $s0, 36($sp)
    sw $s1, 32($sp)
    sw $s2, 28($sp)
    sw $s3, 24($sp)
    sw $s4, 20($sp)
    sw $a0, 16($sp)
    sw $a1, 12($sp)
    sw $a2, 8($sp)
    sw $a3, 4($sp)

    # Identificação das letras 
    li $t0, 32
    beq $a2, $t0, FimChar
    li $t0, 33
    beq $a2, $t0, CharExclamacao
    li $t0, 48
    beq $a2, $t0, Char0
    li $t0, 49
    beq $a2, $t0, Char1
    li $t0, 50
    beq $a2, $t0, Char2
    li $t0, 51
    beq $a2, $t0, Char3
    li $t0, 52
    beq $a2, $t0, Char4
    li $t0, 53
    beq $a2, $t0, Char5
    li $t0, 54
    beq $a2, $t0, Char6
    li $t0, 55
    beq $a2, $t0, Char7
    li $t0, 56
    beq $a2, $t0, Char8
    li $t0, 57
    beq $a2, $t0, Char9
    # (aqui você mantém todos os seus "beq $a2, $t0, CharX" atuais)
    li $t0, 65
    beq $a2, $t0, CharA
    li $t0, 67
    beq $a2, $t0, CharC
    li $t0, 68
    beq $a2, $t0, CharD
    li $t0, 69
    beq $a2, $t0, CharE
    li $t0, 70
    beq $a2, $t0, CharF
    li $t0, 71
    beq $a2, $t0, CharG
    li $t0, 73
    beq $a2, $t0, CharI
    li $t0, 74
    beq $a2, $t0, CharJ
    li $t0, 76
    beq $a2, $t0, CharL
    li $t0, 77
    beq $a2, $t0, CharM
    li $t0, 78
    beq $a2, $t0, CharN
    li $t0, 79
    beq $a2, $t0, CharO
    li $t0, 80
    beq $a2, $t0, CharP
    li $t0, 82
    beq $a2, $t0, CharR
    li $t0, 83
    beq $a2, $t0, CharS
    li $t0, 84
    beq $a2, $t0, CharT
    li $t0, 85
    beq $a2, $t0, CharU
    li $t0, 86
    beq $a2, $t0, CharV
    li $t0, 89
    beq $a2, $t0, CharY
    # (continue com todas as suas letras) 
    j FimChar

CharA:
    li $s4, 0xe8fe31
    j MatrizChar
# (adicione todas as suas outras letras aqui)

Char0:
    li $s4, 0xe9d72e
    j MatrizChar
Char1:
    li $s4, 0x46108e
    j MatrizChar
Char2:
    li $s4, 0x1e0ba1f
    j MatrizChar
Char3:
    li $s4, 0x1e0b83e
    j MatrizChar
Char4:
    li $s4, 0x1297c42
    j MatrizChar
Char5:
    li $s4, 0x1f8783e
    j MatrizChar
Char6:
    li $s4, 0xe87a2e
    j MatrizChar
Char7:
    li $s4, 0x1f08884
    j MatrizChar
Char8:
    li $s4, 0xe8ba2e
    j MatrizChar
Char9:
    li $s4, 0xe8bc2e
    j MatrizChar
CharExclamacao:
    li $s4, 0x421004
    j MatrizChar
    li $t0,58
    beq $a2,$t0,CharDoisPontos
CharDoisPontos:
    li $s4,0x40004
    j MatrizChar
CharC:
    li $s4, 0xf8420f
    j MatrizChar
CharD:
    li $s4, 0x1e8c63e
    j MatrizChar
CharE:
    li $s4, 0x1f87a1f
    j MatrizChar
CharF:
    li $s4, 0x1f87a10
    j MatrizChar
CharG:
    li $s4, 0xf85e2e
    j MatrizChar
CharI:
    li $s4, 0x1f2109f
    j MatrizChar
CharJ:
    li $s4, 0x710a4c
    j MatrizChar
CharL:
    li $s4, 0x108421f
    j MatrizChar
CharM:
    li $s4, 0x11dd631
    j MatrizChar
CharN:
    li $s4,0x18d631
    j MatrizChar
CharO:
    li $s4, 0xe8c62e
    j MatrizChar
CharP:
    li $s4, 0x1e8fa10
    j MatrizChar
CharR:
    li $s4, 0x1e8fa51
    j MatrizChar
CharS:
    li $s4, 0xf8383e
    j MatrizChar
CharT:
    li $s4, 0x1f21084
    j MatrizChar
CharU:
    li $s4, 0x118c62e
    j MatrizChar
CharV:
    li $s4, 0x118a544
    j MatrizChar
CharY:
    li $s4, 0x118ba84
    j MatrizChar

MatrizChar:
    lw $t9, fonteEscala
    bgtz $t9, EscalaOk
    li $t9, 1

EscalaOk:
    li $s0, 0            # Linha atual (0 a 4)
LinhaChar:
    bge $s0, 5, FimChar
    
    # Extrai os 5 bits correspondentes à linha atual
    li $t5, 4
    subu $t5, $t5, $s0
    li $t6, 5
    mul $t5, $t5, $t6
    
    srlv $t7, $s4, $t5   # Move os bits para a posição inicial
    andi $t7, $t7, 31    # Isola os 5 bits (0x1F)

    li $s1, 0            # Coluna atual (0 a 4)
ColunaChar:
    bge $s1, 5, ProxLinhaChar
    
    # Testa o bit da coluna (da esquerda para a direita)
    li $t5, 4
    subu $t5, $t5, $s1
    srlv $t0, $t7, $t5
    andi $t0, $t0, 1
    
    beq $t0, $zero, ProxColunaChar
    
    # Calcula a posição na tela (offset a partir de a0, a1)
    li $s2, 0

LoopEscalaY:
    bge $s2, $t9, ProxColunaChar
    li $s3, 0

LoopEscalaX:
    bge $s3, $t9, ProxEscalaY
    lw $a0, 16($sp)
    lw $a1, 12($sp)
    mul $t1, $s1, $t9
    mul $t2, $s0, $t9
    addu $a0, $a0, $t1
    addu $a0, $a0, $s3
    addu $a1, $a1, $t2
    addu $a1, $a1, $s2
    lw $a2, 4($sp)
    jal Pixel
    addiu $s3, $s3, 1
    j LoopEscalaX

ProxEscalaY:
    addiu $s2, $s2, 1
    j LoopEscalaY
    
ProxColunaChar:
    addiu $s1, $s1, 1
    j ColunaChar
ProxLinhaChar:
    addiu $s0, $s0, 1
    j LinhaChar

FimChar:
    lw $s4, 20($sp)
    lw $s3, 24($sp)
    lw $s2, 28($sp)
    lw $s1, 32($sp)
    lw $s0, 36($sp)
    lw $ra, 40($sp)
    addiu $sp, $sp, 44
    jr $ra

DesenharAcentoJulio:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)
    lw $a2, corBranco
    li $a0, 86
    li $a1, 60
    jal Pixel
    li $a0, 87
    li $a1, 57
    jal Pixel
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra

DesenharSublinhadoTitulo:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Desenha um retângulo (linha contínua) abaixo do título
    li $a0, 9          # X inicial
    li $a1, 33         # Y inicial
    li $a2, 110	       # Largura da linha
    li $a3, 1          # Altura (2 pixels de espessura para ficar visível)
    lw $t8, corAmarelo # Cor amarela
    jal RetanguloRapido
    
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra

DesenharSublinhadoAlunos:
    addiu $sp,$sp,-4
    sw $ra,0($sp)

    li $a0,40
    li $a1,58
    li $a2,42
    li $a3,1
    lw $t8,corBranco
    jal RetanguloRapido

    lw $ra,0($sp)
    addiu $sp,$sp,4
    jr $ra

DesenharSublinhadoPressSpace:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Linha abaixo de "PRESS SPACE"
    li $a0, 5         # X inicial
    li $a1, 93         # Y (85 + 8 = 93)
    li $a2, 120         # Largura
    li $a3, 1          # Espessura
    lw $t8, corAzul    # Cor azul
    jal RetanguloRapido
    
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra

    li $t0,0
    sw $t0,fonteEscala

DesenharSublinhadoPlayAgain1:
    addiu $sp,$sp,-4
    sw $ra,0($sp)

    li $a0,29
    li $a1,102
    li $a2,67
    li $a3,1
    lw $t8,corAzul
    jal RetanguloRapido

    lw $ra,0($sp)
    addiu $sp,$sp,4
    jr $ra


DesenharSublinhadoPlayAgain2:
    addiu $sp,$sp,-4
    sw $ra,0($sp)

    li $a0,25
    li $a1,114
    li $a2,78
    li $a3,1
    lw $t8,corAzul
    jal RetanguloRapido

    lw $ra,0($sp)
    addiu $sp,$sp,4
    jr $ra


DesenharAcentoVoce:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)
    lw $a2, corVermelho
    li $a0, 44
    li $a1, 58
    jal Pixel
    li $a0, 45
    li $a1, 57
    jal Pixel
    li $a0, 46
    li $a1, 58
    jal Pixel
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra

SleepFrame:
    li $a0, 1
    li $v0, 32
    syscall
    jr $ra

SleepMs:
    li $v0, 32
    syscall
    jr $ra
