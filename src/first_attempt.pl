:-use_module(library(clpfd)).
:-use_module(library(lists)).

% TODO: Aplicar restri��es �s datas media e final, com base no custo do atraso: 0 #<= (Linhas * Pre�o) - ((Data final - Data Contrato) * Custo di�rio de atraso).
% TODO: Limitar linhas de c�digo di�rio: Da dura��o de um projeto e do n�mero de linhas obter linhas di�rias, somar as linhas di�rias dos projetos simult�neos e limitar com o n� de programadores nesse dia * qtde nominal de linhas. 
% TODO: Realizar optimiza��es.
% TODO: Fazer o alocate para excluir as encomendas que podem fazer falhar o escalonar.
% TODO: Fazer calculo dos rendimentos.
% TODO: Fazer a contabilidade: Do Saldo retirar gastos mensais e adicionar rendimentos.



% Chamar com:
% escalonar(1000, 4, [[350, 1, 10, 30], [450, 1, 14, 20], [600, 1, 23, 40], [1400, 1, 20, 30], [1000, 1, 22, 60]], DatasFim, DatasInicio, DatasMeio, DuracaoProjetos).
% escalonar(1000, 400, [[350, 40, 10, 30], [450, 20, 14, 20], [600, 80, 23, 40], [1400, 100, 20, 30], [1000, 80, 22, 60]], DatasFim, DatasInicio, DatasMeio, DuracaoProjetos).

escalonar(DataTermino, SenioresDisponiveis, Projetos, DatasFim, DatasInicio, DatasMeio, DuracaoProjetos) :-
%escalonar(DataTermino, SenioresDisponiveis, Projetos, DatasFim, DatasInicio, DatasMeio, DuracaoProjetos) :-
% DataTermino = Data limite para terminar todos os projetos.
% SenioresDisponiveis = Quantidade de S�niores dispon�veis a cada momento (se for utilizada percentagem, sendo que 1 Senior = 100, � poss�vel atribuir tempo parcial de Senior a projetos).
% Projetos = Lista com os projetos aceites.
        
        % Cria��o das listas com os v�rios par�metros.
        length(Projetos, QtdProjetos),          % Verificar quantos projetos s�o para escalonar.
        length(DatasInicio, QtdProjetos),       % Lista com as datas de inicio dos projetos.
        length(DatasFim, QtdProjetos),          % Lista com as datas de fim dos projetos.
        length(DuracaoProjetos, QtdProjetos),   % Lista com a dura��o dos projetos.
        length(SenioresAtribuidos, QtdProjetos),% Lista com a aloca��o de S�niores aos Projetos (Recurso limitado).
        length(LinhasDeCodigo, QtdProjetos),    % Linhas de c�digo do projeto.
        length(DatasMeio, QtdProjetos),         % Lista com as datas intercalares dos projetos.

        
        % leitura dos dados dos projetos.
        (
          foreach([LC, SA, DM, DF], Projetos),
          foreach(LC, LinhasDeCodigo),
          foreach(SA, SenioresAtribuidos),
          foreach(DM, DatasMeio),
          foreach(DF, DatasFim) do
                true
        ),
        % Debug do carregamento de dados.
%        nl,write('Data limite para conclus�o dos projetos': DataTermino), nl,
%        write('Seniores dispon�veis': SenioresDisponiveis), nl,
%        write('Linhas de c�digo dos projetos': LinhasDeCodigo), nl,
%        write('Utiliza��o m�ximo de S�niores': SenioresAtribuidos),nl,
%        write('Datas de entrega intercalar dos projetos ': DatasMeio),nl,
%        write('Datas de finaliza��o dos projetos ': DatasFim),nl,nl,
        
        
        % Defini��o das vari�veis de dominio do problema.        
        domain(DatasInicio, 1, DataTermino),
        domain(DatasFim, 1, DataTermino),
        domain(DuracaoProjetos, 1, DataTermino),


        % Obrigar a que a data final esteja depois da data de inicio.
        ( 
          foreach(DI, DatasInicio),
          foreach(DP, DuracaoProjetos),
          foreach(DF, DatasFim) do
                DF #>= DI + DP
        % Tentei colocar duas restri��es, mas falhou. A data tentar abordagem com a data de contrato.
        ),

        
        % Restri��es ao problema.
        MaximoDeProjetos in 1..SenioresDisponiveis,
      
        
        % Pretende-se terminar os projetos o mais cedo poss�vel.
        maximum(Final, DatasFim), 

        
        % Cria��o das tarefas que v�o ser utilizadas como par�metros do cumulative/2.
        (
            foreach(DI, DatasInicio),
            foreach(DP, DuracaoProjetos),
            foreach(DF, DatasFim),
            foreach(SA, SenioresAtribuidos),
            foreach(task(DI, DP, DF, SA,0), ProjetosAEscalonar)
        do
            true
        ),
        % Prepara��o do labeling.
        append(DatasInicio, DatasFim, Vars1),
        append(Vars1,[MaximoDeProjetos], Vars),
        
        
        % obten��o de solu��es
        cumulative(ProjetosAEscalonar, [limit(MaximoDeProjetos)]), % Processamento para obten��o do escalonamento de tarefas.
        labeling([minimize(Final)], Vars),      % Atribui��o de valores concretos �s vari�veis (labeling).

        
        % Apresenta��o de resultados.
        write('Datas de inicio dos projetos ': DatasInicio),nl,
        write('Datas de entrega intercalar dos projetos ': DatasMeio),nl,
        write('Datas de finaliza��o dos projetos ': DatasFim),nl,
        write('Dura��o dos projetos': DuracaoProjetos),nl,
        write('Linhas de c�digo dos projetos': LinhasDeCodigo), nl,
        write('Utiliza��o m�ximo de S�niores': SenioresAtribuidos),nl,
        write('M�ximo de projetos simult�neos ': MaximoDeProjetos),nl,
        write('�ltimo projeto termina em ': Final),nl,
        fd_statistics.