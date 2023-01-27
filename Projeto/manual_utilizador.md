# Dots & Boxes - Manual de Utilizador

## Projeto 2 - IA 2022/2023 (Época Normal)

## Docente

Joaquim Filipe

## Alunos

202001310, Leandro Francisco

201801899, Daniel Lachkeev

## 1. Acrómimos e Convenções Utilizadas

### 1.1 Acrónimos

- `x` - linha.
- `y` - coluna.
- `tabuleiro` - 2 listas de arcos, compostos cada um por linhas.
- `linha(s)` - lista de valores 0 a 2 que correspondem a uma linha horizontal ou vertical no tabuleiro.
- `jogador` - valor 1 ou 2. Jogador 1 começa primeiro.
- `n` e `m`. Dimensão do tabuleiro. n linhas por m colunas.

### 1.2 Convenções

- `funções` - escritas em letra minúscula com palavras separadas por `"-"`.
- Utilização de recursividade sempre que é possível, exceto nos casos de interação e input/output.

## 2. Introdução

`Dots and Boxes` é um jogo de `dois jogadores`, criado por Édouard Lucas, em 1889.

É constituído por um `tabuleiro de caixas`, dispostas em linhas `linhas e colunas`. Cada caixa é
delimitada por `4 pontos`, entre os quais é possível inserir `arcos` (horizontais e verticais). Quando os quatro pontos à volta de
uma caixa estiverem conectados por `4 arcos`, a caixa é considerada `fechada`.

O jogo inicia com um `tabuleiro vazio` e os jogadores, alternadamente, vão colocando um `arco`. Quando o arco colocado por um jogador fecha uma caixa, a mesma conta como `1 ponto`, permitindo uma `outra jogada`.
O jogo termina, quando `todas as caixas estiverem fechadas`.

## 3. Instalação

### Instalação do Ambiente

- Para proceder à instalação da aplicação, deverá registar-se em: http://www.lispworks.com/downloads/index.html

- Deve proceder à escolha do sistema operativo adequado e, em seguida, descarregar o ficheiro de instalação.

- Por último, deve executar o ficheiro de instalação.

### Instalação do Programa

- Deve proceder à transferência e descompactação dos ficheiros necessários ao funcionamento do programa Dots & Boxes:
  - `puzzle.lisp` - ficheiro que contém as funcionalidades do programa.
  - `procura.lisp` - ficheiro que contém a implementação dos algoritmos utilizados pelo programa.
  - `jogo.lisp` - ficheiro que contém os menus de interação com o utilizador e que lhe permite jogar.

  - Execute a aplicação LispWorks.

- Carrege os ficheiros `.lisp` para a aplicação, pela ordem indicada, acima.

- Proceda à compilação dos ficheiros carregados, pela ordem indicada, acima, de modo a poder utilizar todas as suas funcionalidades.

- Em `jogo.lisp`, na função `escrever-log`, deve alterar o diretório de `log.dat` para o correspondente no seu computador.

## 4. Input/Output

### 4.1 Input

- Jogadas.

### 4.2 Output

- Menus de interação (em consola).
- Estado do tabuleiro (em consola).
- Ficheiro de log.dat (externo).

## 5. Exemplo de Aplicação

### 5.1 Início

``` lisp
(main-menu)
```

### 5.2 Escolher o Tipo de Jogo

``` lisp
+-------------------------+
|       Dots & Boxes      |
+-------------------------+
| 2 - Jogar Vs CPU        |
| 1 - CPU Vs CPU          |
| 0 - Sair                |
+-------------------------+

> 2
```

### 5.3 Inserir o Tempo de Jogada e o Primeiro a Jogar

#### 5.3.1 Tempo de Jogada

``` lisp
Tempo de jogada (entre 1 e 20) em segundos para si e em ms para o computador: 20
```

#### 5.3.2 Primeiro a Jogar
``` lisp
Escolha se joga primeiro ou segundo (1/2): 1
```

### 5.4 Jogadas

#### 5.4.1 Com erro

``` lisp
+-+-+-+-+ +-+
|X|X|X|X|   |
+-+-+-+-+-+ +
  |X|X|X|X| |
+ +-+-+-+-+ +
| |X| |X|X| |
+ +-+ +-+-+ +
  |X| |   | |
+-+-+ + + + +
  |   |   |  
+ +-+-+-+-+-+

Jogador 1 : 0 - 0 : Jogador 2
Agora é o turno de Jogador 1!
Insira coordenada x: 2
Insira coordenada y: 1
Arco Horizontal ou Vertical? (H/V): v
"Erro de jogada, a posição já se encontra preenchida ou está fora do tabuleiro" ;; As "" são um elemento ilustrartivo.
```

#### 5.4.2 Sem erro

``` lisp
+-+-+-+-+ +-+
|X|X|X|X|   |
+-+-+-+-+-+ +
  |X|X|X|X| |
+ +-+-+-+-+ +
| |X| |X|X| |
+ +-+ +-+-+ +
  |X| |   | |
+-+-+ + + + +
  |   |   |  
+ +-+-+-+-+-+

Insira coordenada x: 1
Insira coordenada y: 2
Arco Horizontal ou Vertical? (H/V): v

+-+-+-+-+ +-+
|X|X|X|X|   |
+-+-+-+-+-+ +
"|" |X|X|X|X| | ;; As "" são um elemento ilustrartivo.
+ +-+-+-+-+ +
| |X| |X|X| |
+ +-+ +-+-+ +
  |X| |   | |
+-+-+ + + + +
  |   |   |  
+ +-+-+-+-+-+

Jogador 1 : 0 - 0 : Jogador 2
Agora é o turno de Jogador 2!
```

### 5.5 Fecho de Caixas

#### 5.5.1 Uma Caixa

``` lisp
Jogador 1 : 0 - 0 : Jogador 2
Agora é o turno de Jogador 1!

Insira coordenada x: 3
Insira coordenada y: 1
Arco Horizontal ou Vertical? (H/V): h

+-+-+-+-+ +-+
|X|X|X|X|   |
+-+-+-+-+-+ +
|"X"|X|X|X|X| | ;; As "" são um elemento ilustrartivo.
+-+-+-+-+-+-+
| |X| |X|X| |
+ +-+ +-+-+ +
  |X| |   | |
+-+-+ + + + +
  |   |   |  
+ +-+-+-+-+-+

Jogador 1 : 1 - 0 : Jogador 2
Agora é o turno de Jogador 1! ;; Pode voltar a jogar.
```
#### 5.5.2 Várias Caixas

``` lisp
+-+-+-+-+ +-+
|X|X|X|X|   |
+-+-+-+-+-+ +
|X|X|X|X|X| |
+-+-+-+-+-+-+
|X|X|X|X|X| |
+-+-+-+-+-+ +
|X|X|X|   | |
+-+-+-+ + + +
  |   |   |  
+ +-+-+-+-+-+

Jogador 1 : 5 - 0 : Jogador 2
Agora é o turno de Jogador 1!

Insira coordenada x: 3
Insira coordenada y: 5
Arco Horizontal ou Vertical? (H/V): v

+-+-+-+-+ +-+
|X|X|X|X|   |
+-+-+-+-+-+ +
|X|X|X|X|X| |
+-+-+-+-+-+-+
|X|X|X|X|X| |
+-+-+-+-+-+ +
|X|X|X|   | |
+-+-+-+ + + +
  |"X"|"X"|   |  ;; As "" são um elemento ilustrartivo.
+ +-+-+-+-+-+

Jogador 1 : 7 - 0 : Jogador 2
Agora é o turno de Jogador 1!
```

### 6. Vitória

``` lisp
+-+-+-+-+-+-+
|X|X|X|X|X|X|
+-+-+-+-+-+-+
|X|X|X|X|X|X|
+-+-+-+-+-+-+
|X|X|X|X|X|X|
+-+-+-+-+-+-+
|X|X|X|X| |X|
+-+-+-+-+ +-+
|X|X|X|X| |X|
+-+-+-+-+-+-+

Jogador 1 : 16 - 0 : Jogador 2
Agora é o turno de Jogador 1!

Insira coordenada x: 5
Insira coordenada y: 5
Arco Horizontal ou Vertical? (H/V): h

+-+-+-+-+-+-+
|X|X|X|X|X|X|
+-+-+-+-+-+-+
|X|X|X|X|X|X|
+-+-+-+-+-+-+
|X|X|X|X|X|X|
+-+-+-+-+-+-+
|X|X|X|X|X|X|
+-+-+-+-+-+-+
|X|X|X|X|X|X|
+-+-+-+-+-+-+

Jogador 1 : 18 - 0 : Jogador 2
Agora é o turno de Jogador 1!
"Fim do jogo! O vencedor é o Jogador 1!"   ;; As "" são um elemento ilustrartivo.
```
