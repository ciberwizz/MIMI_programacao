
:- use_module(library(clpfd)).
:- use_module(library(lists)).


go :-

   %encomendas = [ [ +Nlinhas, +Complex, +Data_ini, +Data_f], ...],
   ENC = [ [1000, 1, Di1, 2],
           [20000,1, Di2, 9],
           [25000,1, Di3, 5],
           [50000,1, Di4, 6] ],

  Sr = 5,
  Cap_inic = 20000,


write('enc_extract\n'),
  enc_extract1(ENC, 3, O_start),
  enc_extract1(ENC, 4, E_end),
  
domain(O_start,1,12),
domain(E_end,1,100),


write('cap_inic\n'),

  (
      foreach(Proj, ENC)
      do
          nth1(3,Proj,DI),
          nth1(4,Proj,Df),
          DI #>= 0,
          DI #<= DF,
          DI #< 12
   
          
  ),

  ( 
     foreach(O,O_start),
     foreach(E,E_end),
     foreach( D , D_duration)
     do
         D #= E - O
  ),

write('D ': D_duration),nl,
  (

     foreach(O, O_start),
     foreach(E, E_end),
     foreach(D, D_duration),
     foreach(task(O,D,E,1,0), TASKS)
     do
          true
  ),
  
write('TASKS ':TASKS),nl,cumulative(TASKS,[]),%[limit(3)]),

write('toappend\n'),
  
  append( O_start, E_start, VARS1),
  append( VARS1, [3],VARS),
  labeling([],VARS),

  write('Start ':O_start),nl,
  write('End ':E_end),nl,
  write('MACH ':MACH),nl,
  fd_statistics.
  


%enc_exctract(ENC, INDEX, +Array)
enc_extract1([],_,[]).
enc_extract1( [HENC | TENC], I, [HARR | TARR]) :-
   nth1(I, HENC, HARR),
   enc_extract1(TENC,I,TARR).

%machine_gen(TEMP_ARR, I , FINAL)
machine_gen(FINAL,0,FINAL).
machine_gen([machine(I,1) | T] , I, FINAL):-
   TI is I -1,
   machine_gen(T, TI, FINAL).


