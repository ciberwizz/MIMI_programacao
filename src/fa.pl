:-use_module(library(clpfd)).
:-use_module(library(lists)).


fa :-
        DataTermino = 1000,             % Data limite para terminar todos os projetos.
        SenioresDisponiveis = 4,        % Quantidade de Séniores disponíveis a cada momento.
        Projectos = [
                        [350, 1, 10, 30], [450, 1, 14, 20], [600, 1, 23, 30], [1400, 1, 20, 30], [1000, 1, 22, 30]
                     ],
        
        length(Projectos, QtdProjetos),         % Verificar quantos projetos são para escalonar.
        length(DatasInicio, QtdProjetos),       % Lista com as datas de inicio dos projetos.
        length(DatasFim, QtdProjetos),          % Lista com as datas de fim dos projetos.
        length(DuracaoProjetos, QtdProjetos),   % Lista com a duração dos projetos.
        length(SenioresAtribuidos, QtdProjetos),% Lista com a alocação de Séniores aos Projetos (Recurso limitado).
        
      
        % Definição das variáveis de domninio do problema.        
        domain(DatasInicio, 1, DataTermino),
        domain(DatasFim, 1, DataTermino),
        domain(DuracaoProjetos, 1, DataTermino),
        

        % Restrições ao problema.
        MaximoDeProjetos in 1..SenioresDisponiveis,

        
        % Preparação das datas de fim dos projetos
        ( foreach(DI, DatasInicio),
          foreach(DP, DuracaoProjetos),
          foreach(DF, DatasFim) do
              DF #= DI + DP
        ),
        
        
        % Atribuição de Séniores.
        ( foreach(SA, SenioresAtribuidos) do
                SA #= 1
        ),        

        % Pretende-se terminar os projetos o mais cedo possível.
        maximum(Final, DatasFim), 

        (
            foreach(DI, DatasInicio),
            foreach(DP, DuracaoProjetos),
            foreach(DF, DatasFim),
            foreach(SA, SenioresAtribuidos),
            foreach(task(DI, DP, DF, SA,0), Projetos)
        do
            true
        ),

        cumulative(Projetos, [limit(MaximoDeProjetos)]),

        % Preparação do labeling.
        append(DatasInicio, DatasFim, Vars1),
        append(Vars1,[MaximoDeProjetos], Vars),

        % Atribuição de valores concretos às variáveis (labeling).
        labeling([minimize(Final)], Vars),

        % Apresentação de resultados.
        write('Datas de inicio dos projetos ': DatasInicio),nl,
        write('Datas de finalização dos projetos ': DatasFim),nl,
        write('Duração dos projetos': DuracaoProjetos),nl,
        write('Utilização máximo de Séniores': SenioresAtribuidos),nl,
        write('Máximo de projetos simultâneos ': MaximoDeProjetos),nl,
        write('Último projeto termina em ': Final),nl,
        fd_statistics.