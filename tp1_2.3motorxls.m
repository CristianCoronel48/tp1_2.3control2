% El codigo a partir de leer la repuesta al escalon te devuelve la FT
%Codigo realizado por JAP 
% syms k1 k2 k3 alfa1 alfa2 beta
% s=solve('alfa1*alfa2=(k2^2-k1*k3)/(k1^2+k2)',...
% 'alfa1+alfa2=(k3+k1*k2)/(k1^2+k2)','alfa1','alfa2');
% simplify(s.alfa1)
% simplify(s.alfa2)
% alfa1=s.alfa1(1);
% alfa2=s.alfa1(2);
% s1=solve('beta*(alfa1-alfa2)=k1+alfa2',...
% 'beta*(alfa1^2-alfa2^2)=k2+alfa2^2',...
% 'beta*(alfa1^3-alfa2^3)=k3+alfa2^3','beta');
% sys_G=tf(2*[8 1],conv([5 1],[6 1])); %la otra planta
%sys_G=tf(16*[45 1],conv([25 1],[30 1]))
%sys_G=tf(3*[10 1],conv([6 1],[6 1])); %esta tiene los polos iguales
% sys_G=tf(2*[8 1],([ 1 2 2])); %la otra planta
% opt = stepDataOptions;
% opt.StepAmplitude = 1;
% t_s=0:2:50;
clear all; clc;
[x1]=xlsread('Curvas_Medidas_Motor'); % lee los datos de la planilla excel
t0=x1(:,1);%vector de tiempo
y=x1(:,2); %velocidad angular omega
t_off=0.02;
t_t1=3e-4;
t_inic=t_off+t_t1; %tiempo de inicio de la simulacion
[val,lugar] =min(abs(t_inic-t0)); y_t1=y(lugar);
ii=0; % for t_inic=10:15
ii=ii+1;
t_2t1=2*t_t1;
t_inic=t_off+t_2t1;
[val,lugar] =min(abs(t_inic-t0));
y_2t1=y(lugar);
t_3t1=3*t_t1;
t_inic=t_off+t_3t1;
[val,lugar] =min(abs(t_inic-t0));
y_3t1=y(lugar);
[val,lugar] =min(abs(0.08-t0));
K=y(lugar)/12; %valor del escalon de 12 voltios
k1=(1/12)*y_t1/K-1;%Afecto el valor del Escalon
k2=(1/12)*y_2t1/K-1;
k3=(1/12)*y_3t1/K-1;
be=4*k1^3*k3-3*k1^2*k2^2-4*k2^3+k3^2+6*k1*k2*k3;
alfa1=(k1*k2+k3-sqrt(be))/(2*(k1^2+k2));
alfa2=(k1*k2+k3+sqrt(be))/(2*(k1^2+k2));
beta=(k1+alfa2)/(alfa1-alfa2);
T1_ang=-t_t1/log(alfa1);
T2_ang=-t_t1/log(alfa2);
T3_ang=beta*(T1_ang-T2_ang)+T1_ang;
T1(ii)=T1_ang;
T2(ii)=T2_ang;
T3(ii)=T3_ang;
T3_ang=sum(T3/length(T3));
T2_ang=sum(T2/length(T2));
T1_ang=sum(T1/length(T1));
sys_G_ang=tf(K,conv([T1_ang 1],[T2_ang 1]))
[yo,to]=step(12*sys_G_ang,.1-t_off);
figure
plot(t0,y,'r'), hold on;
plot(t_t1+0.02019,y_t1,'o')
plot(t_2t1+0.02019,y_2t1,'o')
plot(t_3t1+0.02019,y_3t1,'o')
plot(to+t_off,yo)
