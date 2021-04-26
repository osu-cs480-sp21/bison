%{
#include <iostream>
#include <map>

std::map<std::string, float> symbols;

void yyerror(const char* err);
extern int yylex();
%}

%define api.value.type { std::string* }

%token IDENTIFIER
%token NUMBER
%token EQUALS PLUS MINUS TIMES DIVIDEDBY
%token SEMICOLON LPAREN RPAREN

%type expression
%type statement
%type program

%left PLUS MINUS
%left TIMES DIVIDEDBY
/* %left
%right
%nonassoc PLUSPLUS */

%start program

%%

program
  : program statement
  | statement
  ;

statement
  : IDENTIFIER EQUALS expression SEMICOLON
  ;

expression
  : LPAREN expression RPAREN
  | expression PLUS expression
  | expression MINUS expression
  | expression TIMES expression
  | expression DIVIDEDBY expression
  | NUMBER
  | IDENTIFIER
  ;

%%
