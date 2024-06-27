%{
	#include <iostream>
	#include <string>
	#include <vector>
	#include <cstdlib>
	#include <string.h>
	using namespace std;
	#define INT_TYPE 1
	#define FLOAT_TYPE 2
	#define DOUBLE_TYPE 3
	int yylex(); 
	int yyerror(const char *msg); 
	int EsteCorecta = 1;
	char msg[500];
	extern FILE* yyin;

	class Atom
	{
	string name;
    int tipVariabila;
    int val_int;
    float val_float;
    double val_double;
	int linieDecl;
	int scopeIndex;
	public:
		Atom(string name,int tipVariabila,int val_int,float val_float,double val_double)
		{
			this->name=name;
			this->tipVariabila=tipVariabila;
			this->val_int=val_int;
			this->val_float=val_float;
			this->val_double=val_double;
			scopeIndex=-1;


		}
		void set_linie(int linie)
		{
			this->linieDecl=linie;
		}
		int get_linie()
		{
			return this->linieDecl;
		}
		int get_ScopeIndex()
		{
			return this->scopeIndex;
		}
		void set_ScopeIndex(int pos)
		{
			this->scopeIndex=pos;
		}
		int get_Tip()
		{
			return this->tipVariabila;
		}
		string get_name()
		{
			return this->name;
		}
		void set_floatValue(float value)
		{
			this->val_float=value;
		}
		float get_floatValue()
		{	
			return this->val_float;
		}
		void set_intValue(int value)
		{
			this->val_int=value;
		}
		int get_intValue()
		{
			return this->val_int;
		}
		void set_doubleValue(double value)
		{
			this->val_double=value;
		}
		double get_doubleValue()
		{   //cout<<this->val_double<<endl;
			return this->val_double;
		}
		
	};
	class function
	{	
		char funcName[50];
		char args[50][50];
		char returnValue[30];
		int numarArgumente;
		int type;
		public:
		function()
		{
			this->numarArgumente=0;
		}
		void setName(char* name)
		{
			strcpy(this->funcName,name);
			
		}
		char* getName()
		{
			return this->funcName;
		}
		void setType(int type)
		{
			this->type=type;
		}
		void add_arg(char* arg)
		{
			strcpy(this->args[numarArgumente++],arg);
		}
		void setReturnValue(char* retValue)
		{	
			strcpy(returnValue,retValue+1);

		}
		int getPozByName(char* a)
		{
			for(int i=0;i<numarArgumente;i++)
				if(strcmp(a,this->args[i])==0)
					return i;
			return -1;
		}

		void executeFunction(int& rez,int values[])
		{
			char operator1[50];
			char operator2[50];
			char copieExpresie[100];
			strcpy(copieExpresie,this->returnValue);
			char*p=strtok(copieExpresie,"+/-*");
			strcpy(operator1,p);
			p=strtok(NULL,"+/-*");
			strcpy(operator2,p);
			int poz1=getPozByName(operator1);
			int poz2=getPozByName(operator2);
			if(strchr(this->returnValue,'+'))
				rez=values[poz1]+values[poz2];
			if(strchr(this->returnValue,'-'))
				rez=values[poz1]-values[poz2];
			if(strchr(this->returnValue,'*'))
				rez=values[poz1]*values[poz2];
			if(strchr(this->returnValue,'/'))
				rez=values[poz1]*values[poz2];
			
			
	
		}

	};
	class Interpreter
	{
		vector<Atom*> vectorAtomi;
		vector<function*> FunctiiDeclarate;
		public:
		void addElement(Atom *A)
		{
			vectorAtomi.push_back(A);
		}
		void addFunction(function*A)
		{
			FunctiiDeclarate.push_back(A);
		}
		Atom* findByValue(const char* a)
		{
			for(int i=0;i<vectorAtomi.size();i++)
				if(vectorAtomi[i]->get_name()==a)
					return vectorAtomi[i];
			return NULL;

		}
		function* findByName(char*a)
		{
			for(int i=0;i<FunctiiDeclarate.size();i++)
				if(strcmp(FunctiiDeclarate[i]->getName(),a)==0)
					return FunctiiDeclarate[i];
			return NULL;
		}
		
	};

	int vectorParametrii[3];
	int counterVectorParametrii=0;
	char parametrii[50][50];
	int numarParametrii=0;
	int rezultat;
	Interpreter interp;
	int flagValue=0;
	int numarOperatori=0;
	int intreAcolade=0;
	int acolada1[100];
	int acolada2[100];
	int counterAcolada=0;
	int seExecuta=1;
	int comentariu=0;
	int findIndex(Atom*A)
	{	
		for(int i=counterAcolada;i>=0;i--)
			if(acolada1[i]<=A->get_linie())
				return i;
		return -1;
	}
	bool verifyInScope(Atom*A,int linie)
	{	if(A->get_ScopeIndex()==-1)
			return true;
		if(acolada2[A->get_ScopeIndex()]==0)
			return true;
		else
		{
			if(linie>acolada1[A->get_ScopeIndex()] && linie< acolada2[A->get_ScopeIndex()])
				return true;
			else return false;
		}
	}
%}





%union {char* sir; int val_int; float val_float; double val_double;}

%token TOKEN_PLUS TOKEN_MINUS TOKEN_IMPARTIRE TOKEN_INMULTIRE TOKEN_STANGA TOKEN_DREAPTA TOKEN_DUBLUEGAL TOKEN_SCRIPT TOKEN_RUN
%token TOKEN_MAIMIC TOKEN_MAIMARE TOKEN_MAIMAREEGAL TOKEN_MAIMICEGAL EGAL TOKEN_ACOLADA1 TOKEN_ACOLADA2 TOKEN_INT TOKEN_FLOAT TOKEN_DOUBLE
%token TOKEN_IF TOKEN_WHILE TOKEN_ELSE TOKEN_PRINT TOKEN_READ TOKEN_ERROR TOKEN_VIRGULA
%token TOKEN_PUNCTSIVIRGULA TOKEN_EGAL TOKEN_COMMENT BEGIN_COMMENT END_COMMENT
%token TOKEN_RETURN
%nonassoc TOKEN_ID
%token <val_int> TOKEN_NUMAR_INT
%token <sir> TOKEN_ID
%token <val_float> TOKEN_NUMAR_FLOAT
%token <val_double> TOKEN_NUMAR_DOUBLE
%token <sir> TOKEN_MESAJ

%type <sir> Expresie_Functie
%type <val_double> Expresie
%type <val_int> E 
%type <val_float> F 
%type <val_double> D

%start S 

%left TOKEN_PLUS TOKEN_MINUS 
%left TOKEN_INMULTIRE TOKEN_IMPARTIRE

%%
	S : | I S 
		| TOKEN_ERROR { EsteCorecta = 0; } ;
	I : TOKEN_INT TOKEN_ID TOKEN_EGAL E TOKEN_PUNCTSIVIRGULA
	{	
		if(comentariu==0 && seExecuta==1)
	{	
		float value_float;
		int value_int;
		double value_double;
		int tip;
		Atom*A=interp.findByValue($2);
		if(A!=NULL)
		{
			sprintf(msg,"%d:%d Eroare semantica: Variabila %s exista deja!",@1.first_line,@1.first_column,$2);
			yyerror(msg);
			YYERROR;
		}
		else
		{	
			A=new Atom($2,INT_TYPE,$4,0,0);
			A->set_linie(@1.first_line);
			if(intreAcolade==1)
				A->set_ScopeIndex(findIndex(A));
			interp.addElement(A);		
		}
	}
	}
		| TOKEN_DOUBLE TOKEN_ID TOKEN_EGAL D TOKEN_PUNCTSIVIRGULA
	{	if(comentariu==0 && seExecuta==1)
	{
		float value_float;
		int value_int;
		double value_double;
		int tip;
		Atom*A=interp.findByValue($2);
		if(A!=NULL)
		{
			sprintf(msg,"%d:%d Eroare semantica: Variabila %s exista deja!",@1.first_line,@1.first_column,$2);
			yyerror(msg);
			YYERROR;
		}
		else
		{	
			A=new Atom($2,DOUBLE_TYPE,0,0,$4);
			A->set_linie(@1.first_line);
			if(intreAcolade==1)
				A->set_ScopeIndex(findIndex(A));
			interp.addElement(A);
			
		}
	}

	}	|TOKEN_FLOAT TOKEN_ID TOKEN_EGAL F TOKEN_PUNCTSIVIRGULA
	{	if(comentariu==0 && seExecuta==1)
	{	
		float value_float;
		int value_int;
		double value_double;
		int tip;
		Atom*A=interp.findByValue($2);
		if(A!=NULL)
		{
			sprintf(msg,"%d:%d Eroare semantica: Variabila %s exista deja!",@1.first_line,@1.first_column,$2);
			yyerror(msg);
			YYERROR;
		}
		else
		{	
			A=new Atom($2,FLOAT_TYPE,0,$4,0);
			A->set_linie(@1.first_line);
			interp.addElement(A);
			
		}
	}

	}
		| TOKEN_ID TOKEN_EGAL Expresie TOKEN_PUNCTSIVIRGULA
		{	
			if(comentariu==0 && seExecuta==1)
		{	
			Atom*A=interp.findByValue($1);
			if(A==NULL)
			{
				sprintf(msg,"%d:%d Eroare semantca: Variabila %s nu exista!",@1.first_line,@1.first_column,$1);
				yyerror(msg);
				YYERROR;
			}
			else
			{	
				if(verifyInScope(A,@1.first_line))
			{
				if(A->get_Tip()==INT_TYPE)
				{
					if(flagValue!=numarOperatori)
					{	
						flagValue=0;
						numarOperatori=0;
						sprintf(msg,"%d:%d Eroare semantica: Variabilele insumate nu sunt de tip int!",@1.first_line,@1.first_column);
						yyerror(msg);
						YYERROR;
					}
					else
					{
						A->set_intValue($3);
						flagValue=0;
						numarOperatori=0;

					}
				}
				if(A->get_Tip()==FLOAT_TYPE)
				{
					numarOperatori=0;
					flagValue=0;
					A->set_floatValue($3);
				}
				if(A->get_Tip()==DOUBLE_TYPE)
				{
					numarOperatori=0;
					flagValue=0;
					A->set_doubleValue($3);
				}
			}
			else
			{
				sprintf(msg,"%d:%d Eroare de semantica. Variabila %s nu este in scope-ul ei!",@1.first_line,@1.first_column,$1);
				yyerror(msg);
				YYERROR;
			}
			}
		}
		}
		|TOKEN_ID TOKEN_EGAL TOKEN_STANGA TOKEN_INT TOKEN_DREAPTA TOKEN_ID TOKEN_PUNCTSIVIRGULA
		{	if(comentariu==0 && seExecuta)
		{
			Atom*A=interp.findByValue($1);
			Atom*B=interp.findByValue($6);
			if(A==NULL)
			{
				sprintf(msg,"%d:%d Eroare semantica : Variabila %s nu exista",@1.first_line,@1.first_column,$1);
				yyerror(msg);
				YYERROR;
			}
			else
			{	if(verifyInScope(A,@1.first_line))
			{
				if(A->get_Tip()==INT_TYPE)
				{
					if(B==NULL)
					{
						sprintf(msg,"%d:%d Eroare semantica : Variabila %s nu exista",@1.first_line,@1.first_column,$6);
						yyerror(msg);
						YYERROR;
					}
					else
					{	if(verifyInScope(B,@1.first_line))
					{
						if(B->get_Tip()==INT_TYPE)
							A->set_intValue((int)B->get_intValue());
						if(B->get_Tip()==FLOAT_TYPE)
							A->set_intValue((int)B->get_floatValue());
						if(B->get_Tip()==DOUBLE_TYPE)
							A->set_intValue((int)B->get_doubleValue());
					}
					else
					{
						sprintf(msg,"%d:%d Eroare semantica : Variabila %s nu se afla in scope!",@1.first_line,@1.first_column,$6);
						yyerror(msg);
						YYERROR;
					}
					}
				}
				else
				{
					sprintf(msg,"%d:%d Eroare semantica : Variabila %s nu este de tip int",@1.first_line,@1.first_column,$1);
					yyerror(msg);
					YYERROR;
				}
			}
			else
			{
					sprintf(msg,"%d:%d Eroare semantica : Variabila %s nu este de in scope!",@1.first_line,@1.first_column,$1);
					yyerror(msg);
					YYERROR;
			}

			}
		}
		}
		|TOKEN_ID TOKEN_EGAL TOKEN_STANGA TOKEN_FLOAT TOKEN_DREAPTA TOKEN_ID TOKEN_PUNCTSIVIRGULA
		{	if(comentariu==0 && seExecuta)
		{
			Atom*A=interp.findByValue($1);
			Atom*B=interp.findByValue($6);
			if(A==NULL)
			{
				sprintf(msg,"%d:%d Eroare semantica : Variabila %s nu exista",@1.first_line,@1.first_column,$1);
				yyerror(msg);
				YYERROR;
			}
			else
			{	if(verifyInScope(A,@1.first_line))
			{
				if(A->get_Tip()==FLOAT_TYPE)
				{
					if(B==NULL)
					{
						sprintf(msg,"%d:%d Eroare semantica : Variabila %s nu exista",@1.first_line,@1.first_column,$6);
						yyerror(msg);
						YYERROR;
					}
					else
					{	if(verifyInScope(B,@1.first_line))
					{
						if(B->get_Tip()==INT_TYPE)
							A->set_intValue((float)B->get_intValue());
						if(B->get_Tip()==FLOAT_TYPE)
							A->set_intValue((float)B->get_floatValue());
						if(B->get_Tip()==DOUBLE_TYPE)
							A->set_intValue((float)B->get_doubleValue());
					}
					else
					{
						sprintf(msg,"%d:%d Eroare semantica : Variabila %s nu se afla in scope!",@1.first_line,@1.first_column,$6);
						yyerror(msg);
						YYERROR;
					}
					}
				}
				else
				{
					sprintf(msg,"%d:%d Eroare semantica : Variabila %s nu este de tip float",@1.first_line,@1.first_column,$1);
					yyerror(msg);
					YYERROR;
				}
			}
			else
			{
					sprintf(msg,"%d:%d Eroare semantica : Variabila %s nu este de in scope!",@1.first_line,@1.first_column,$1);
					yyerror(msg);
					YYERROR;
			}

			}
		}
		}
		|TOKEN_ID TOKEN_EGAL TOKEN_STANGA TOKEN_DOUBLE TOKEN_DREAPTA TOKEN_ID TOKEN_PUNCTSIVIRGULA
		{	if(comentariu==0 && seExecuta)
		{
			Atom*A=interp.findByValue($1);
			Atom*B=interp.findByValue($6);
			if(A==NULL)
			{
				sprintf(msg,"%d:%d Eroare semantica : Variabila %s nu exista",@1.first_line,@1.first_column,$1);
				yyerror(msg);
				YYERROR;
			}
			else
			{	if(verifyInScope(A,@1.first_line))
			{
				if(A->get_Tip()==DOUBLE_TYPE)
				{
					if(B==NULL)
					{
						sprintf(msg,"%d:%d Eroare semantica : Variabila %s nu exista",@1.first_line,@1.first_column,$6);
						yyerror(msg);
						YYERROR;
					}
					else
					{	if(verifyInScope(B,@1.first_line))
					{
						if(B->get_Tip()==INT_TYPE)
							A->set_intValue((double)B->get_intValue());
						if(B->get_Tip()==FLOAT_TYPE)
							A->set_intValue((double)B->get_floatValue());
						if(B->get_Tip()==DOUBLE_TYPE)
							A->set_intValue((double)B->get_doubleValue());
					}
					else
					{
						sprintf(msg,"%d:%d Eroare semantica : Variabila %s nu se afla in scope!",@1.first_line,@1.first_column,$6);
						yyerror(msg);
						YYERROR;
					}
					}
				}
				else
				{
					sprintf(msg,"%d:%d Eroare semantica : Variabila %s nu este de tip double",@1.first_line,@1.first_column,$1);
					yyerror(msg);
					YYERROR;
				}
			}
			else
			{
					sprintf(msg,"%d:%d Eroare semantica : Variabila %s nu este de in scope!",@1.first_line,@1.first_column,$1);
					yyerror(msg);
					YYERROR;
			}

			}
		}
		}
		| TOKEN_PRINT TOKEN_STANGA TOKEN_ID TOKEN_DREAPTA TOKEN_PUNCTSIVIRGULA
		{		
			if(comentariu==0 && seExecuta==1)
		{
			Atom* A=interp.findByValue($3);
			if(A==NULL)
			{
				sprintf(msg,"%d:%d Eroare semantca: Variabila %s nu exista!",@1.first_line,@1.first_column,$3);
				yyerror(msg);
				YYERROR;
			}
			else
			{	
				if(verifyInScope(A,@1.first_line))
			{
				if(A->get_Tip()==INT_TYPE)
					printf("%d\n",A->get_intValue());
				if(A->get_Tip()==FLOAT_TYPE)
					printf("%.2ff\n",A->get_floatValue());
				if(A->get_Tip()==DOUBLE_TYPE)
					printf("%.2f\n",A->get_doubleValue());
			}
			else
			{
				sprintf(msg,"%d:%d Eroare semantica: Variabila %s nu se afla in scope-ul ei!",@1.first_line,@1.first_column,$3);
				yyerror(msg);
				YYERROR;
			}
			}
		}

		}
		| TOKEN_PRINT TOKEN_STANGA TOKEN_MESAJ TOKEN_DREAPTA TOKEN_PUNCTSIVIRGULA
		{	if(comentariu==0 && seExecuta==1)
				cout<<$3;
		}
		| TOKEN_READ TOKEN_STANGA TOKEN_ID TOKEN_DREAPTA TOKEN_PUNCTSIVIRGULA
{	if(comentariu==0 && seExecuta==1)
{

    Atom* A = interp.findByValue($3);
    if (A == NULL)
    {
        sprintf(msg, "%d:%d Eroare semantca: Variabila %s nu exista!", @1.first_line, @1.first_column, $3);
        yyerror(msg);
        YYERROR;
    }
    else
    {	if(verifyInScope(A,@1.first_line))
		{
       if(A->get_Tip()==FLOAT_TYPE)
       {
        float a;
		cin>>a;
        A->set_floatValue(a);
       }
       if(A->get_Tip()==INT_TYPE)
       {
        int a;
        cin>>a;
        A->set_intValue(a);
       }
       if(A->get_Tip()==DOUBLE_TYPE)
       {
        double a;
        cin>>a;
        A->set_doubleValue(a);
       }
		}
		else
		{
			sprintf(msg,"%d:%d Eroare semantica: Variabila %s nu se afla in scope-ul ei!",@1.first_line,@1.first_column,$3);
			yyerror(msg);
			YYERROR;
		}
    }
}
}	| TOKEN_IF TOKEN_STANGA Conditie TOKEN_DREAPTA TOKEN_A1 S TOKEN_A2
	{
		intreAcolade=0;
	}
| TOKEN_ELSE1 TOKEN_A1 S TOKEN_A2
{
	seExecuta=1;
	intreAcolade=0;
}
|TOKEN_COMMENT {}
|TOK_COMM TOK_MESAJE TOK_END
{}
| TOKEN_WHILE TOKEN_STANGA Conditie TOKEN_DREAPTA TOKEN_A1 S TOKEN_A2
{
	
}
| TOKEN_INT TOKEN_ID PARAMETRII TOKEN_A1 TOKEN_RETURN Expresie_Functie TOKEN_PUNCTSIVIRGULA TOKEN_A2
{
	//am parametrii
	function* a=new function();
	a->setName($2);
	for(int i=0;i<numarParametrii;i++)
		a->add_arg(parametrii[i]);
	a->setReturnValue($6);
	interp.addFunction(a);
	
}
| TOKEN_DOUBLE TOKEN_ID PARAMETRII TOKEN_A1 TOKEN_RETURN Expresie_Functie TOKEN_PUNCTSIVIRGULA TOKEN_A2
{
	function*a=new function();
	a->setName($2);
	for(int i=0;i<numarParametrii;i++)
		a->add_arg(parametrii[i]);
	a->setReturnValue($6);
	interp.addFunction(a);
}
| TOKEN_FLOAT TOKEN_ID PARAMETRII TOKEN_A1 TOKEN_RETURN Expresie_Functie TOKEN_PUNCTSIVIRGULA TOKEN_A2
{
	function*a=new function();
	a->setName($2);
	for(int i=0;i<numarParametrii;i++)
		a->add_arg(parametrii[i]);
	a->setReturnValue($6);
	interp.addFunction(a);
}
| TOKEN_ID TOKEN_EGAL TOKEN_ID TOKEN_PARAMETRII TOKEN_PUNCTSIVIRGULA
{
	int rez;
	function*func=interp.findByName($3);
	if(func==NULL)
	{
		sprintf(msg,"%d:%d Eroare. Functia nu exista!",@1.first_line,@1.first_column);
		yyerror(msg);
		YYERROR;
	}
	else
	{
		func->executeFunction(rez,vectorParametrii);
		Atom*A=interp.findByValue($1);
		if(A==NULL)
		{
		sprintf(msg,"%d:%d Eroare. Variabila nu exista!",@1.first_line,@1.first_column);
		yyerror(msg);
		YYERROR;
		}
		else
		{
			if(A->get_Tip()==INT_TYPE)
				A->set_intValue(rez);
			if(A->get_Tip()==FLOAT_TYPE)
				A->set_floatValue((float)rez);
			if(A->get_Tip()==DOUBLE_TYPE)
				A->set_doubleValue((double)rez);
		}
		
	}
}



       
        






		
		


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//auxiliare
PARAMETRII: TOKEN_STANGA parameters TOKEN_DREAPTA

parameters: parameter TOKEN_VIRGULA parameter | parameter

parameter: TOKEN_INT TOKEN_ID
{
	strcpy(parametrii[numarParametrii++],$2);
}
| TOKEN_FLOAT TOKEN_ID
{
	strcpy(parametrii[numarParametrii++],$2);
}
| TOKEN_DOUBLE TOKEN_ID
{
	strcpy(parametrii[numarParametrii++],$2);
}
TOKEN_PARAMETRII: TOKEN_STANGA parameters_T TOKEN_DREAPTA
parameters_T: parameterr TOKEN_VIRGULA parameterr | parameterr

parameterr: Expresie
{
	vectorParametrii[counterVectorParametrii++]=$1;
}

	TOKEN_ELSE1: TOKEN_ELSE
	{
		if(seExecuta==0)
			seExecuta=1;
		else seExecuta=0;
	}
	TOKEN_A2: TOKEN_ACOLADA2
	{	
		acolada2[counterAcolada]=@1.first_line;
		counterAcolada++;

		
	}
	TOKEN_A1: TOKEN_ACOLADA1
	{	
		intreAcolade=1;
		acolada1[counterAcolada]=@1.first_line;
		intreAcolade=1;
	}
	TOK_COMM: BEGIN_COMMENT
	{
		comentariu=1;
	}
	TOK_END:END_COMMENT
	{
		comentariu=0;
	}
	TOK_MESAJE: S
				| MesajComentariu


	/////////Expresiile
	MesajComentariu: MesajComentariu TOKEN_ID
			| TOKEN_ID
	Conditie : Expresie TOKEN_MAIMIC Expresie
	{
		if(comentariu==0)
	{
			if($1 < $3)
				seExecuta=1;
			else seExecuta=0;
			flagValue=0;
			numarOperatori=0;

		 }
	}
	
	 | Expresie TOKEN_MAIMARE Expresie
	 {
		if(comentariu==0)
	{
		
			if($1 > $3)
				seExecuta=1;
			else seExecuta=0;
			flagValue=0;
			numarOperatori=0;

		 }
	}
	| Expresie TOKEN_MAIMAREEGAL Expresie
	 {
		if(comentariu==0)
	{
		
			if($1 >= $3)
				seExecuta=1;
			else seExecuta=0;
			flagValue=0;
			numarOperatori=0;

		 }
	}
	
	| Expresie TOKEN_MAIMICEGAL Expresie
	 {
		if(comentariu==0)
	{
		
			if($1 <= $3)
				seExecuta=1;
			else seExecuta=0;
			flagValue=0;
			numarOperatori=0;

		 }
	}
	| Expresie TOKEN_DUBLUEGAL Expresie
	 {
		if(comentariu==0)
	{

			if($1 == $3)
				seExecuta=1;
			else seExecuta=0;
			flagValue=0;
			numarOperatori=0;

		 }
	}
	
	E : E TOKEN_PLUS E {$$=$1+$3;}
		| E TOKEN_MINUS E {$$=$1-$3;}
		| E TOKEN_INMULTIRE E {$$=$1*$3;}
		| E TOKEN_IMPARTIRE E 
		{
			if($3==0)
				printf("Eroare la impartire la 0!");
			else $$=$1/$3;
		}
		| TOKEN_ID
		{
			Atom*A=interp.findByValue($1);
			if(A==NULL)
			{
				sprintf(msg,"%d:%d Eroare semantica! Variabila %s nu exista",@1.first_line,@1.first_column,$1);
				yyerror(msg);
				YYERROR;
			}
			else
			{
				if(A->get_Tip()!=INT_TYPE)
				{
					sprintf(msg,"%d:%d Eroare semantica! Variabilele de adunat nu au acelasi tip!",@1.first_line,@1.first_column);
					yyerror(msg);
					YYERROR;
				}
				else $$=A->get_intValue();
			}
		}
		| TOKEN_STANGA E TOKEN_DREAPTA {$$=$2;}
		| TOKEN_NUMAR_INT {$$=$1;}
	F : F TOKEN_PLUS F {$$=$1+$3;}
		| F TOKEN_MINUS F {$$=$1-$3;}
		| F TOKEN_INMULTIRE F {$$=$1*$3;}
		| F TOKEN_IMPARTIRE F 
		{
			if($3==0)
				printf("Eroare impartire la 0!");
			else $$=$1/$3;
		}
		| TOKEN_STANGA F TOKEN_DREAPTA {$$=$2;}
		| TOKEN_NUMAR_FLOAT {$$=$1;}
		| TOKEN_ID
		{
			Atom*A=interp.findByValue($1);
			if(A==NULL)
			{
				sprintf(msg,"%d:%d Eroare semantica! Variabila %s nu exista",@1.first_line,@1.first_column,$1);
				yyerror(msg);
				YYERROR;
			}
			else
			{
				if(A->get_Tip()==INT_TYPE)
					$$=(float)A->get_intValue();
				if(A->get_Tip()==FLOAT_TYPE)
					$$=(float)A->get_floatValue();
				if(A->get_Tip()==DOUBLE_TYPE)
					$$=(float)A->get_doubleValue();
				
			}
		}
	D : D TOKEN_PLUS D {$$=$1+$3;}
		| D TOKEN_MINUS D {$$=$1+$3;}
		| D TOKEN_INMULTIRE D{$$=$1*$3;}
		| D TOKEN_IMPARTIRE D 
		{
			if($3==0)
				printf("Eroare la impartire la 0!");
				else $$=$1/$3;
		}
		
		| TOKEN_STANGA D TOKEN_DREAPTA {$$=$2;}
		| TOKEN_NUMAR_DOUBLE {$$=$1;}
		| TOKEN_ID
		{
			Atom*A=interp.findByValue($1);
			if(A==NULL)
			{
				sprintf(msg,"%d:%d Eroare semantica! Variabila %s nu exista",@1.first_line,@1.first_column,$1);
				yyerror(msg);
				YYERROR;
			}
			else
			{
				if(A->get_Tip()==INT_TYPE)
					$$=(double)A->get_intValue();
				if(A->get_Tip()==FLOAT_TYPE)
					$$=(double)A->get_floatValue();
				if(A->get_Tip()==DOUBLE_TYPE)
					$$=(double)A->get_doubleValue();
				
			}
		}
	Expresie_Functie: Expresie_Functie TOKEN_PLUS Expresie_Functie {strcat($$,$1);strcat($$,"+"),strcat($$,$3);}
					|Expresie_Functie TOKEN_MINUS Expresie_Functie {strcat($$,$1);strcat($$,"-"),strcat($$,$3);}
					|Expresie_Functie TOKEN_INMULTIRE Expresie_Functie {strcat($$,$1);strcat($$,"*"),strcat($$,$3);}
					|Expresie_Functie TOKEN_IMPARTIRE Expresie_Functie {strcat($$,$1);strcat($$,"/"),strcat($$,$3);}
					| TOKEN_ID {strcpy($$,$1);}
	Expresie:Expresie TOKEN_PLUS Expresie	{$$=$1+$3;}
			|Expresie TOKEN_MINUS Expresie	{$$=$1-$3;}
			|Expresie TOKEN_INMULTIRE Expresie	{$$=$1*$3;}
			|Expresie TOKEN_IMPARTIRE Expresie 
			{	$$=$1/$3;
				if($3==0)
				{
					sprintf(msg,"%d:%d Eroare impartire la 0!",@1.first_line,@1.first_column);
					yyerror(msg);
					YYERROR;
				}
			}
			|TOKEN_STANGA Expresie TOKEN_DREAPTA {$$=$2;}
			|TOKEN_NUMAR_DOUBLE 
			{
				$$=$1;
				flagValue+=DOUBLE_TYPE;
				numarOperatori++;
			}
			|TOKEN_NUMAR_INT 
			{
				$$=(double)$1;
				flagValue+=INT_TYPE;
				numarOperatori++;
			}
			|TOKEN_NUMAR_FLOAT 
			{
				$$=(double)$1;
				flagValue+=FLOAT_TYPE;
				numarOperatori++;
			}
			|TOKEN_ID
			{
				Atom*A=interp.findByValue($1);
				if(A==NULL)
				{
					sprintf(msg,"%d:%d Eroare sintactica. Variabila %s nu exista!",@1.first_line,@1.first_column,$1);
					yyerror(msg);
					YYERROR;
				}
				else
				{
					if(A->get_Tip()==INT_TYPE)
					{
						flagValue+=INT_TYPE;
						numarOperatori++;
						$$=(double)A->get_intValue();
					}
					if(A->get_Tip()==FLOAT_TYPE)
					{
						flagValue+=FLOAT_TYPE;
						numarOperatori++;
						$$=(double)A->get_floatValue();
					}
					if(A->get_Tip()==DOUBLE_TYPE)
					{
						flagValue+=DOUBLE_TYPE;
						numarOperatori++;
						$$=A->get_doubleValue();
					}
				}
			}
		
	
%%

int main(int argc, const char* argv[])
{
    char comanda[50];
	cout<<"Dati comanda:";
	cin.get(comanda,50);
	if(strcmp(comanda,"run")==0)
	{
		cout<<"A inceput executia folosind linia de comanda!\n";
		yyparse();
	}
	else
	{
		char*p=strtok(comanda," ");
		char*file;
		if(strcmp(p,"run")!=0)
			cout<<"Comanda gresita!";
		else
		{
			p=strtok(NULL," ");
			file=strdup(p);
		}
		yyin=fopen(file,"r");
		if(yyin==NULL)
		{
			cout<<"Fisierul nu exista!";
			exit(1);
		}
		yyparse();

	}
	return 0;
}
int yyerror(const char *msg) 
{ 	EsteCorecta=0;
	cout<<"EROARE: "<<msg<<endl; 
	return 1;
}