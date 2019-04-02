clc
clear all
close all

%--------x��ǥ x/c�������� ��Ƽ� ��ü ���б���[0, 1] �� �����.
%---------���� ������ҽ� 1�� ������ߵȴ�. �� �ƹ��͵� ���ص� ��.
AOA=0:2:16;
%% From Soruce Panel
%  load('cpsource.mat')
%  
%  coordi=csvread('naca0012.csv');
% 
% 
% 
% downx=coordi(66:-1:1,1);
% downy=coordi(66:-1:1,2);
% 
% upx=coordi(66:131,1);
% upy=coordi(66:131,2);
% 
% 
% downcp=cp(:,65:-1:1);
% upcp=cp(:,66:130);
%% From vortex panel
  load('cpvortex.mat')
  coordi=csvread('naca0012.csv');



downx=coordi(66:-1:1,1);
downy=coordi(66:-1:1,2);

upx=coordi(66:131,1);
upy=coordi(66:131,2);


downcp=cp(:,65:-1:1);
upcp=cp(:,66:130);


%% ca,cn algorithm and Calculate Cl, Cd
[m,n]=size(downcp);

for i=1:n
udx(i)=upx(i+1)-upx(i);
udy(i)=upy(i+1)-upy(i);
ddx(i)=downx(i+1)-downx(i);
ddy(i)=downy(i+1)-downy(i);
end



for k=1:m
    for i=1:n
    
cn(k,i)=(downcp(k,i))*ddx(i)-(upcp(k,i))*udx(i);


ca(k,i)=(upcp(k,i))*udy(i)-(downcp(k,i))*ddy(i);

    end
end


allcn=sum(cn,2);
allca=sum(ca,2);

for k=1:m
cl(k)=allcn(k)*cosd(AOA(k))-allca(k)*sind(AOA(k));
cd(k)=(allcn(k)*sind(AOA(k))+allca(k)*cosd(AOA(k)));
end

cl
cd