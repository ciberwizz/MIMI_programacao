/* -*- Mode:Prolog; coding:iso-8859-1; -*- */
% http://www.hakank.org/sicstus/cumulative_test.pl

:- use_module(library(clpfd)).
:- use_module(library(lists)).

go :-
        Data_Limite = 1000,     % Pode ser calculada a partir da data de entrega da última encomenda adicionando o atraso máximo.
        
        % Recursos limitativos.
        Seniores = 7,
        % Linhas_Codigo_Dia = Programadores * 25,
        
        Encomendas = [[1000, 1, 40, 60], [1000, 1, 40, 60], [5000, 1, 60, 100], [10000, 1, 140, 260], [1000, 0, 40, 80],
                [3500, 1, 150, 260], [10000, 1, 400, 600], [30000, 1, 450, 600], [1000, 1, 140, 260], [3000, 1, 120, 160]],
        length(Encomendas, Nr_Encomendas),
        
        % Criar as listas com as datas de forma dinâmica em função dos projetos.
        length(Datas_Inicio, Nr_Encomendas),
%        length(Data_Intercalares, Nr_Encomendas),
        length(Datas_Finais, Nr_Encomendas),
        
        % Uma tarefa tem de terminar depois de começar e tem um meio entre os dois valores.
        ( foreach(Inicio, Datas_Inicio),
%          foreach(Meio, Data_Intercalares),
          foreach(Fim, Datas_Finais)
          do
%                Inicio #< Meio,
                Inicio #<= Fim
        ),
        
        Tempos = [10, 20, 12, 12, 32, 23, 42, 1, 23, 21],
        Seniores_Alocados = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        
          (
            foreach(S, Datas_Inicio),
            foreach(D, Tempos),
            foreach(E, Datas_Finais),
            foreach(R, Seniores_Alocados),
            foreach(task(S,D,E,R,0),Tasks)
        do
            true
        ),  
        
        
        

        
        % Definir o domínio das variáveis.
        domain(Datas_Inicio, 1, Data_Limite),                  
        %domain(Data_Intercalares, 1, Data_Limite),
        domain(Datas_Finais, 1, Data_Limite),
        
  
        
       
        
        
        % cumulative(Lista_de_Inicios, Lista_de_Durações, Lista_de_Fins, Recurso_limite)
        cumulatives(Tasks, Seniores),
        labeling([], Datas_Inicio),
        %labeling([], Data_Intercalares),
        labeling([], Datas_Finais),
        
        write(Datas_Inicio), nl,
        write(Nr_Encomendas).
        



