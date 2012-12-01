% variable structure
%  
%    trabalham 5 dias por semana
%    tem ferias de 11 dias de 6 em 6 meses
%    renovacao de contracto é gratis
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

%:- use_module(library(clpfd)).
:- use_module(library(lists)).

%hardcoded globals, just to test ideas
%ENC = [+Nlinhas,+Complexidade, -Data_ini, +Data_It, +Data_F_proj, -Nl_it, 
%	-Data_F, N_Sr, N_Jr, Lucro]
alocate( ENC ) :-
	E = 20*1000, % capital para o proj	
	P = 1, % numero de programadores senior perm inicial
	J = 0, % num inicial de juniores
	C = 500, % custo de novo contracto
	Srp = 4000,
	Jr = 1000,
	A = 1, 
	Amax = 20,
	Adias = 21,
	M = 4000,
	PUc = 25,
	Z = 15.
	
	
	



