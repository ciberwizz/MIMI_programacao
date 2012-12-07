% Autores: 
%       Miguel Seabra Rossi
%       080509037 - Paulo Jorge de Faria dos Reis
% Data: Dezembro de 2012
% Tema: Mimi - Programação, Lda.
% Objetivo: Aplicar programação em lógica a um problema de optimizaçãoo de escalonamento de tarefas.

:- use_module(library(clpfd)).
:- use_module(library(lists)).

mimi :- 
        % Variáveis globais para teste.
%        CustoAtrasoDiario = 1,          % Percentagem do total do projeto a pagar por cada dia de atraso (A).
%        Atraso_MaximoDias = 60,         % Maximo de dias de atraso por projeto (Adias).
%        Atraso_MaximoCusto = 50,        % Percentagem máxima do valor em falta do projeto que pode ser perdido por atrasos (Amax).      
%        
%        LimiteProjetoMedio = 50000,     % Projetos acima deste valor são médio (Nmed). O valor não está definido no texto, foi escolhido pelo grupo.
        LimiteProjetoComplexo = 100000, % Projetos acima deste valor são sempre complexos (Ng).
        Senior_ProjetoComplexo = 50,    % Percentagem de dedicação do tempo de Senior necessária para cada projeto complexo (Dc).
        Senior_Minimo = 33,             % Percentagem de dedicação do tempo de Senior necessária para qualquer projeto (Dmin).
%        EntregaIntermedia_Min = 10,     % Percentagem minima do n.º de linhas do projeto para entrega intermédia (Imin).
%        EntregaIntermedia_Max = 90,     % Percentagem maxima do n.º de linhas do projeto para entrega intermédia (Imax). 
%        
        ValorLinha_Complexo = 35,       % Preço das linhas de projetos complexos (PUc).
        ValorLinha_Simples = 25,        % Preço das linhas de projetos simples (PUs).
%        
%        Seniores_Permanentes = 4,       % Número de Seniores iniciais (P).
%        CustoContrato = 500,            % Custo de novo contrato (C).
%        OrdenadoJunior = 1000,          % Remuneração mensal de junior (Jr).
%        OrdenadoSeniorPerm = 4000,      % Remunerção mensal de Senior permanente (Srp).
%        OrdenadoSeniorCont = 3000,      % Remunerção mensal de Senior contratado (Src).
%        Produtividade = 35,             % Linhas de codigo por dia por programador (N).
%        Apredizagem = 15,               % Periodo de produtividade nula após contrato.
%        
%        Capital_Inicial = 20000,        % Capital inicial (E),
%        DespesasMensais = 5000,         % Outras despesas mensais fixas.

        % Lista de encomendas para testes.
        Encomendas = [
              [100000, 1, 80, 100], [150000, 0, 170, 200], [50000, 0, 145, 150], [3000, 1, 340, 360], [1000, 1, 280, 300], 
              [4000, 1, 140, 200], [1500, 1, 186, 212], [2900, 1, 135, 150], [5400, 1, 300, 360], [2100, 1, 290, 300],
              [3000, 1, 230, 270], [2300, 0, 150, 200], [1300, 1, 135, 150], [2700, 1, 300, 360], [7200, 1, 220, 300],
              [2500, 1, 320, 360], [1700, 1, 170, 200], [3800, 1, 135, 150], [1600, 1, 330, 360], [2900, 1, 270, 300],
              [1500, 0, 260, 280], [600, 1, 190, 200], [5300, 1, 135, 150], [3100, 1, 300, 360], [300, 1, 250, 300],
              [3500, 1, 230, 270], [4500, 1, 140, 200], [6300, 0, 135, 150], [4300, 1, 300, 360], [100, 1, 220, 300],
              [350, 1, 10, 30], [450, 1, 14, 20], [600, 1, 23, 30], [1400, 1, 20, 30], [1000, 1, 22, 30],
              [550, 1, 20, 25], [850, 1, 15, 18], [900, 1, 13, 22], [1800, 1, 10, 20], [2000, 1, 22, 30],
              [950, 1, 40, 60], [1450, 1, 40, 60], [1600, 1, 23, 35], [1500, 1, 20, 40], [1000, 1, 22, 34],
              [1550, 1, 45, 55], [1850, 1, 35, 47], [1900, 1, 43, 52], [2400, 1, 35, 53], [500, 1, 22, 34],              
              [100, 1, 3, 7]
              ],
        
        % Criação das listas com os vários parâmetros de trabalho.
        length(Encomendas, QtdEncomendas),              % Verificar quantos projetos são para escalonar.
%        length(DatasInicio, QtdEncomendas),            % Lista com as datas de inicio dos projetos.
        length(DatasFinaisContratadas, QtdEncomendas),  % Lista com as datas de fim dos projetos.
%        length(DuracaoProjetos, QtdEncomendas),        % Lista com a duração dos projetos.
        length(SenioresAAtribuir, QtdEncomendas),       % Lista com a alocação de Séniores aos Projetos (Recurso limitado).
        length(Complexidade, QtdEncomendas),            % Lista com a complexidade de acordo com a encomenda.
        length(LinhasDeCodigo, QtdEncomendas),          % Linhas de código do projeto.
        length(DatasMeioContratadas, QtdEncomendas),    % Lista com as datas intercalares dos projetos.
        length(RentabilidadeMaximaEncomendas, QtdEncomendas),    % Lista com os valores máximos de cada projeto.
        
        

      
        % Ler as encomendas.
        (
          foreach([LC, CP, DM, DF], Encomendas),
          foreach(LC, LinhasDeCodigo),
          foreach(CP1, Complexidade),
          foreach(DM, DatasMeioContratadas),
          foreach(DF, DatasFinaisContratadas) do
                (LC >= LimiteProjetoComplexo -> CP1 = 1; CP1 = CP)      % Garante que o requisito de projetos acima de certa dimensão é sempre complexo.
        ),

        
        % Atribuir Seniores de acordo com complexidade e número de linhas de código.
        (
           foreach(CP, Complexidade),
           foreach(LC, LinhasDeCodigo),
           foreach(SA, SenioresAAtribuir) do
                (LC >= LimiteProjetoComplexo -> SA = 100;       % Requisito de Senior dedicado a 
                CP =:= 1 -> SA = Senior_ProjetoComplexo; SA = Senior_Minimo)
        ),
        write('Seniores a atribuir a cada projeto': SenioresAAtribuir), nl,
       
       % Calcular a rentbilidade máxima de cada encomenda.
        (
           foreach(CP, Complexidade),
           foreach(LC, LinhasDeCodigo),
           foreach(RME, RentabilidadeMaximaEncomendas) do
                (CP =:= 1 -> RME is LC * ValorLinha_Complexo; RME is LC * ValorLinha_Simples) 
        ),
        write('Rentabilidade Máxima dos Projetos': RentabilidadeMaximaEncomendas), nl,
        
        
        
        
        
        
        
        
        
        
        % Restrições a aplicar de acordo com os requisitos:
        % DataFinalDoProjeto #<= DataContrato + Atraso_MaximoDias,  % Garantir que 'Adias' é respeitado.
        % 
        
        
        
        true.
% Processamento da lista de encomendas (Encomendas -> Projetos aceites)
% alocate() :-
% 






