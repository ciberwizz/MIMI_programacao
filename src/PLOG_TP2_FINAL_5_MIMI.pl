% Autores: 
%       Miguel Seabra Rossi
%       080509037 - Paulo Jorge de Faria dos Reis
% Data: Dezembro de 2012
% Tema: Mimi - Programa��o, Lda.
% Objetivo: Aplicar programa��o em l�gica a um problema de optimiza��o de escalonamento de tarefas.

:- use_module(library(clpfd)).
:- use_module(library(lists)).

mimi :- 
        % Vari�veis globais para teste.
%        CustoAtrasoDiario = 1,          % Percentagem do total do projeto a pagar por cada dia de atraso (A).
        Atraso_MaximoDias = 60,         % Maximo de dias de atraso por projeto (Adias).
%        Atraso_MaximoCusto = 50,        % Percentagem m�xima do valor em falta do projeto que pode ser perdido por atrasos (Amax).      
%        
%        LimiteProjetoMedio = 50000,     % Projetos acima deste valor s�o m�dio (Nmed). O valor n�o est� definido no texto, foi escolhido pelo grupo.
        LimiteProjetoComplexo = 100000, % Projetos acima deste valor s�o sempre complexos (Ng).
        Senior_ProjetoComplexo = 50,    % Percentagem de dedica��o do tempo de Senior necess�ria para cada projeto complexo (Dc).
        Senior_Minimo = 33,             % Percentagem de dedica��o do tempo de Senior necess�ria para qualquer projeto (Dmin).
%        EntregaIntermedia_Min = 10,     % Percentagem minima do n.� de linhas do projeto para entrega interm�dia (Imin).
%        EntregaIntermedia_Max = 90,     % Percentagem maxima do n.� de linhas do projeto para entrega interm�dia (Imax). 
%        
        ValorLinha_Complexo = 35,       % Pre�o das linhas de projetos complexos (PUc).
        ValorLinha_Simples = 25,        % Pre�o das linhas de projetos simples (PUs).
%        
        Seniores_Permanentes = 4,       % N�mero de Seniores iniciais (P).
%        CustoContrato = 500,            % Custo de novo contrato (C).
%        OrdenadoJunior = 1000,          % Remunera��o mensal de junior (Jr).
%        OrdenadoSeniorPerm = 4000,      % Remuner��o mensal de Senior permanente (Srp).
%        OrdenadoSeniorCont = 3000,      % Remuner��o mensal de Senior contratado (Src).
%        Produtividade = 35,             % Linhas de codigo por dia por programador (N).
%        Apredizagem = 15,               % Periodo de produtividade nula ap�s contrato.
%        
%        Capital_Inicial = 20000,        % Capital inicial (E),
%        DespesasMensais = 5000,         % Outras despesas mensais fixas.

        % Lista de encomendas para testes.
        Encomendas = [
              [100000, 1, 80, 100], [150000, 0, 170, 200], [50000, 0, 145, 150], [3000, 1, 340, 360], [1000, 1, 280, 300], 
              [4000, 1, 140, 200], [1500, 1, 186, 212], [2900, 1, 135, 150], [5400, 1, 300, 360], [2100, 1, 290, 300],
              [3000, 1, 230, 270], [2300, 0, 150, 200], [1300, 1, 135, 150], [2700, 1, 300, 360], [7200, 1, 220, 300],
              [2500, 1, 320, 360], [1700, 1, 170, 200], [3800, 1, 135, 150], %[1600, 1, 330, 360], %[2900, 1, 270, 300],
%              [1500, 0, 260, 280], [600, 1, 190, 200], [5300, 1, 135, 150], [3100, 1, 300, 360], [300, 1, 250, 300],
%              [3500, 1, 230, 270], [4500, 1, 140, 200], [6300, 0, 135, 150], [4300, 1, 300, 360], [100, 1, 220, 300],
%              [350, 1, 10, 30], [450, 1, 14, 20], [600, 1, 23, 30], [1400, 1, 20, 30], [1000, 1, 22, 30],
%              [550, 1, 20, 25], [850, 1, 15, 18], [900, 1, 13, 22], [1800, 1, 10, 20], [2000, 1, 22, 30],
              [950, 1, 40, 60], [1450, 1, 40, 60], [1600, 1, 23, 35], [1500, 1, 20, 40], [1000, 1, 22, 34],
              [1550, 1, 45, 55], [1850, 1, 35, 47], [1900, 1, 43, 52], [2400, 1, 35, 53], [500, 1, 22, 34],              
              [100, 1, 3, 7]
              ],
        
        % Cria��o das listas com os v�rios par�metros de trabalho.
        length(Encomendas, QtdEncomendas),              % Verificar quantos projetos s�o para escalonar.
%        length(DatasInicio, QtdEncomendas),            % Lista com as datas de inicio dos projetos.
        length(DatasFinaisContratadas, QtdEncomendas),  % Lista com as datas de fim dos projetos.
%        length(DuracaoProjetos, QtdEncomendas),        % Lista com a dura��o dos projetos.
        length(SenioresAAtribuir, QtdEncomendas),       % Lista com a aloca��o de S�niores aos Projetos (Recurso limitado).
        length(Complexidade, QtdEncomendas),            % Lista com a complexidade de acordo com a encomenda.
        length(LinhasDeCodigo, QtdEncomendas),          % Linhas de c�digo do projeto.
        length(DatasMeioContratadas, QtdEncomendas),    % Lista com as datas intercalares dos projetos.
        
        
        % Ler as encomendas.
        (
          foreach([LC, CP, DM, DF], Encomendas),
          foreach(LC, LinhasDeCodigo),
          foreach(CP1, Complexidade),
          foreach(DM, DatasMeioContratadas),
          foreach(DF, DatasFinaisContratadas),
          foreach(SA, SenioresAAtribuir),
          foreach([LC, SA, DM, DF], ProjetosAceites) do     % Criar a lista de tarefas.
                (LC >= LimiteProjetoComplexo -> CP1 = 1; CP1 = CP),     % Garante que o requisito de projetos acima de certa dimens�o � sempre complexo.
                (LC >= LimiteProjetoComplexo -> SA = 100;       % Atribuir Seniores de acordo com complexidade e n�mero de linhas de c�digo. 
%                 CP =:= 1 -> SA = Senior_ProjetoComplexo; SA = Senior_Minimo),
                 CP =:= 1 -> SA = 100; SA = 100)
        ),
%        write('Seniores a atribuir a cada projeto': SenioresAAtribuir), nl,
%        write('Rentabilidade M�xima das Encomendas': RentabilidadeMaximaEncomendas), nl,
        

        % Restri��es a aplicar de acordo com os requisitos:

        
        % Seniores disponiveis.
        Seniores #= Seniores_Permanentes * 100,
        escalonar(1000, Seniores, ProjetosAceites, DatasFim, DatasInicio, DatasMeio, DuracaoProjetos),
%        escalonar(1000, Seniores, [[350, 40, 10, 20], [450, 20, 14, 20], [600, 80, 23, 40], [1400, 100, 20, 30], [1000, 80, 122, 160]], DatasFim, DatasInicio, DatasMeio, DuracaoProjetos),        
        
%        write('Datas de entrega': DatasFim), nl,
%        write('Datas de inicio': DatasInicio), nl,
%        write('Datas intecalares': DatasMeio), nl,
%        write('Dura��o dos projetos': DuracaoProjetos), nl,
        
        
        true.






% Escalonamento (scheduling) dos projetos.
% DataTermino = Data limite para terminar todos os projetos.
% SenioresDisponiveis = Quantidade de S�niores dispon�veis a cada momento (se for utilizada percentagem, sendo que 1 Senior = 100, � possível atribuir tempo parcial de Senior a projetos).
% Projetos = Lista com os projetos aceites.
% escalonar(1000, 4, [[350, 1, 10, 30], [450, 1, 14, 20], [600, 1, 23, 40], [1400, 1, 20, 30], [1000, 1, 22, 60]], DatasFim, DatasInicio, DatasMeio, DuracaoProjetos).
% escalonar(1000, 400, [[350, 40, 10, 30], [450, 20, 14, 20], [600, 80, 23, 40], [1400, 100, 20, 30], [1000, 80, 22, 60]], DatasFim, DatasInicio, DatasMeio, DuracaoProjetos).
escalonar(DataTermino, SenioresDisponiveis, Projetos, DatasFim, DatasInicio, DatasMeio, DuracaoProjetos) :-

        % Cria��o das listas com os v�rios par�metros.
        length(Projetos, QtdProjetos),          % Verificar quantos projetos s�o para escalonar.
        length(DatasInicio, QtdProjetos),       % Lista com as datas de inicio dos projetos.
        length(DatasFim, QtdProjetos),          % Lista com as datas de fim dos projetos.
        length(DuracaoProjetos, QtdProjetos),   % Lista com a dura��o dos projetos.
        length(SenioresAtribuidos, QtdProjetos),% Lista com a aloca��o de S�niores aos Projetos (Recurso limitado).
        length(LinhasDeCodigo, QtdProjetos),    % Linhas de c�digo do projeto.
        length(DatasMeio, QtdProjetos),         % Lista com as datas intercalares dos projetos.
        length(Aceitacoes, QtdProjetos),
        
        % Defini��o das vari�veis de dominio do problema.        
        domain(DatasInicio, 1, DataTermino),
        domain(DatasFim, 1, DataTermino),
        domain(DuracaoProjetos, 1, DataTermino),
        domain(Aceitacoes, 0, 1),
        
        
        % leitura dos dados dos projetos.
        (
          foreach([LC, SA, DM, DF], Projetos),
          foreach(LC, LinhasDeCodigo),
          foreach(SA, SenioresAtribuidos),
          foreach(DM, DatasMeio),
          foreach(DF, DatasFim),
          foreach(DP, DuracaoProjetos),
          foreach(DI, DatasInicio),
          foreach(AC, Aceitacoes),
          foreach(SA, SenioresAtribuidos),
          foreach(task(DI, DP, DF, Res, 0), ProjetosAEscalonar) do
                DP #= DF - DI,
                Res #= SA * AC
        ),

        
        % Restri��es ao problema.
%        maximum(Final, DatasFim), 
        
        MaximoDeProjetos in 1..SenioresDisponiveis,
        sum(Aceitacoes, #>=, 5),
        count(1, Aceitacoes, #=, Aceites),
        minimum(Inicio, DatasInicio),
        
        
        % Prepara��o do labeling.
        append(DatasInicio, DatasFim, Vars1),
        append(Vars1, [MaximoDeProjetos], Vars),
        
                
        % obten��o de solu��es
        cumulative(ProjetosAEscalonar, [limit(MaximoDeProjetos)]), % Processamento para obten��o do escalonamento de tarefas.
        
        labeling([down], Aceitacoes),
        labeling([up], DuracaoProjetos),
        labeling([], Vars),      % Atribui��o de valores concretos às vari�veis (labeling).    
        
        
        % Apresenta��o de resultados.
        write('Datas de inicio dos projetos ': DatasInicio),nl,
        write('Datas de entrega intercalar dos projetos ': DatasMeio),nl,
        write('Datas de finaliza��o dos projetos ': DatasFim),nl,
        write('Dura��o dos projetos': DuracaoProjetos),nl,
        write('Aceita��es': Aceitacoes), nl,
        write('Linhas de c�digo dos projetos': LinhasDeCodigo), nl,
        write('Utiliza��o m�ximo de S�niores': SenioresAtribuidos),nl,
        write('M�ximo de projetos simult�neos ': MaximoDeProjetos),nl,
        write('Recursos utilizados': SenioresAtribuidos), nl,
        write('Projetos escalonados': ProjetosAEscalonar), nl,
        write('Projetos aceites': Aceites), nl,
        write('Inicio': Inicio), nl,
        fd_statistics.
