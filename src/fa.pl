:-use_module(library(clpfd)).
:-use_module(library(lists)).


fa :-
        DataTermino = 1000,             % Data limite para terminar todos os projetos.
        SenioresDisponiveis = 4,        % Quantidade de S�niores dispon�veis a cada momento.
        Projectos = [
                        [350, 1, 10, 30], [450, 1, 14, 20], [600, 1, 23, 30], [1400, 1, 20, 30], [1000, 1, 22, 30]
                     ],
        
        length(Projectos, QtdProjetos),         % Verificar quantos projetos s�o para escalonar.
        length(DatasInicio, QtdProjetos),       % Lista com as datas de inicio dos projetos.
        length(DatasFim, QtdProjetos),          % Lista com as datas de fim dos projetos.
        length(DuracaoProjetos, QtdProjetos),   % Lista com a dura��o dos projetos.
        length(SenioresAtribuidos, QtdProjetos),% Lista com a aloca��o de S�niores aos Projetos (Recurso limitado).
        
      
        % Defini��o das vari�veis de domninio do problema.        
        domain(DatasInicio, 1, DataTermino),
        domain(DatasFim, 1, DataTermino),
        domain(DuracaoProjetos, 1, DataTermino),
        

        % Restri��es ao problema.
        MaximoDeProjetos in 1..SenioresDisponiveis,

        
        % Prepara��o das datas de fim dos projetos
        ( foreach(DI, DatasInicio),
          foreach(DP, DuracaoProjetos),
          foreach(DF, DatasFim) do
              DF #= DI + DP
        ),
        
        
        % Atribui��o de S�niores.
        ( foreach(SA, SenioresAtribuidos) do
                SA #= 1
        ),        

        % Pretende-se terminar os projetos o mais cedo poss�vel.
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

        % Prepara��o do labeling.
        append(DatasInicio, DatasFim, Vars1),
        append(Vars1,[MaximoDeProjetos], Vars),

        % Atribui��o de valores concretos �s vari�veis (labeling).
        labeling([minimize(Final)], Vars),

        % Apresenta��o de resultados.
        write('Datas de inicio dos projetos ': DatasInicio),nl,
        write('Datas de finaliza��o dos projetos ': DatasFim),nl,
        write('Dura��o dos projetos': DuracaoProjetos),nl,
        write('Utiliza��o m�ximo de S�niores': SenioresAtribuidos),nl,
        write('M�ximo de projetos simult�neos ': MaximoDeProjetos),nl,
        write('�ltimo projeto termina em ': Final),nl,
        fd_statistics.