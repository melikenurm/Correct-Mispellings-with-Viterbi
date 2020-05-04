clear all;
dataset=importdata('C:\Users\Melike Nur Mermer\Desktop\docs.data');
tornsay=20000;
eornbas=tornsay+1;
eornson=length(dataset);
eornsay=140980;
Nst=26;
%eðitim dokümanýnýn oluþturulmasý
for i=1:eornsay
edata(i,:) = char(dataset(i+tornsay,:));
end
%test dokümanýnýn oluþturulmasý
for i=1:20000
tdata(i,:)=char(dataset(i,:));
testd(i,1)=tdata(i,3);
testi(i,1)=harfindisi(testd(i,1));
end
%strdata(1,:)=split(strdata(1,:));
I=zeros(1,26);
A=zeros(26);
B=zeros(26);

%I dizisinin oluþturulmasý
indis=harfindisi(edata(1,1));
I(1,indis)=1;
for i=1:eornsay
    if strcmp(edata(i,:),'_ _')
        indis=harfindisi(edata(i+1,1));
        I(indis)=I(indis)+1;
    end
end

%A matrisinin oluþturulmasý
for i=1:eornsay-1
    if strcmp(edata(i,:),'_ _') || strcmp(edata(i+1,:),'_ _')
        continue;
    end
    onceki=edata(i,1);
    oindis=harfindisi(onceki);
    sonraki=edata(i+1,1);
    sindis=harfindisi(sonraki);
    A(oindis,sindis)=A(oindis,sindis)+1;
end

%B matrisinin oluþturulmasý
for i=1:eornsay
    if strcmp(edata(i,:),'_ _')
        continue;
    end    
    indis=harfindisi(edata(i,:));
    B(indis(1),indis(3))=B(indis(1),indis(3))+1;
end

isatir=sum(I);
for i=1:26
    I(1,i)=I(1,i)/isatir;
end
for i=1:26
    asatir=sum(A(i,:));
    bsatir=sum(B(i,:));
    for j=1:26
    A(i,j)=A(i,j)/asatir;
    B(i,j)=B(i,j)/bsatir;
    end
end

%viterbi
lob=length(testi);
I=transpose(I);
del=zeros(lob,Nst);
maxlist=del;
mx=zeros(1,lob);
for t=1:lob
    if t==1
       del(t,:)=I.*B(testi(t),:)'; %Initialization
       [p mx(t)]=max(del(t,:));
       continue;
    end    
    if strcmp(testd(t),'_')
       continue;
    end
    if strcmp(testd(t-1),'_')
        del(t,:)=I.*B(testi(t),:)';
        [p mx(t)]=max(del(t,:));
        continue;
    end

    %Recursive Phase    
    for j=1:Nst
        [del(t,j) maxlist(t,j)]=max(del(t-1,:).*A(:,j)');
    end
    del(t,:)=del(t,:).*B(:,testi(t))';
    [p mx(t)]=max(del(t,:));
end

%Termination
dec_state=zeros(1,lob);
%decode_state=char(lob,1);
[pstar dec_state(lob)]=max(del(lob,:));

for t=t-1:-1:1
    if strcmp(testd(t),'_')
       continue;
    end
    if strcmp(testd(t+1),'_')
       [pstar dec_state(t)]=max(del(t,:));
       continue;
    end    
    dec_state(t)=maxlist(t+1,dec_state(t+1));
end

for t=1:lob
decode_state(t,1)=indisharfi(dec_state(1,t));
if strcmp(decode_state(t,1),'`')
decode_state(t,1)='_';
end
end

yanlisharf=0;%baþlangýçtaki yanlýþ harf sayýsý
yanlisharf2=0;%viterbinin yanlýþ harf sayýsý
for i=1:tornsay
    if tdata(i,1)~=tdata(i,3)
        yanlisharf=yanlisharf+1;
    end
    if tdata(i,1)~=decode_state(i,1)
        yanlisharf2=yanlisharf2+1;
    end
end

yanlis=0;
yanliskelime=0;%baþlangýçtaki yanlýþ kelime sayýsý
yanlis2=0;
yanliskelime2=0;%viterbinin yanlýþ kelime sayýsý

for i=1:tornsay
if strcmp(tdata(i,:),'_ _')
if yanlis==1
   yanliskelime=yanliskelime+1;
end
yanlis=0;
continue;
end
if tdata(i,1)~=tdata(i,3)
yanlis=1;
end
end

for i=1:tornsay
if strcmp(tdata(i,:),'_ _')
if yanlis2==1
   yanliskelime2=yanliskelime2+1;
end
yanlis2=0;
continue;
end
if tdata(i,1)~=decode_state(i,1)
yanlis2=1;
end
end

kelime=1;
for i=1:tornsay
    if strcmp(tdata(i,:),'_ _')
        kelime=kelime+1;
    end
end
dogruharf=tornsay-kelime+1-yanlisharf;
dogruharf2=tornsay-kelime+1-yanlisharf2;

dogrukelime=kelime-yanliskelime;
dogrukelime2=kelime-yanliskelime2;
    