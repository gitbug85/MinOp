nim c ./src/minop.nim
rustc --crate-type=staticlib ./src/runtime/math.rs -o ./src/runtime/math.a
rustc --crate-type=staticlib ./src/runtime/cli.rs -o ./src/runtime/cli.a
rustc --crate-type=staticlib ./src/runtime/string.rs -o ./src/runtime/string.a
gcc -c -O2 -fPIC ./src/runtime/io.c -o ./src/runtime/io.o
ar rcs ./src/runtime/io.a ./src/runtime/io.o