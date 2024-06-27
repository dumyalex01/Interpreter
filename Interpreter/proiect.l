%option noyywrap
%{
	#include "proiect.tab.h"
	int lineNo=1;
	int colNo=1;

%}

%%
"[a-zA-Z0-9]*\.txt" { 
                        yylval.sir = strdup(yytext);
                        return TOKEN_SCRIPT;}
"run" { return TOKEN_RUN; }
"," {colNo++; return TOKEN_VIRGULA;}
"//".*    {colNo+=strlen(yytext);return TOKEN_COMMENT;}
"/*"	{colNo+=strlen(yytext);return BEGIN_COMMENT;}
"*/" {colNo+=strlen(yytext);return END_COMMENT;}
"<" {colNo+=strlen(yytext); return TOKEN_MAIMIC;}
">" {colNo+=strlen(yytext); return TOKEN_MAIMARE;}
">=" {colNo+=2; return TOKEN_MAIMAREEGAL;}
"<=" {colNo+=2; return TOKEN_MAIMICEGAL;}
"==" {colNo+=2; return TOKEN_DUBLUEGAL;}
"+"		{colNo++; return TOKEN_PLUS;}
"-"		{colNo++; return TOKEN_MINUS;}
"/"		{colNo++; return TOKEN_IMPARTIRE;}
"*"		{colNo++; return TOKEN_INMULTIRE;}
"("		{colNo++; return TOKEN_STANGA;}
")"		{colNo++; return TOKEN_DREAPTA;}
";"		{colNo++; return TOKEN_PUNCTSIVIRGULA;}
"="		{colNo++; return TOKEN_EGAL;}
"{"		{colNo++;
		yylloc.first_line=lineNo; 
		 return TOKEN_ACOLADA1;}
"}"		{colNo++;
		yylloc.first_line=lineNo;
		 return TOKEN_ACOLADA2;}
return {colNo+=6; return TOKEN_RETURN;}
int 	{colNo+=3; return TOKEN_INT;}
float	{colNo+=5; return TOKEN_FLOAT;}
double	{colNo+=6; return TOKEN_DOUBLE;}
if	{colNo+=2; return TOKEN_IF;}
while {colNo+=5; return TOKEN_WHILE;}
else {colNo+=4; return TOKEN_ELSE;}
0|[1-9][0-9]*	{   yylloc.first_line = lineNo; 
					yylloc.first_column = colNo; 
					colNo+=strlen(yytext); 
					yylval.val_int = atoi(yytext); 
					return TOKEN_NUMAR_INT;}

[0-9]*["."]?[0-9]+f { yylloc.first_line = lineNo;
                     yylloc.first_column = colNo;
                     char* numericString = strdup(yytext);
                     numericString[strlen(yytext) - 1] = '\0';
                     colNo += strlen(yytext);
                     yylval.val_float = atof(numericString);
                     free(numericString);
                     return TOKEN_NUMAR_FLOAT; }
[0-9]+("."[0-9]*)?(([eE][-+]?[0-9]+)?)	{   yylloc.first_line=lineNo;
					yylloc.first_column=colNo;
					colNo+=strlen(yytext);
					yylval.val_double=atof(yytext);
					return TOKEN_NUMAR_DOUBLE;}
print {colNo+=5; return TOKEN_PRINT;}
read {colNo+=4; return TOKEN_READ;}
[a-zA-Z][a-zA-Z0-9]* {yylloc.first_line = lineNo; 
					  yylloc.first_column = colNo; 
					  colNo+=strlen(yytext); 
					  yylval.sir = new char[strlen(yytext)+1]; 
					  strcpy(yylval.sir,yytext); 
					  return TOKEN_ID;}
\"[^\"]*\" {
    colNo += strlen(yytext);
    yylval.sir = new char[strlen(yytext) - 1]; 
    strncpy(yylval.sir, yytext + 1, strlen(yytext) - 2);
    yylval.sir[strlen(yytext) - 2] = '\0';  
    return TOKEN_MESAJ;
}
[ ] { colNo++; } 
\r\n { lineNo++; colNo=1; } 
\n { lineNo++; colNo=1; } 
. { colNo++; return TOKEN_ERROR; }


%%