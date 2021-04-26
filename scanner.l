%{
#include <iostream>
#include <vector>
#include <set>

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
  save_word(yytext, "IDENTIFIER");
  ids.insert(yytext);
}

[0-9]+("."[0-9]+)? {
  save_word(yytext, "NUMBER");
}

"=" {
  save_word(yytext, "EQUALS");
}

"+" {
  save_word(yytext, "PLUS");
}

"-" {
  save_word(yytext, "MINUS");
}

"*" {
  save_word(yytext, "TIMES");
}

"/" {
  save_word(yytext, "DIVIDEDBY");
}

";" {
  save_word(yytext, "SEMICOLON");
}

"(" {
  save_word(yytext, "LPAREN");
}

")" {
  save_word(yytext, "RPAREN");
}

. {
  std::cerr << "Invalid symbol on line " << yylineno
    << ": " << yytext << std::endl;
  have_error = true;
}

<<EOF>> {
  if (have_error) {
    return 1;
  }
  return 0;
}


%%

int main() {
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
}
