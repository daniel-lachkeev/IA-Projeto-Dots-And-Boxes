# Dots & Boxes - Manual Técnico

## Projeto 1 - IA 2022/2023 (Época Normal)

## Docente

Joaquim Filipe

## Alunos

202001310, Leandro Francisco

201801899, Daniel Lachkeev

## Estrutura de ficheiros

- `problemas.dat` - ficheiro que contém os vários problemas de jogo.
- `procura.lisp` - ficheiro que contém a implementação dos algoritmos utilizados pelo programa.
- `projeto.lisp` - ficheiro que contém os menus de interação com o utilizador.
- `puzzle.lisp` - ficheiro que contém as funcionalidades do programa.

## Conteúdo dos ficheiros

### problemas.dat

- `6 problemas` - configurações diferentes de tabuleiros de jogo iniciais.

### procura.lisp

- `novo-sucessor` - função de procura de um novo sucessor de um nó de teste.
- `sucessores` - função de procura dos sucessores de um nó, segundo um algoritmo e um valor de profundidade (opcional) fornecidos.
- `nivel-no` - função que determina o nível de um nó fornecido.
- `abertos-bfs` - função que determina a lista de nós abertos, segundo o algoritmo BFS.
- `abertos-dfs` - função que determina a lista de nós abertos, segundo o algoritmo DFS.
- `no-existep` - função que verifica a existência de um determinado nó.
- `bfs` - função que implementa o algoritmo BFS.
- `dfs` - função que implementa o algoritmo DFS.
- `a-star` - função que implementa o algoritmo A*

### projeto.lisp

- `main-menu` - função responsável por gerar o menu inicial da aplicação.
- `problems-menu` - função responsável por gerar o menu para escolha do problema.
- `algorithms-menu` - função responsável por gerar o menu para escolha do algoritmo.

### puzzle.lisp
- `tabuleiro-teste` - função que retorna um tabuleiro de teste.
- `tabuleiro-teste2` - função que retorna um tabuleiro de teste.
- `tabuleiro-teste3` - função que retorna um tabuleiro de teste.
- `get-arcos-horizontais` - função que retorna os arcos horizontais de um tabuleiro.
- `get-arcos-verticais` - função que retorna os arcos verticais de um tabuleiro.
- `get-arco-na-posicao` - função que retorna um arco numa determinada posicao.
- `substituir` - função que substitui um arco, de forma recursiva.
- `arco-na-posicao` - função para inserção de um arco, numa determinada posição.
- `arco-horizontal` - função para inserção de um arco horizontal.
- `arco-vertical` - função para inserção de um arco vertical.
- `caixa-fechada` - função que determina se uma caixa está fechada, segundo uma determinada posição.
- `caixas-fechadas` - função que determina as caixas fechadas de um tabuleiro, começando numa determinada posição.
- `n-caixas-fechadas` - função que determina o número de caixas fechadas de um tabuleiro.
- `solucaop` - verifica se o tabuleiro corresponde a uma solução
- `n-linhas` - conta nº de linhas de um tabuleiro
- `base-heuristic` - heurística do enunciado
- `my-heuristic` - heurística nossa implementada
- `operadores` - lista de operadores ao estado
- `cria-no` - cria uma estrutura de dados adequado ao problema
- `calcular-heuristica` - Calcula heurística de uma função de heurística arbitrária
- `gerar-jogadas-horizontais` - Calcula as posições de jogadas possíveis horizontais
- `gerar-jogadas-verticais` - Calcula as posições de jogadas possíveis verticais

#### Seletores:
- `no-teste`
- `no-teste2`
- `no-estado`
- `no-objetivo`
- `no-profundidade`
- `no-pai`
- `no-heuristica`
- `no-custo`

## Limitações
- Gerar sucessores de um nó
- Correr algoritmos de pesquisa apesar de estarem implementados
- A* não está totalmente implementado