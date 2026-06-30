# RIVER-RAID - Assembly MIPS (MARS)
-----------------------------------------------------------------------
Este projeto é uma recriação do clássico jogo River Raid, lançado originalmente para o console Atari.

O projeto foi desenvolvido em Assembly (uma linguagem de programação de baixo nível) para a arquitetura de processador MIPS e roda no MARS (um simulador/ambiente que permite que seu computador moderno simule o comportamento de um processador MIPS).
-----------------------------------------------------------------------
Tecnologias Utilizadas:
- Assembly MIPS
- MARS (MIPS Assembler and Runtime Simulator)
- Bitmap Display
- Keyboard and Display MMIO Simulator
-----------------------------------------------------------------------
Como Jogar?
1. Download do Simulador.
Faça o download do simulador MARS pelo link oficial:

🔗 (https://github.com/dpetersanderson/MARS/releases/tag/v.4.5.1)

2. Executando o Jogo:
- Abra o simulador MARS
- Baixe o arquivo RiverRaid.asm disponível neste repositório
- No MARS, abra o arquivo RiverRaid.asm
- Vá até a aba Tools e abra:
    - Bitmap Display
        * Unit Width: 4
        * Unit Height: 4
        * Display Width: 512
        * Display Height: 512
        * Clique em Connect to MIPS
- Ainda na aba Tools, abra:
    - Keyboard and Display MMIO Simulator
        * Clique em Connect to MIPS
- Vá até a aba Run:
    - Clique em Assemble
    - Em seguida, clique em Go
    
Após esses passos, o jogo será iniciado corretamente.
-----------------------------------------------------------------------
🎮 Controles (Teclas):
- A = Mover para a esquerda
- D = Mover para a direita
- ESPAÇO = Atirar