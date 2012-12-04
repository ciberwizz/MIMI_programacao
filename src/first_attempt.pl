:-use_module(library(clpfd)).
:-use_module(library(lists)).


fa :-
        Encomendas = [
                        [350, 1, 10, 30], [450, 1, 14, 20], [600, 1, 23, 30], [1400, 1, 20, 30], [1000, 1, 22, 30]
                     ],
        
        length(Encomendas, QtdEnc),
        
        
        
        
        
        
        length(LS,QtdEnc),
        length(LD,QtdEnc),
        length(LR,QtdEnc),
        %LS = [1, 2, 3, 6, 7], % start times
        domain(LS,1,10),
        LD = [3, 9,10, 6, 2],% duration times
        LR = [1, 2, 1, 1, 3],% resource used by tasks
        % LE = [4,11,13,12, 9],

        Limit in 1..8, % we can't use more than 8 resources at the
                       % same time. In fact, we only use 7 in this
                       % example.

        % setup a list of end times LE
        ( foreach(S,LS),
          foreach(D,LD),
          foreach(K,LE) do
              K #= S+D
        ),

        % latest end time of all tasks, to minimize
        maximum(End,LE), 

        (
            foreach(S, LS),
            foreach(D, LD),
            foreach(E, LE),
            foreach(R, LR),
            foreach(task(S,D,E,R,0),Tasks)
        do
            true
        ),

        cumulative(Tasks, [limit(Limit)]),

        append(LS,LE, Vars1),
        append(Vars1,[Limit], Vars),

        labeling([minimize(Limit)], Vars),

        write('start   ':LS),nl,
        write(duration:LD),nl,
        write(resource:LR),nl,
        write('end     ':LE),nl,
        write('limit ':Limit),nl,
        write(max_end_time:End),nl,
        fd_statistics.