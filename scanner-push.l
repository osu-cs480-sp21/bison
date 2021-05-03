%{
#include <iostream>
#include <vector>
#include <set>
#include <cstdlib>

#include "parser.hpp"

YYSTYPE yylval;

yypstate* pstate = yypstate_new();

struct word {
  std::string lexeme;
  std::string category;
};

std::vector<struct word> words;
std::set<std::string> ids;
bool have_error = false;

void save_word(const std::string& lexeme, const std::string& category) {
  struct word word = { .lexeme = lexeme, .category = category };
  words.push_back(word);
}

%}

%option noyywrap
%option yylineno

%%

%{
  /* No code to put at the top of yylex(). */
%}

[ \t\n]*      /* Ignore whitespace. */

[a-z][0-9]? {
  /* save_word(yytext, "IDENTIFIER");
  ids.insert(yytext); */
  yylval.str = new std::string(yytext, yyleng);
  /* return IDENTIFIER; */
  int s = yypush_parse(pstate, IDENTIFIER, &yylval);
  if (s != YYPUSH_MORE) {
    yypstate_delete(pstate);
    return s;
  }
}

[0-9]+("."[0-9]+)? {
  /* save_word(yytext, "NUMBER"); */
  yylval.num = atof(yytext);
  return NUMBER;
}

"=" {
  yylval.category = EQUALS;
  return yylval.category;
}

"+" {
  yylval.category = PLUS;
  return yylval.category;
}

"-" {
  yylval.category = MINUS;
  return yylval.category;
}

"*" {
  yylval.category = TIMES;
  return yylval.category;
}

"/" {
  yylval.category = DIVIDEDBY;
  return yylval.category;
}

";" {
  yylval.category = SEMICOLON;
  return yylval.category;
}

"(" {
  yylval.category = LPAREN;
  return yylval.category;
}

")" {
  yylval.category = RPAREN;
  return yylval.category;
}

. {
  std::cerr << "Invalid symbol on line " << yylineno
    << ": " << yytext << std::endl;
  have_error = true;
  yylval.category = yytext[0];
  return yytext[0];
}

<<EOF>> {
  if (have_error) {
    return 1;
  }
  return 0;
}


%%

/* int main() {
  if (!yylex()) {
    std::vector<struct word>::iterator wit;
    for (wit = words.begin(); wit != words.end(); ++wit) {
      std::cout << wit->lexeme << "\t\t" << wit->category << std::endl;
    }

    std::cout << std::endl << "Identifiers:" << std::endl;
    std::set<std::string>::iterator iit;
    for (iit = ids.begin(); iit != ids.end(); ++iit) {
      std::cout << *iit << std::endl;
    }
  }
} */
