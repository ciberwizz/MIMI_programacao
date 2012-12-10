:- use_module(library(clpfd)).
:- use_module(library(lists)).

% Mes = [Seniores, LinhasMes, Saldo, Encomendas]
% Encomenda = [Linhas, Complexidade, DataM, DataContrato]



mimilda :-
        length(Anos, 4),        % Anos de exercicio a considerar.
        
        % Criação das listas com Anos e definição dos respectivos domínios.
        (
           foreach([SaldosD, SrpD, LinhasD, DespesasD], Anos) do
                length(SaldosD, 12),
                length(SrpD, 12),
                length(LinhasD, 12),
                length(DespesasD, 12),

              
                domain(SaldosD, 1, 1000000),
                domain(SrpD, 4, 10),
                domain(LinhasD, 1, 10000),
                domain(DespesasD, 1, 10000)

         ),
        
        % Dados de inicio.
        dadosIniciais(Anos, Constantes),
        
        
        % Conta Corrente.
        contaCorrente(Anos, Constantes),
        
        
        % Restrições.
        (
           foreach([SaldosD, SrpD, LinhasD, DespesasD], Anos) do
                (
                   foreach(Saldo, SaldosD) do
                        Saldo #> 0
                ),
                
                sum(SrpD, #=, 100)
                
        ),   
                
        
        % Labeling das variáveis de domínio.
        (
           foreach([SaldosL, SrpL, LinhasL, DespesasL], Anos) do
                labeling([up], SaldosL),
                labeling([ffc], SrpL),
                labeling([ffc], LinhasL),
                labeling([ffc], DespesasL)
        ),

        
        % Apresentação dos resultados.
        (
           foreach(Ano, Anos) do
                write('Ano': Ano), nl
        ).


% Percorre todos os anos e meses e paga as contas.
contaCorrente([_|[]], _).
contaCorrente([[SaldosMensais, Seniores, _, _], [[JaneiroAnoSeguinte|OutrosMeses], _, _, _]|MaisAnos], Parametros) :-

        
        despesasMensais(SaldosMensais, JaneiroAnoSeguinte, Parametros),   

               
        contaCorrente([[[JaneiroAnoSeguinte|OutrosMeses], Seniores, _, _]|MaisAnos], Parametros).




despesasMensais([M1, M2, M3, M4, M5, M6, M7, M8, M9, M10, M11, M12], Jan, [S1|_], [PagamentosMensais, RemSeniorP]) :-
        
        M2 #= M1 - PagamentosMensais - S1 * RemSeniorP,
        M3 #= M2 - PagamentosMensais,
        M4 #= M3 - PagamentosMensais,
        M5 #= M4 - PagamentosMensais,
        M6 #= M5 - PagamentosMensais,
        M7 #= M6 - PagamentosMensais,
        M8 #= M7 - PagamentosMensais,
        M9 #= M8 - PagamentosMensais,
        M10 #= M9 - PagamentosMensais,
        M11 #= M10 - PagamentosMensais,
        M12 #= M11 - PagamentosMensais,
        Jan #= M12 - PagamentosMensais.

% Dados iniciais.
% Dados = [Ano1, Ano2, ...] AnoX = [SaldosD, SrpD, LinhasD, DespesasD] 
dadosIniciais(Dados, [CustosMensaisFixos, RemuneraSenioresPerm]) :-
        CustosMensaisFixos = 5000,
%        SenioresPermanentes #= 4,
        RemuneraSenioresPerm #= 4000,
        nth1(1, Dados, Ano1),
        nth1(1, Ano1, Saldos),
        nth1(1, Saldos, SaldoInicial),
        SaldoInicial #= 500000.


% processarProjetos([task(99,1,100,100,0),task(199,1,200,100,0),task(149,1,150,100,0),task(359,1,360,100,0),task(299,1,300,100,0),task(199,1,200,100,0),task(211,1,212,100,0),task(149,1,150,100,0),task(359,1,360,100,0),task(299,1,300,100,0),task(269,1,270,100,0),task(199,1,200,100,0),task(149,1,150,100,0),task(359,1,360,100,0),task(299,1,300,100,0),task(359,1,360,100,0),task(199,1,200,100,0),task(149,1,150,100,0),task(59,1,60,100,0),task(59,1,60,100,0),task(34,1,35,100,0),task(39,1,40,100,0),task(33,1,34,100,0),task(54,1,55,100,0),task(46,1,47,100,0),task(51,1,52,100,0),task(52,1,53,100,0),task(33,1,34,100,0),task(6,1,7,100,0)], A).

%processarProjetos(Projetos, Anos) :-
%        (
%           foreach(task(DI, DP, DF, Res, 0), Projetos) do
%                true
%
%        ).


%processaEncomenda(DataContrato, DataFim, DataMeio, Linhas, ValorLinha, [Adias, Amax]) :-
%        ValorProjeto = Linhas * ValorLinha,
%        DataFim #>= DataContrato,
%        DataFim #< DataContrato + Adias,
%        DiasCustoAtraso #= ValorProjeto
%        DataFim #< DataContrato + DiasCustoAtraso,
%        DiasAtraso #= DataFim - DataContrato,
%        
%        Ganho #= ValorProjeto - (DiasAtraso * Amax * ValorProjeto / 100),
%        
%                                
%                                
%%                                DataInicio -> minimize
%
%        DataMeio #< DataFim,
%        DataMeio #> DataInicio,
%        Duracao #= DataFim - DataInicio.
      