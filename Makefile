all: parser parser-push

scanner.cpp: scanner.l
	flex -o scanner.cpp scanner.l

parser.cpp parser.hpp: parser.y
	bison -d -o parser.cpp parser.y

parser: parser.cpp scanner.cpp
	g++ parser.cpp scanner.cpp -o parser

scanner-push.cpp: scanner-push.l
	flex -o scanner-push.cpp scanner-push.l

parser-push.cpp parser-push.hpp: parser-push.y
	bison -d -o parser-push.cpp parser-push.y

parser-push: parser-push.cpp scanner-push.cpp
	g++ parser-push.cpp scanner-push.cpp -o parser-push

clean:
	rm -f parser scanner.cpp parser.hpp parser.cpp
	rm -f parser-push scanner-push.cpp parser-push.hpp parser-push.cpp
