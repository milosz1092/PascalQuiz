PROGRAM lotnictwo;
USES    GRAPH,CRT;

CONST   lp=16; {ile pytan ma byc zadanych (w pliku jest 16)}
        sciezka='D:\szkola\prog\TEST\pytania.txt'; {sciezka do pytan}
        inf_pat='D:\szkola\prog\TEST\infor.txt';    {sciezka do informacji}


VAR     sterownik,tryb,i,j,z:integer;
        licz,licz_np,msz,ile_p,los,po,tnij,br:byte;

        losy:array[1..lp]of byte; {losowanie pytan czy nie takie same}
        wyb:array[1..lp]of char; {tablica z odp uzytkownika}
        odp:array[1..lp]of string; {tablica z prawidlowymi odp}
        all_p:array[1..30,1..6]of string; {mieszanie}

        twoja,znak:char;
        p,a,b,c,d,ok,poprawna,wycinek,good,wrong,new,linia:string;
        pyt:text;
        inf:text;
        powt:boolean;

PROCEDURE info;
begin
initgraph(sterownik,tryb,'c:\tools\bp\bgi');
SetColor(8);
SetTextStyle(2,horizdir,4);
br:=0;
assign(inf,inf_pat);
reset(inf);
     readLn(inf,linia);
     OutTextXY(1,1,linia);
     readLn(inf,linia);
     setColor(white);
     OutTextXY(1,8,linia);
     readLn(inf,linia);
     SetColor(8);
     OutTextXY(1,15,linia);
     br:=28;
     setColor(7);

while not EOF(inf) do
begin
     readLn(inf,linia);
     OutTextXY(1,br,linia);
     br:=br+10;
end;

readKey;
closeGraph;
close(inf);
end;

PROCEDURE dotablicy;
begin
msz:=0;
     repeat {obliczenie ile jest linii w pliku}
         readLn(pyt);
         inc(msz);
     until (eof(pyt));

ile_p:=msz div 6; {obliczenie ile jest pytan w pliku}
reset(pyt);

for i:=1 to ile_p do
    begin
         {wczytanie do tablicy wszystkich pytan}
         readLn(pyt,p);
         all_p[i,1]:=p;

         readLn(pyt,a);
         all_p[i,2]:=a;

         readLn(pyt,b);
         all_p[i,3]:=b;

         readLn(pyt,c);
         all_p[i,4]:=c;

         readLn(pyt,d);
         all_p[i,5]:=d;

         readLn(pyt,ok);
         all_p[i,6]:=ok;
    end;
end;



PROCEDURE test;
begin
     licz:=0; {licznik poprawnych odpowiedz}
         assign(pyt,sciezka);
         reset(pyt);

         dotablicy;

         randomize;
for i:=1 to lp do
    begin

    repeat {losowanie pytan}
    losy[i]:=random(ile_p)+1;
    powt:=false;

    for j:=1 to i-1 do
      if (losy[i]=losy[j]) then
    powt:=true;
    until not powt;

    los:=losy[i];
         {wypisanie na ekranie pytania i odpowiedzi}
         writeLn(i,'. ',all_p[los,1]);
         textColor(white);
         writeLn(all_p[los,2]);
         writeLn(all_p[los,3]);
         writeLn(all_p[los,4]);
         writeLn(all_p[los,5]);
         textColor(7);
         writeLn;
         writeLn('Wybierz z klawiatury A,B,C lub D');
         write('Aby zakonczyc gre wcisnij ');
         textColor(red);
         writeLn('X');
         textColor(7);

         twoja:=upCase(readKey);
         if (twoja = 'X') then break;
         writeLn;


         {umieszczenie odpowiedzi poprawnej i wybranej
         do roznych tablic w tym samym nr rekordu. Wypelnienie
         zmiennej "po" po to aby wiadomo bylo pod ktorym rekordem
         kryje sie odpowiedz wybrana przez uzytkownika}
         poprawna:=all_p[los,6];
         if (poprawna = 'A') then po:= 2;
         if (poprawna = 'B') then po:= 3;
         if (poprawna = 'C') then po:= 4;
         if (poprawna = 'D') then po:= 5;
         odp[i]:=poprawna;
         wyb[i]:=twoja;

         clrScr;
         if (wyb[i] = odp[i]) then {jezeli takie same odp w tablicach}
           begin
             inc(licz);

             initgraph(sterownik,tryb,'c:\tools\bp\bgi');
             SetColor(green);
             SetTextStyle(3,horizdir,5);
             OutTextXY(100,70,'Bravo!');
             OutTextXY(90,130,'POPRAWNA ODPOWIEDZ :)');


             sound(200);
             delay(150);
             sound(600);
             delay(150);
             sound(1000);
             delay(150);
             sound(2000);
             delay(150);
             nosound;
             delay(500);
             readKey;
             closegraph;

           end
            else {jezeli odpowiedzi nie sa takie same}
             begin
                initgraph(sterownik,tryb,'c:\tools\bp\bgi');
                SetColor(red);
                SetTextStyle(3,horizdir,5);
                OutTextXY(100,70,'Niestety!');
                OutTextXY(90,130,'TO ZLA ODPOWIEDZ :(');

                SetColor(8);
                SetTextStyle(3,horizdir,3);
                OutTextXY(100,200,'Poprawna odpowiedz to:');
                if (length(all_p[los,po]) < 43) then
                  OutTextXY(90,230,all_p[los,po])
                else
                 begin
                     wycinek:=copy(all_p[los,po],1,43);
                     for z:=length(wycinek) downto 1 do
                       begin
                         if (wycinek[z] = ' ') then
                           begin
                               tnij:=z;
                               break;
                           end;
                       end;

                     new:=copy(wycinek,1,tnij-1);
                     OutTextXY(90,230,new+'...');
                 end;

                sound(100);
                delay(1000);
                nosound;
                readKey;
                closegraph;
             end;
    end;
    close(pyt);
    Str(licz,good);
    licz_np:=lp-licz;
    Str(licz_np,wrong);

    {podsumowanie punktacji EKRAN KONCOWY}
    if (licz >= lp div 2) then {jezeli jest 50% odpowiedzi poprawnych}
     begin
           initgraph(sterownik,tryb,'c:\tools\bp\bgi');

           SetColor(green);
           SetTextStyle(3,horizdir,5);
           OutTextXY(100,100,'WYGRALES!');

           SetTextStyle(3,horizdir,2);
           OutTextXY(90,200,'Udzieliles 50% poprawnych odpowiedzi!');

           SetColor(7);
           SetTextStyle(3,horizdir,1);
           OutTextXY(20,20,'Poprawne:   ');
           SetColor(green);
           OutTextXY(130,20,good);
           SetColor(7);
           SetTextStyle(3,horizdir,1);
           OutTextXY(20,40,'Bledne: ');
           SetColor(red);
           OutTextXY(130,40,wrong);

           sound(150);
           delay(150);
           sound(555);
           delay(150);
           sound(3000);
           delay(150);
           sound(2000);
           sound(150);
           delay(150);
           sound(555);
           delay(150);
           sound(3000);
           delay(150);
           nosound;


           SetColor(7);
           SetTextStyle(3,horizdir,1);
           OutTextXY(100,300,'Nacisnij dowolny klawisz aby przejsc do MENU');

           readKey;
           closegraph;
     end else {jezeli jest mniej niz 50% poprawnych}
        begin
           initgraph(sterownik,tryb,'c:\tools\bp\bgi');

           SetColor(red);
           SetTextStyle(3,horizdir,5);
           OutTextXY(100,100,'PRZEGRALES!');

           SetTextStyle(3,horizdir,2);
           OutTextXY(90,200,'Musisz udzielic 50% poprawnych odpowiedzi');

           SetColor(7);
           SetTextStyle(3,horizdir,1);
           OutTextXY(20,20,'Bledne:   ');
           SetColor(red);
           OutTextXY(130,20,wrong);
           SetColor(7);
           SetTextStyle(3,horizdir,1);
           OutTextXY(20,40,'Poprawne: ');
           SetColor(green);
           OutTextXY(130,40,good);

           sound(1000);
           delay(150);
           sound(500);
           delay(150);
           sound(200);
           delay(150);
           sound(100);
           delay(150);
           nosound;
           delay(500);

           SetColor(7);
           SetTextStyle(3,horizdir,1);
           OutTextXY(100,300,'Nacisnij dowolny klawisz aby przejsc do MENU');

           readKey;
           closegraph;
        end;


end;

{GLOWNA CZESC PROGRAMU - menu}

BEGIN
randomize;
repeat
clrScr;

     detectgraph(sterownik,tryb);
     sterownik:=9;
     tryb:=1;
     initgraph(sterownik,tryb,'c:\tools\bp\bgi');

     SetColor(14);
     SetTextStyle(3,horizdir,5);
     OutTextXY(100,100,'Test wiedzy o lotnictwie');

     SetColor(15);
     SetTextStyle(3,horizdir,2);
     OutTextXY(50,200,'S: Rozpocznij test');
     OutTextXY(50,225,'L: Informacje o programie');
     SetColor(8);
     OutTextXY(50,270,'K: Zakoncz program');

     textcolor(7);
     znak:=upCase(readKey);
     closegraph;
    { znak:=upCase(znak); }


case znak of

     'S': test;
     'L': info;

end;

until (znak='K');
      initgraph(sterownik,tryb,'c:\tools\bp\bgi');
      SetColor(15);
      SetTextStyle(3,horizdir,3);
      OutTextXY(40,70,'Dziekujemy za korzystanie z programu');
      setColor(14);
      SetTextStyle(3,horizdir,5);
      OutTextXY(200,120,'Zegnaj!');

      sound(1500);
      delay(150);
      sound(1000);
      delay(150);
      sound(500);
      delay(150);
      sound(150);
      delay(150);
      nosound;

      SetColor(7);
      SetTextStyle(3,horizdir,1);
      OutTextXY(150,300,'Nacisnij dowolny klawisz aby WYJSC');
      readKey;

END.