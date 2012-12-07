% variable structure
%  
%    trabalham 5 dias por semana
%    tem ferias de 11 dias de 6 em 6 meses
%    renovacao de contracto Ã© gratis
% 
%    globais
%       PUs  -> preco de linha de codigo simples
%       PUc  -> preco de linha de codigo complexo
%       C    -> custo de contratacao
%       Srp  -> ordenado senior permanente 
%       Src  -> ordenado senior contractado
%       Jr   -> ordenado junior
%       Z    -> dias que sendo contractado faz 0
%       N    -> N linhas de codigo por dia por programador
%       P    -> numero de programadores senior permanente
%       E    -> capital inicial
%       M    -> despesas mensais fixas
%       A    -> percentagem a descontar no valor do proj 
%		por cada dia de atraso
%       Amax -> percentagem maxima de A*dias de atraso
%       Adias-> maximo de dias de atraso
%
% 
% Encomendas = { [NLinhas,Complexidade, Data_Intermedia, DataFinal],..}
%
%
%

:- use_module(library(clpfd)).
:- use_module(library(lists)).

%ex aceitar_enc([[P1],[P2],[P3]], PROJ, VARS).
% filtrar as encomendas para projectos
aceitar_enc(Enc, Projectos, VARS) :-
        % aceita apenas alguns projectos
	(
            foreach( A , Aceitacoes),
            foreach( E , Enc),
            foreach( P , Projectos)
            do
               A in 0..1,
               append(E,A,P)
        ),
       
        sum(Aceitacoes,#>= , 1),

        labeling( [], Aceitacoes).
      






%hardcoded globals, just to test ideas
%ENC = [[+Nlinhas,+NSeniors, +Data_It, +Data_F_proj, Aceite],..]

% TODO allocate guys to projects
   %TODO bug when there is less than one year of coding of a programmer
% TODO verificar atrasos

% consult('mimi_testes.pl'). alocate( [[10000,1,0,12,1],[8000,1,0,12,1]], Lucro, VARS ).
alocate( ENC, Lucro, VARS ) :-
	E = 200*1000, % capital inicial	
	C = 500, % custo de novo contracto
	Srp = 4000, % ordenado senior
	Jr = 1000, % ordenado Jr
	A = 1,  % percentagem a decontar no lucro por dia de atraso
	Amax = 20, % percentagem max de desconto
	Adias = 21, % dias max de atraso
        N =  35, % producao de linhas de codigo num dia por programador 
	M = 1000, % despesas mensais
	PUc = 25, % preco por linha de codigo num projecto complexo
	Z = 15, % dias apos contratacao em que n produz
        F = 11, % ferias por cada 6 meses
	


        % despesas mensais durante um ano
        Desp_Fixas_ano is 12*M, 
        Cap_projectos is E - Desp_Fixas_ano,

        % os orcamentos podem ir de 1e ate ao capital
        % mas a soma dos orcamentos dos projectos nao ultrapassa o capital inicial
        (
            foreach([Nlinhas, Nseniors, Data_it, Data_F, Aceite], ENC),
            foreach( OT , OrcT),
            foreach( O , Orcamento)
            do
               OT in 1..Cap_projectos,
               O #= OT*Aceite
        ),
        sum(Orcamento, #=< , Cap_projectos),


        (
            foreach( Orc, Orcamento),
            foreach( [Nlinhas, Nseniors, Data_it, Data_F, Aceite], ENC),
            foreach( [Contr,Nlp], Contractos),
            foreach( [Njuniors, Despesas,Receitas, Lucro_it, Lucro_F], Projectos)
            do
                %quantidade de contratos por junior
                Contr #= Aceite*(Data_F/6),

                %numero de linhas que cada programador produz durante o projecto
                Nlp #= Aceite*( (4*5*Data_F - Z - F*Contr)*N  ),

                %numero de juniores e' o numero de programadores necessarios para 
                % programar Nlinhas menos os senior que tb sao programadores 
                Njuniors #= Aceite*(Nlinhas/Nlp),%-Nseniors),

                %despesas sao os ordenados + custos de contrato
		Despesas #= Aceite*(C*Njuniors + Jr*Contr*6*Njuniors + Nseniors*Data_F*Srp),

                %as despesas nao podem ser mais q o orcamento
		Despesas #=< Orc,
                Receitas #= Aceite*(PUc*Nlinhas),            
 
                %TODO 
                Lucro_it #= 0,

		Lucro_F #= Aceite*(Receitas - Despesas),
                Lucro_F #>= 0
      ),
      

      % juntar vars de forma a fazer o labeling
      % append/2 == flatten
      append(Contractos, FContractos),
      append(Projectos, FProjectos),
      append( FContractos, FProjectos, VARS3),
      append( OrcT, Orcamento, VARS1),
      append(VARS1,VARS3,VARS),

      labeling([], VARS),

      write('\n\n\nDADOS\n'),
      write('Contractos ':Contractos),nl,
      write('Projectos ':Projectos),nl,
      write('Orcamento ':Orcamento),nl,
      write('OrcT ': OrcT), nl.



%ex orc_test( [[10000,1,0,12,1],[10000,1,0,12,1]], Lucro, VARS ).
orc_test( ENC, Lucro, VARS ) :-
	E = 200*1000, % capital inicial	
	C = 500, % custo de novo contracto
	Srp = 4000, % ordenado senior
	Jr = 1000, % ordenado Jr
	A = 1,  % percentagem a decontar no lucro por dia de atraso
	Amax = 20, % percentagem max de desconto
	Adias = 21, % dias max de atraso
        N =  35, % producao de linhas de codigo num dia por programador 
	M = 1000, % despesas mensais
	PUc = 25, % preco por linha de codigo num projecto complexo
	Z = 15, % dias apos contratacao em que n produz
        F = 11, % ferias por cada 6 meses
	


        % despesas mensais durante um ano
        Desp_Fixas_ano is 12*M, 
        Cap_projectos is E - Desp_Fixas_ano,write("______":Cap_projectos),nl,

        % os orcamentos podem ir de 1e ate ao capital
        % mas a soma dos orcamentos dos projectos nao ultrapassa o capital inicial
        (
            foreach([Nlinhas, Nseniors, Data_it, Data_F, Aceite], ENC),
            foreach( OT , OrcT),
            foreach( O , Orcamento)
            do
               OT in 1..Cap_projectos,
               O #= OT*Aceite
        ),sum(Orcamento, #=< , Cap_projectos),
        append(Orcamento,OrcT, VARS),
        labeling([],VARS),
        write('\n\nOrcamento: ':Orcamento),nl.




