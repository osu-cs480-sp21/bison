%{
#include <iostream>
#include <vector>
#include <set>
#include <cstdlib>

#include "parser-push.hpp"

YYSTYPE yylval;

yypstate* pstate = yypstate_new();

/* struct word {
  std::string lexeme;
  std::string category;
}; */

/* std::vector<struct word> words;
std::set<std::string> ids; */
bool have_error = false;

/* void save_word(const std::string& lexeme, const std::string& category) {
  struct word word = { .lexeme = lexeme, .category = category };
  words.push_back(word);
} */

#define PUSH_TOKEN(category) do {                     \
  int s = yypush_parse(pstate, category, &yylval);  \
  if (s != YYPUSH_MORE) {                             \
    yypstate_delete(pstate);                          \
    return s;                                         \
  }                                                   \
} while (0)

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
  PUSH_TOKEN(IDENTIFIER);
}

[0-9]+("."[0-9]+)? {
  /* save_word(yytext, "NUMBER"); */
  yylval.num = atof(yytext);
  PUSH_TOKEN(NUMBER);
}

"=" {
  yylval.category = EQUALS;
  PUSH_TOKEN(yylval.category);
}

"+" {
  yylval.category = PLUS;
  PUSH_TOKEN(yylval.category);
}

"-" {
  yylval.category = MINUS;
  PUSH_TOKEN(yylval.category);
}

"*" {
  yylval.category = TIMES;
  PUSH_TOKEN(yylval.category);
}

"/" {
  yylval.category = DIVIDEDBY;
  PUSH_TOKEN(yylval.category);
}

";" {
  yylval.category = SEMICOLON;
  PUSH_TOKEN(yylval.category);
}

"(" {
  yylval.category = LPAREN;
  PUSH_TOKEN(yylval.category);
}

")" {
  yylval.category = RPAREN;
  PUSH_TOKEN(yylval.category);
}

. {
  std::cerr << "Invalid symbol on line " << yylineno
    << ": " << yytext << std::endl;
  have_error = true;
  yylval.category = yytext[0];
  PUSH_TOKEN(yytext[0]);
}

<<EOF>> {
  /* if (have_error) {
    return 1;
  }
  return 0; */
  int s = yypush_parse(pstate, 0, NULL);
  yypstate_delete(pstate);
  return s;
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
