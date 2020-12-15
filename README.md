# Provol-One
Compilador para linguagem Provol-One criado para a matéria INF1022 na PUC-Rio.

## Dependencias

* make
* gcc
* bison
* flex
* bash
* python3
	* para rodar testes

## Compilação

Basta entrar na raíz do repositório e rodar *make*.

## Utilização

```shell
./provol-one <arquivo de entrada>
```

Esse comando gerará arquivos .c e .h com o mesmo nome do arquivo de entrada.
Basta compilar um programa em **C** chamando a função *provol-func* gerada.
