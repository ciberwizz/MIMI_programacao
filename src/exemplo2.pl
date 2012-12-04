:-use_module(library(clpfd)).
:-use_module(library(lists)).


go3 :-  
        CapacidadeActual = 4000,
        ProjetosEmCurso = 5,
        length(DatasInicio, ProjetosEmCurso),
        length(DuracaoProjetos, ProjetosEmCurso),
        length(LinhasCodigo, ProjetosEmCurso),
        %DatasInicio = [1, 2, 3, 6, 7], % start times
        domain(DatasInicio, 1, 10),
        %DuracaoProjetos = [3, 9, 10, 6, 2],% duration times
        domain(DuracaoProjetos, 1, 500),
        LinhasCodigo = [1000, 2000, 5000, 1000, 3000],% resource used by tasks
        % LE = [4,11,13,12, 9],

        Capacidade in 1..CapacidadeActual, % we can't use more than 8 resources at the
                       % same time. In fact, we only use 7 in this
                       % example.

        % setup a list of end times LE
        ( foreach(DI, DatasInicio),
          foreach(DP, DuracaoProjetos),
          foreach(DF, DatasFinais) do
              DF #= DI + DP
        ),

        % latest end time of all tasks, to minimize
        maximum(Termino, DatasFinais), 

        (
            foreach(DI, DatasInicio),
            foreach(DP, DuracaoProjetos),
            foreach(DF, DatasFinais),
            foreach(LC, LinhasCodigo),
            foreach(task(DI, DP, DF, LC, 0),Tasks)
        do
            true
        ),

        cumulative(Tasks, [limit(Capacidade)]),

        append(DatasInicio, DatasFinais, Vars1),
        append(Vars1,[Capacidade], Vars),

        labeling([minimize(Capacidade)], Vars),

        write('start   ': DatasInicio),nl,
        write('duration': DuracaoProjetos),nl,
        write(resource: LinhasCodigo),nl,
        write('end     ': DatasFinais),nl,
        write('limit ': Capacidade),nl,
        write(max_end_time: Termino),nl,
        fd_statistics.