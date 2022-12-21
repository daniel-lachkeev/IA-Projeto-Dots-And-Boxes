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
