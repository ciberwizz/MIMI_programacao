:-use_module(library(clpfd)).
:-use_module(library(lists)).

% TODO: Aplicar restrições às datas media e final, com base no custo do atraso: 0 #<= (Linhas * Preço) - ((Data final - Data Contrato) * Custo diário de atraso).
% TODO: Limitar linhas de código diário: Da duração de um projeto e do número de linhas obter linhas diárias, somar as linhas diárias dos projetos simultâneos e limitar com o nº de programadores nesse dia * qtde nominal de linhas. 
% TODO: Realizar optimizações.
% TODO: Fazer o alocate para excluir as encomendas que podem fazer falhar o escalonar.
% TODO: Fazer calculo dos rendimentos.
% TODO: Fazer a contabilidade: Do Saldo retirar gastos mensais e adicionar rendimentos.



% Chamar com:
% escalonar(1000, 4, [[350, 1, 10, 30], [450, 1, 14, 20], [600, 1, 23, 40], [1400, 1, 20, 30], [1000, 1, 22, 60]], DatasFim, DatasInicio, DatasMeio, DuracaoProjetos).
% escalonar(1000, 400, [[350, 40, 10, 30], [450, 20, 14, 20], [600, 80, 23, 40], [1400, 100, 20, 30], [1000, 80, 22, 60]], DatasFim, DatasInicio, DatasMeio, DuracaoProjetos).
escalonar(DataTermino, SenioresDisponiveis, Projetos, DatasFim, DatasInicio, DatasMeio, DuracaoProjetos) :-
%escalonar(DataTermino, SenioresDisponiveis, Projetos, DatasFim, DatasInicio, DatasMeio, DuracaoProjetos) :-
% DataTermino = Data limite para terminar todos os projetos.
% SenioresDisponiveis = Quantidade de Séniores disponíveis a cada momento (se for utilizada percentagem, sendo que 1 Senior = 100, é possível atribuir tempo parcial de Senior a projetos).
% Projetos = Lista com os projetos aceites.
        
        % Cria��o das listas com os v�rios par�metros.
        length(Projetos, QtdProjetos),          % Verificar quantos projetos s�o para escalonar.
        length(DatasInicio, QtdProjetos),       % Lista com as datas de inicio dos projetos.
        length(DatasFim, QtdProjetos),          % Lista com as datas de fim dos projetos.
        length(DuracaoProjetos, QtdProjetos),   % Lista com a dura��o dos projetos.
        length(SenioresAtribuidos, QtdProjetos),% Lista com a aloca��o de S�niores aos Projetos (Recurso limitado).
        length(LinhasDeCodigo, QtdProjetos),    % Linhas de c�digo do projeto.
        length(DatasMeio, QtdProjetos),         % Lista com as datas intercalares dos projetos.
        length(LinhasDiarias, QtdProjetos),     % Quantas linhas por dia um projeto precisa para ser terminado no prazo.
        length(Aceitacoes, QtdProjetos),
        
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
%        nl,write('Data limite para conclusão dos projetos': DataTermino), nl,
%        write('Seniores disponíveis': SenioresDisponiveis), nl,
%        write('Linhas de código dos projetos': LinhasDeCodigo), nl,
%        write('Utilização máximo de Séniores': SenioresAtribuidos),nl,
%        write('Datas de entrega intercalar dos projetos ': DatasMeio),nl,
%        write('Datas de finalização dos projetos ': DatasFim),nl,nl,

        

        
        % Definição das variáveis de dominio do problema.        
        domain(DatasInicio, 1, DataTermino),
        domain(DatasFim, 1, DataTermino),
        domain(DuracaoProjetos, 1, DataTermino),
        domain(LinhasDiarias, 1, 10000),
        domain(Aceitacoes, 0, 1),
        


        % Obrigar a que a data final esteja depois da data de inicio.
        ( 
          foreach(DI, DatasInicio),
          foreach(DP, DuracaoProjetos),
%          foreach(AC, Aceitacoes),
          foreach(DF, DatasFim) do
                DF #>= DI + DP
        % Tentei colocar duas restrições, mas falhou. A data tentar abordagem com a data de contrato.
        ),

%        % Não ultrapassar a capacidade de produção mensal.
%        (
%           foreach(DP, DuracaoProjetos),
%           foreach(LC, LinhasDeCodigo),
%           foreach(LD, LinhasDiarias) do
%                LD #= (20 * LC) / (DP * 30)
%                
%         ),
        
        %sum(LinhasDiarias, #<=, CapacidadeDiaria),
        
        % Restrições ao problema.
        MaximoDeProjetos in 1..SenioresDisponiveis,
        sum(Aceitacoes, #>=, 2),

        
        % Pretende-se terminar os projetos o mais cedo possível.
        maximum(Final, DatasFim), 

        
        % Criação das tarefas que vão ser utilizadas como parâmetros do cumulative/2.
        (
            foreach(DI, DatasInicio),
            foreach(DP, DuracaoProjetos),
            foreach(DF, DatasFim),
            %foreach(SA, SenioresAtribuidos),
            %foreach(task(DI, DP, DF, SA,0), ProjetosAEscalonar)
            foreach(LD, LinhasDiarias),
            foreach(task(DI, DP, DF, LD,0), ProjetosAEscalonar)
        do
            true
        ),
        % Preparação do labeling.
        append(DatasInicio, DatasFim, Vars1),
        append(Vars1,[MaximoDeProjetos], Vars),
        
                
        % obtenção de soluções
        %cumulative(ProjetosAEscalonar, [limit(MaximoDeProjetos)]), % Processamento para obtenção do escalonamento de tarefas.
        cumulative(ProjetosAEscalonar, [limit(MaximoDeProjetos)]), % Processamento para obtenção do escalonamento de tarefas.
        labeling([minimize(Final)], Vars),      % Atribuição de valores concretos às variáveis (labeling).
%        labeling([ffc], LinhasDiarias),
        labeling([ffc], Aceitacoes),
        
        
        % Apresentação de resultados.
        write('Datas de inicio dos projetos ': DatasInicio),nl,
        write('Datas de entrega intercalar dos projetos ': DatasMeio),nl,
        write('Datas de finalização dos projetos ': DatasFim),nl,
        write('Duração dos projetos': DuracaoProjetos),nl,
        write('Linhas de código dos projetos': LinhasDeCodigo), nl,
        write('Alocações diárias': LinhasDiarias), nl,
        write('Utilização máximo de Séniores': SenioresAtribuidos),nl,
        write('Máximo de projetos simultâneos ': MaximoDeProjetos),nl,
        write('Aceita��es': Aceitacoes), nl,
%        write('Último projeto termina em ': Final),nl,
        fd_statistics.



