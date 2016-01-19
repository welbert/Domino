Program domino;    //Compilador: Dev-Pascal
uses crt;          //Aluno: Welbert Serra
type
    estrutura=record
      grafic:array[1..7] of string;
      cima,baixo:integer;
    end;
var
i,j,n,x,aux,auxesq,auxdir:integer;//variaveis auxiliares
arq,arq1:file of estrutura;
peca:estrutura;
nivel:integer;//Responsavel pelo nivel do computador
dir,esq:integer;//indica as pontas
x1,x2,arquivo,diretorio:string; //Utilizados na seleção dos arquivos
vez,bateu,passou,soma:integer; //indica a a rodada(vez) , (passou) indica se alguem está sem peça para jogar , (bateu) indica se alguem está sem peças nas mãos
ponto:array [1..4] of integer; //Aqui estará os pontos dos jogadores
mao:array [1..4,1..7] of integer; //Aqui estará a mão dos jogadores
pecaused:array [1..28] of integer; //Aqui mostrará as peças que já foram usadas
ultpeca:array [1..4] of string; //ultima peça usada pelo jogador
pponta:string; //Escolhe a ponta do Player
ppeca:integer; //Escolhe a peca da mão do player
incorreto:integer; //verifica as escolha do jogador

procedure criarpeca;//Criador das peças
var
i,n,x:integer;
arq:file of estrutura;
peca:estrutura;
arquivo,x1:string;
up,down:string;


begin
//Ex.: diretorio:='C:\Users\Welbert\Documents\Pascal\Domino';
diretorio:='';
x:=0;
for i:=0 to 6 do begin
    for n:=i to 6 do begin            //Serão criadas as 28 peças
    x:=x+1;
    str(x,x1);
    arquivo:= concat(diretorio,'\peca',x1,'.pca');
        assign(arq,arquivo);
        rewrite(arq);
        peca.cima:=i;
        peca.baixo:=n;
        str(i,up);
        str(n,down);
        peca.grafic[1]:=' _ _ _';
        peca.grafic[2]:='|     |';
        peca.grafic[3]:='|  '+up+'  |';
        peca.grafic[4]:='|_ _ _|';
        peca.grafic[5]:='|     |';
        peca.grafic[6]:='|  '+down+'  |';
        peca.grafic[7]:='|_ _ _|';
        write(arq,peca);
        close(arq);
    end;
end;

assign(arq,diretorio+'\peca28d.pca');              //Será criada a peça 6/6 deitada
        rewrite(arq);
        peca.cima:=6;
        peca.baixo:=6;
        str(i,up);
        str(n,down);
        peca.grafic[1]:=' _ _ _ _ _ _ ';
        peca.grafic[2]:='|     |     |';
        peca.grafic[3]:='|  '+up+'  |  '+down+'  |';
        peca.grafic[4]:='|_ _ _|_ _ _|';
        write(arq,peca);
        close(arq);


assign(arq,diretorio+'\peca0.pca');             //será criada um espaço vazio que auxiliará a visualização das peças usadas pelo usuario
        rewrite(arq);
        peca.grafic[1]:='       ';
        peca.grafic[2]:='       ';
        peca.grafic[3]:='       ';
        peca.grafic[4]:='       ';
        peca.grafic[5]:='       ';
        peca.grafic[6]:='       ';
        peca.grafic[7]:='       ';
        write(arq,peca);
        close(arq);
        writeln('peca Criada');
end;

procedure pontos; //Indica a pontuação dos jogadores
begin
textcolor(12);
gotoxy(1,1);
writeln('Player: ',ponto[1],'  ');
textcolor(7);
gotoxy(1,2);
writeln('Cpu1: ',ponto[2],'  ');
gotoxy(1,3);
writeln('Cpu2: ',ponto[3],'  ');
gotoxy(1,4);
writeln('Cpu3: ',ponto[4],'  ');
end;

procedure gpontos; //Gerador de pontos
begin
soma:=esq+dir;
              if (soma mod 5 = 0) then
                 ponto[vez]:=soma+ponto[vez];
                   pontos;

end;

procedure distribui; //distribui as peças a todos os jogadores e mostra a mão do usuario na tela
begin
aux:=0;
i:=1;

       while (i<>5) do begin
       	j:=1;	
             while (j<>8) do begin          //"j" só aumentará seu valor quando o usuario ou cpu pegar uma peça que ainda não foi escolhida
             randomize;
             x:=random(28)+1;
                   if (pecaused[x] = 0) then begin
						pecaused[x]:=1;
                        mao[i,j]:=x;
                              if (i=1) then begin
                                 str(x,x1);
                                 arquivo:= concat(diretorio,'\peca',x1,'.pca');
                                 assign(arq,arquivo);
                                 reset(arq);
                                 read(arq, peca);
                                           for n:=1 to 7 do begin
                                           gotoxy(15+aux,0+n);
                                           writeln(peca.grafic[n]);
                                           end;
                                           gotoxy(17+aux,8);
                                           writeln(' | ');
                                           gotoxy(17+aux,9);
                                           writeln(' ',j);
                                 close(arq);
                                 aux:=aux+8;
                                 end;
						j:=j+1
                   end;
         	   end;
         	   i:=i+1;
       end;
end;

Procedure Status; //Status do jogo
begin
textcolor(9);
gotoxy(1,10);
 writeln('Status');
gotoxy(1,11);
writeln('_ _ _ _ _ _ _ _ _ _ _ _ _');
gotoxy(1,12);
writeln('Ponta da esquerda: ',esq,'     |');
gotoxy(1,13);
writeln('Ponta da direita: ',dir,'      |');
gotoxy(1,14);
writeln('                         |');
gotoxy(1,15);
writeln('Ultima peça jogada por:  |');
gotoxy(1,16);
writeln('Player: ',ultpeca[1],'       |');
gotoxy(1,17);
writeln('Cpu1: ',ultpeca[2],'         |');
gotoxy(1,18);
writeln('Cpu2: ',ultpeca[3],'         |');
gotoxy(1,19);
writeln('Cpu3: ',ultpeca[4],'         |');
gotoxy(1,20);
writeln('_ _ _ _ _ _ _ _ _ _ _ _ _|');
textcolor(7);
end;

procedure computador; //Aqui está funcionamento do "computador" no nivel facil
begin
     bateu:=0;
     i:=0;
     for j:=1 to 7 do begin  //Procura na mao todas as peca até que uma seja válida

         if (mao[vez,j] <> 0) then begin
            str(mao[vez,j],x1);
            arquivo:= concat(diretorio,'\peca',x1,'.pca');
            assign(arq,arquivo);
            reset(arq);
            read(arq, peca);
             if (peca.cima = esq) then begin
             passou:=0;
             gotoxy(28,33+auxesq);
                writeln(' _ _ _');
             gotoxy(28,34+auxesq);
                writeln('|     |');
             gotoxy(28,35+auxesq);
                writeln('|  ',peca.cima,'  |');
             gotoxy(28,36+auxesq);
                writeln('|_ _ _|');
             gotoxy(28,37+auxesq);
                writeln('|     |');
             gotoxy(28,38+auxesq);
                writeln('|  ',peca.baixo,'  |');
             gotoxy(28,39+auxesq);
                writeln('|_ _ _|');
                esq:=peca.baixo;
             auxesq:=auxesq+7;
                              mao[vez,j]:=0;
                              j:=7;    //Achando uma peça válida ele sai do "for"
                              str(peca.cima,x1);
                              str(peca.baixo,x2);
                              ultpeca[vez]:= concat('       ',x1,'/',x2);
                              status;
                              gpontos;
             end
             else begin
              if (peca.baixo = esq) then begin
              passou:=0;
              gotoxy(28,33+auxesq);
                writeln(' _ _ _');
              gotoxy(28,34+auxesq);
                writeln('|     |');
              gotoxy(28,35+auxesq);
                writeln('|  ',peca.baixo,'  |');
              gotoxy(28,36+auxesq);
                writeln('|_ _ _|');
              gotoxy(28,37+auxesq);
                writeln('|     |');
              gotoxy(28,38+auxesq);
                writeln('|  ',peca.cima,'  |');
              gotoxy(28,39+auxesq);
                writeln('|_ _ _|');
                esq:=peca.cima;
              auxesq:=auxesq+7;
                               mao[vez,j]:=0;
                               j:=7;  //Achando uma peça válida ele sai do "for"
                               str(peca.cima,x1);
                              str(peca.baixo,x2);
                              ultpeca[vez]:= concat('       ',x1,'/',x2);
                               status;
                               gpontos;
              end
             
             else begin
              if (peca.cima = dir) then begin
              passou:=0;
              gotoxy(48,33+auxdir);
                writeln(' _ _ _');
              gotoxy(48,34+auxdir);
                writeln('|     |');
              gotoxy(48,35+auxdir);
                writeln('|  ',peca.cima,'  |');
              gotoxy(48,36+auxdir);
                writeln('|_ _ _|');
              gotoxy(48,37+auxdir);
                writeln('|     |');
              gotoxy(48,38+auxdir);
                writeln('|  ',peca.baixo,'  |');
              gotoxy(48,39+auxdir);
                writeln('|_ _ _|');
                dir:=peca.baixo;
              auxdir:=auxdir+7;
                               mao[vez,j]:=0;
                               j:=7;  //Achando uma peça válida ele sai do "for"
                               str(peca.cima,x1);
                              str(peca.baixo,x2);
                              ultpeca[vez]:= concat('       ',x1,'/',x2);
                               status;
                               gpontos;
              end             
             else begin
              if (peca.baixo = dir) then begin
              passou:=0;
              gotoxy(48,33+auxdir);
                writeln(' _ _ _');
              gotoxy(48,34+auxdir);
                writeln('|     |');
              gotoxy(48,35+auxdir);
                writeln('|  ',peca.baixo,'  |');
              gotoxy(48,36+auxdir);
                writeln('|_ _ _|');
              gotoxy(48,37+auxdir);
                writeln('|     |');
              gotoxy(48,38+auxdir);
                writeln('|  ',peca.cima,'  |');
              gotoxy(48,39+auxdir);
                writeln('|_ _ _|');
                dir:=peca.cima;
                auxdir:=auxdir+7;
                                 mao[vez,j]:=0;
                                 j:=7;  //Achando uma peça válida ele sai do "for"
                                 str(peca.cima,x1);
                              str(peca.baixo,x2);
                              ultpeca[vez]:= concat('       ',x1,'/',x2);
                                 status;
                                 gpontos;
              end
             else begin
                 i:=i+1;
              end;
             end;
             end;
             end;
         close(arq);
         end else begin
         i:=i+1;
         bateu:=bateu+1;
         end;
     end;
     if (i=7) then begin
        passou:=passou+1;
        ultpeca[vez]:='    Passou';
        status;
     end;
     if (bateu = 7) then begin
          ultpeca[vez]:='     Bateu';
          status;
          delay(500);
          vez:=5;
          end;
     
end;

procedure computadordificil; //Aqui está funcionamento do "computador" no nivel dificil
begin
     i:=0;
     for j:=1 to 7 do begin  //Procura na mao todas as peca até que uma seja válida

         if (mao[vez,j] <> 0) then begin
            str(mao[vez,j],x1);
            arquivo:= concat(diretorio,'\peca',x1,'.pca');
            assign(arq,arquivo);
            reset(arq);
            read(arq, peca);
             if (peca.cima = esq) and ((peca.baixo+dir) mod 5 = 0) then begin
             passou:=0;
             gotoxy(28,33+auxesq);
                writeln(' _ _ _');
             gotoxy(28,34+auxesq);
                writeln('|     |');
             gotoxy(28,35+auxesq);
                writeln('|  ',peca.cima,'  |');
             gotoxy(28,36+auxesq);
                writeln('|_ _ _|');
             gotoxy(28,37+auxesq);
                writeln('|     |');
             gotoxy(28,38+auxesq);
                writeln('|  ',peca.baixo,'  |');
             gotoxy(28,39+auxesq);
                writeln('|_ _ _|');
                esq:=peca.baixo;
             auxesq:=auxesq+7;
                              mao[vez,j]:=0;
                              j:=7;    //Achando uma peça válida ele sai do "for"
                              str(peca.cima,x1);
                              str(peca.baixo,x2);
                              ultpeca[vez]:= concat('       ',x1,'/',x2);
                              status;
                              gpontos;
             end
             else begin
              if (peca.baixo = esq) and ((peca.cima+dir) mod 5 = 0) then begin
              passou:=0;
              gotoxy(28,33+auxesq);
                writeln(' _ _ _');
              gotoxy(28,34+auxesq);
                writeln('|     |');
              gotoxy(28,35+auxesq);
                writeln('|  ',peca.baixo,'  |');
              gotoxy(28,36+auxesq);
                writeln('|_ _ _|');
              gotoxy(28,37+auxesq);
                writeln('|     |');
              gotoxy(28,38+auxesq);
                writeln('|  ',peca.cima,'  |');
              gotoxy(28,39+auxesq);
                writeln('|_ _ _|');
                esq:=peca.cima;
              auxesq:=auxesq+7;
                               mao[vez,j]:=0;
                               j:=7;  //Achando uma peça válida ele sai do "for"
                               str(peca.cima,x1);
                              str(peca.baixo,x2);
                              ultpeca[vez]:= concat('       ',x1,'/',x2);
                               status;
                               gpontos;
              end
             
             else begin
              if (peca.cima = dir) and ((peca.baixo+esq) mod 5 = 0) then begin
              passou:=0;
              gotoxy(48,33+auxdir);
                writeln(' _ _ _');
              gotoxy(48,34+auxdir);
                writeln('|     |');
              gotoxy(48,35+auxdir);
                writeln('|  ',peca.cima,'  |');
              gotoxy(48,36+auxdir);
                writeln('|_ _ _|');
              gotoxy(48,37+auxdir);
                writeln('|     |');
              gotoxy(48,38+auxdir);
                writeln('|  ',peca.baixo,'  |');
              gotoxy(48,39+auxdir);
                writeln('|_ _ _|');
                dir:=peca.baixo;
              auxdir:=auxdir+7;
                               mao[vez,j]:=0;
                               j:=7;  //Achando uma peça válida ele sai do "for"
                               str(peca.cima,x1);
                              str(peca.baixo,x2);
                              ultpeca[vez]:= concat('       ',x1,'/',x2);
                               status;
                               gpontos;
              end             
             else begin
              if (peca.baixo = dir) and ((peca.cima+esq) mod 5 = 0) then begin
              passou:=0;
              gotoxy(48,33+auxdir);
                writeln(' _ _ _');
              gotoxy(48,34+auxdir);
                writeln('|     |');
              gotoxy(48,35+auxdir);
                writeln('|  ',peca.baixo,'  |');
              gotoxy(48,36+auxdir);
                writeln('|_ _ _|');
              gotoxy(48,37+auxdir);
                writeln('|     |');
              gotoxy(48,38+auxdir);
                writeln('|  ',peca.cima,'  |');
              gotoxy(48,39+auxdir);
                writeln('|_ _ _|');
                dir:=peca.cima;
                auxdir:=auxdir+7;
                                 mao[vez,j]:=0;
                                 j:=7;  //Achando uma peça válida ele sai do "for"
                                 str(peca.cima,x1);
                              str(peca.baixo,x2);
                              ultpeca[vez]:= concat('       ',x1,'/',x2);
                                 status;
                                 gpontos;
              end
             else begin
                 i:=i+1;
              end;
             end;
             end;
             end;
         close(arq);
         end else begin
         i:=i+1;
         end;
     end;
     if (i=7) then begin
     computador;
     end;
end;

procedure nivelpc;//Estará escolhendo o nivel do cpu com que o usuario jogará
begin
if (nivel=1) then
computador
else if (nivel=2) then
computadordificil
else
computador
end;

procedure maouser; // Atualiza a mão do usuario
begin
aux:=0;
     for x:=1 to 7 do begin
         str(mao[1,x],x1);
          arquivo:= concat(diretorio,'\peca',x1,'.pca');
          assign(arq1,arquivo);
          reset(arq1);
          read(arq1, peca);
                    for n:=1 to 7 do begin
                        gotoxy(15+aux,0+n);
                        writeln(peca.grafic[n]);
                    end;
                        if (mao[1,x] = 0) then begin
                           gotoxy(17+aux,8);
                           writeln('   ');
                           gotoxy(17+aux,9);
                           writeln('  ');
                        end;
                        close(arq1);
                        aux:=aux+8;
                       

      end;
end;

Procedure Player; //Aqui está os comandos do usuario

     Procedure escolhepeca; //Faz com que o usuario escolha uma peça válida para ser jogada
     begin
     ppeca:=0;
     gotoxy(1,22);
     clreol;
     writeln(x2);
     gotoxy(1,23);
     clreol;
     readln(ppeca);
     if (ppeca>=1) and (ppeca<=7) then //Faz com que o usuario escolha uma peça entre os valores 1 a 7
        incorreto:=4
     else
     x2:='Peca invalida, escolha novamente:';
     str(mao[1,ppeca],x1);
     assign(arq, diretorio+'\peca'+x1+'.pca');
     reset(arq);
     read(arq,peca);
                    if (incorreto = 4 ) then
                    if ((peca.cima <> esq) and (peca.cima <> dir) and (peca.baixo <> esq) and (peca.baixo <> dir)) or (mao[1,ppeca] = 0) then begin
                    incorreto:=1;
                    x2:='Peca invalida, escolha novamente:';
                    end else
                    incorreto:=2;
     close(arq);
     end;

     Procedure checapeca; //Garante que o usuario jogue uma peça em um local "invalido"(quebre a regra do jogo)
     begin
     str(mao[1,ppeca],x1);
     assign(arq, diretorio+'\peca'+x1+'.pca');
     reset(arq);
     read(arq,peca);
            gotoxy(1,24);
            clreol;
            writeln(x2);
            gotoxy(1,25);
            clreol;
            readln(pponta);
            if (pponta = 'voltar') or (pponta = 'Voltar') or (pponta = 'VOLTAR') or (pponta = '3') then
            delay(200);
          if (pponta = 'esquerda') or (pponta = 'Esquerda') or (pponta = 'ESQUERDA') or (pponta = 'esq') or (pponta = '1') then begin
             if (esq <> peca.cima) and (esq <> peca.baixo) then begin
                writeln('Movimento impossivel/Comando Invalido');
              end else
              incorreto:=3;
                           if (peca.cima = esq) then begin
                              gotoxy(28,33+auxesq);
                              writeln(' _ _ _');
                              gotoxy(28,34+auxesq);
                              writeln('|     |');
                              gotoxy(28,35+auxesq);
                              writeln('|  ',peca.cima,'  |');
                              gotoxy(28,36+auxesq);
                              writeln('|_ _ _|');
                              gotoxy(28,37+auxesq);
                              writeln('|     |');
                              gotoxy(28,38+auxesq);
                              writeln('|  ',peca.baixo,'  |');
                              gotoxy(28,39+auxesq);
                              writeln('|_ _ _|');
                              esq:=peca.baixo;
                              auxesq:=auxesq+7;
                              mao[1,ppeca]:=0;
                              str(peca.cima,x1);
                              str(peca.baixo,x2);
                              ultpeca[vez]:= concat('     ',x1,'/',x2,'  ');
                              status;
                              gpontos;
                              maouser;
                            end else begin
                                if (peca.baixo = esq) then begin
                                   gotoxy(28,33+auxesq);
                                   writeln(' _ _ _');
                                   gotoxy(28,34+auxesq);
                                   writeln('|     |');
                                   gotoxy(28,35+auxesq);
                                   writeln('|  ',peca.baixo,'  |');
                                   gotoxy(28,36+auxesq);
                                   writeln('|_ _ _|');
                                   gotoxy(28,37+auxesq);
                                   writeln('|     |');
                                   gotoxy(28,38+auxesq);
                                   writeln('|  ',peca.cima,'  |');
                                   gotoxy(28,39+auxesq);
                                   writeln('|_ _ _|');
                                   esq:=peca.cima;
                                   auxesq:=auxesq+7;
                                   mao[1,ppeca]:=0;
                                   str(peca.cima,x1);
                                   str(peca.baixo,x2);
                                   ultpeca[vez]:= concat('     ',x1,'/',x2,'  ');
                                   status;
                                   gpontos;
                                   maouser;
                                end;
                              end;
          end;
          if (pponta = 'direita') or (pponta = 'Direita') or (pponta = 'DIREITA') or (pponta = 'dir') or (pponta = '2') then begin
             if (dir <> peca.cima) and (dir <> peca.baixo) then begin
                writeln('Movimento impossivel/Comando Invalido');
              end else
              incorreto:=3;
              if (peca.cima = dir) then begin
                              gotoxy(48,33+auxdir);
                              writeln(' _ _ _');
                              gotoxy(48,34+auxdir);
                              writeln('|     |');
                              gotoxy(48,35+auxdir);
                              writeln('|  ',peca.cima,'  |');
                              gotoxy(48,36+auxdir);
                              writeln('|_ _ _|');
                              gotoxy(48,37+auxdir);
                              writeln('|     |');
                              gotoxy(48,38+auxdir);
                              writeln('|  ',peca.baixo,'  |');
                              gotoxy(48,39+auxdir);
                              writeln('|_ _ _|');
                              dir:=peca.baixo;
                              auxdir:=auxdir+7;
                              mao[1,ppeca]:=0;
                              str(peca.cima,x1);
                              str(peca.baixo,x2);
                              ultpeca[vez]:= concat('     ',x1,'/',x2,'  ');
                              status;
                              gpontos;
                              maouser;
                            end else begin
                                if (peca.baixo = dir) then begin
                                   gotoxy(48,33+auxesq);
                                   writeln(' _ _ _');
                                   gotoxy(48,34+auxdir);
                                   writeln('|     |');
                                   gotoxy(48,35+auxdir);
                                   writeln('|  ',peca.baixo,'  |');
                                   gotoxy(48,36+auxdir);
                                   writeln('|_ _ _|');
                                   gotoxy(48,37+auxdir);
                                   writeln('|     |');
                                   gotoxy(48,38+auxdir);
                                   writeln('|  ',peca.cima,'  |');
                                   gotoxy(48,39+auxdir);
                                   writeln('|_ _ _|');
                                   dir:=peca.cima;
                                   auxdir:=auxdir+7;
                                   mao[1,ppeca]:=0;
                                   str(peca.cima,x1);
                                   str(peca.baixo,x2);
                                   ultpeca[vez]:= concat('     ',x1,'/',x2,'  ');
                                   status;
                                   gpontos;
                                   maouser;
                                end;
                              end;
          end;
     close(arq);
     end;

begin
bateu:=0;
i:=0;
incorreto:=0;
for j:=1 to 7 do begin //Faz a verificação de todas as peças do usuario para saber se ele pode jogar alguma peça
    if (mao[1,j] <> 0) then begin
            str(mao[1,j],x1);
            arquivo:= concat(diretorio,'\peca',x1,'.pca');
            assign(arq,arquivo);
            reset(arq);
            read(arq, peca);
                      if (peca.cima <> esq) then
                         if (peca.cima <> dir) then
                            if (peca.baixo <> esq) then
                               if (peca.baixo <> dir) then
                                  i:=i+1;

            close(arq)
     end else begin
     i:=i+1;
     end;
end;

if (i=7) then begin //Não podendo jogar peças o programa passa a vez do usuario
   incorreto:=1;
   ultpeca[1]:='    Passou';
   status;
end;

if (incorreto <> 1) then begin
passou:=0;
x2:='Deseja escolher que peça para jogar?';
            while (incorreto <> 2) do
            escolhepeca;
x2:='Deseja jogar na esquerda, direita ou voltar?';
            checapeca;

end else
incorreto:=3;
end;



begin
writeln('Carregando...');
criarpeca; //Criação das peças que serão utilizadas no jogo
clrscr;
writeln('Escolha o nivel dos computadores');
writeln('1=Facil 2=Dificil');
readln(nivel);
              if (nivel=1) then
                 writeln('Cpu configurado para modo facil')
              else if (nivel=2) then
                   writeln('Cpu configurado para modo dificil')
              else begin
                  writeln('Opção invalida');
                  delay(500);
                  writeln('Configurando para o modo facil');
                  nivel:=1;
              end;
delay(1500);
clrscr;

repeat
pontos; //Impressao dos pontos na tela
distribui; //distribui as pecas do jogo
auxesq:=0;
auxdir:=0;
dir:=6;
esq:=6;
bateu:=0;
passou:=0;
         for i:=1 to 4 do
             ultpeca[i]:='          ';
status; //mostra os status do jogo

//Impressao da primeira peça
assign(arq, diretorio+'\peca28d.pca');
reset(arq);
    read(arq, peca);
              for i:=1 to 4 do begin
              gotoxy(35,32+i);
              writeln(peca.grafic[i]);
              end;
    close(arq);

    for i:=1 to 4 do begin  //Procura o jogador que possui a peca inicial
        for j:=1 to 7 do begin
            if (mao[i,j]=28) then begin
               vez:=i+1;
               mao[i,j]:=0;
               ultpeca[i]:= concat('     6/6  ');
               status;
                           if (i=1) then
                              maouser;
               j:=7;
               i:=4;
            end;
        end;
    end;
    if (vez=5) then
    vez:=1;
    passou:=0;
    while (ponto[1]<100) and (ponto[2]<100) and (ponto[3]<100) and (ponto[4]<100) and (passou <> 4) and (bateu <> 7) do begin
         case vez of
              1:begin
              incorreto:=1;
              while (incorreto <> 3) do
              player;
              gotoxy(1,25);
              clreol;
              gotoxy(1,26);
              clreol;
              gotoxy(1,27);
              clreol;
              delay(500);
              vez:=2;
                         for j:=1 to 7 do begin
                             if mao[1,j] = 0 then
                                bateu:=bateu+1;
                         end;
                         if (bateu=7) then begin
                          vez:=5;
                          ultpeca[1]:='     Bateu';
                          status;
                          delay(1000);
                         end
                         else
                         bateu:=0;
              end;
               2:begin
               nivelpc;
               delay(1000);
               vez:=3;
               end;
               3:begin
               nivelpc;
               delay(1000);
               vez:=4;
               end;
               4:begin
               nivelpc;
               delay(1000);
               vez:=1;
               end;

               else
               vez:=1;
         end;

    end;
    clrscr;
    for i:=1 to 28 do
    pecaused[i]:=0;
Until ((ponto[1]>99) or (ponto[2]>99) or (ponto[3]>99) or (ponto[4]>99));
if (ponto[1]>99) then
writeln('Parabens')
else
writeln('Boa sorte na proxima');

writeln;
textcolor(18);
delay(200);
writeln('@@@@@ @@@@@ @@@@@@@  @@@@@');
delay(200);
writeln('@     @   @ @  @  @  @');
delay(200);
writeln('@ @@@ @   @ @  @  @  @@@@@');
delay(200);
writeln('@ @ @ @@@@@ @  @  @  @');
delay(200);
writeln('@   @ @   @ @  @  @  @');
delay(200);
writeln('@@@@@ @   @ @  @  @  @@@@@');
writeln;
delay(200);
writeln('            @@@@@@ @   @  @@@@@ @@@@@');
delay(200);
writeln('            @    @ @   @  @     @   @');
delay(200);
writeln('            @    @ @   @  @@@@@ @@@@@');
delay(200);
writeln('            @    @ @   @  @     @ @');
delay(200);
writeln('            @    @  @ @   @     @  @');
delay(200);
writeln('            @@@@@@   @    @@@@@ @   @');
readkey;
end.

//Compilador: Dev-Pascal
//Alunos: Welbert Serra e João Vitor

@@@@@ @@@@@ @@@@@@@  @@@@@
@     @   @ @  @  @  @
@ @@@ @   @ @  @  @  @@@@@
@ @ @ @@@@@ @  @  @  @
@   @ @   @ @  @  @  @
@@@@@ @   @ @  @  @  @@@@@

            @@@@@@ @   @  @@@@@ @@@@@
            @    @ @   @  @     @   @
            @    @ @   @  @@@@@ @@@@@
            @    @ @   @  @     @ @
            @    @  @ @   @     @  @
            @@@@@@   @    @@@@@ @   @
