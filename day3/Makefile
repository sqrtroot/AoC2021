.PHONY: run assembly

a.out: main.cpp
	g++ main.cpp -std=c++20 -Wall -Wpedantic -lfmt -ggdb
run: a.out
	./a.out
assembly: main.cpp
	g++ -S main.cpp -lfmt -std=c++20 -Os -o - -fverbose-asm -masm=intel | bat --language=asm


