
close all
clear all

%% Aircraft Specification and Control Derivatives
 
   f = waitbar(0,'Start Program');
  
   tic_s = tic;
   t1_s = tic;
   t2_s = tic;
   t3_s = tic;
   
   %g= 32.17405 ft/s2
   rho = 0.002377; % slugs/ft^3 at sea level
 m = 0.308; % slugs ,  1 kg = 0.069 slgus
U = 65; %ft/sec ,  1 ft/s = 0.305 m/s
S = 10.22; %ft^2    1 m^2 = 10.76 ft^2
b = 6.56; %ft , Wingspan,  1 m = 3.28 ft
q = (rho*U^2)/2; % slugs/(ft*sec^2)
   I_x = 0.482; %slug*ft^2 , 1 kg*m^2 = 0.74 slug*ft^2
   I_z = 0.962; %slug*ft^2
   I_xz = 0; %slug*ft^2
   
   C_lp = -0.385;
   C_lr = 0.055;
   C_np = 0.024;
   C_nbeta = 0.071;
   C_nr = -0.053;
   C_ybeta = -0.279; 
   C_yphi = 0.049;  % mg*cos(theta)/Sq
   C_ypsi = 0;   % mg*sin(theta)/Sq
   C_lbeta = -0.0684;
   C_yRud = 0;
   C_nRud = 0;
   C_lRud = 0;
   C_yAil = -0.03;
   C_nAil = -0.011;
   C_lAil = 0.254;
   
%% State Equation
   
   A=[C_ybeta C_yphi 0 -(m*U)/(S*q);
       0 0 1 0;
       C_lbeta 0 (b*C_lp)/(2*U) (b*C_lr)/(2*U);
       C_nbeta 0 (b*C_np)/(2*U) (b*C_nr)/(2*U)];
   
   A(1,:)=A(1,:)*(S*q)/(m*U);
   A(3,:)=A(3,:)*(S*q*b)/(I_x);
   A(4,:)=A(4,:)*(S*q*b)/(I_z);
%------- Only Aileron Input-----------------------------------------------%  
   B1 = [C_yAil; 0; C_lAil; C_nAil];
   B1(1,:)=B1(1,:)*(S*q)/(m*U);
   B1(3,:)=B1(3,:)*(S*q*b)/(I_x);
   B1(4,:)=B1(4,:)*(S*q*b)/(I_z);
   
  %------- Only Rudder Input-----------------------------------------------%
   B2 = [C_yRud; 0; C_lRud; C_nRud];
   B2(1,:)=B2(1,:)*(S*q)/(m*U);
   B2(3,:)=B2(3,:)*(S*q*b)/(I_x);
   B2(4,:)=B2(4,:)*(S*q*b)/(I_z);
   
   t1_e = toc(t1_s);
%% Euler Integration
 check = exist ('toc_e','var');
 if check==1 
  waitbar(t1_e/toc_e,f,'Start Euler Integration');
 end
  
  
  
  dt = 0.0001;
  t=0:dt:30; % 0초에서 60초까지
  X1 = [0; 0; 0; 0]; % Initial condition when Aileron input
  X2 = [0; 0; 0; 0]; % Initial condition when Rudder input
  
  %---------Aileron-------------------------------------%
  for i = 1: size(t,2)
      
      if t(i) <= 2 && t(i) >=1
          u = 2*pi/180; %rad
      else
          u = 0;
      end
      dX1 = A*X1 + B1*u;
      X1 = X1 + dX1*dt;
      
      result1(i,:) = X1';
  end
  
  input_ail=zeros(1,size(t,2));
  input_ail(find(t==1):find(t==2))=2; %deg
  beta1= result1(:,1)*180/pi; %deg
  phi1= result1(:,2)*180/pi; %deg
  phi_dot1 = result1(:,3)*180/pi; %deg
  psi_dot1 = result1(:,4)*180/pi; %deg
  
 %-----Obtaining yaw with numerical integration(Aileron Input)-----------% 
   for i = 1:size(t,2)
      if i==1
      psi1(i) = 0;
      else
       psi1(i) = psi1(i-1) + psi_dot1(i)*dt;
      end
  end


   %---------Rudder------------------------------------%
  for i = 1: size(t,2)
      
      if t(i) <= 3 && t(i) >=2
          u = 0*pi/180; %rad
      else
          u = 0;
      end
      dX2 = A*X2 + B2*u;
      X2 = X2 + dX2*dt;
      
      result2(i,:) = X2';
  end
  
  input_rud=zeros(1,size(t,2));
  input_rud(find(t==1):find(t==3))=4; % deg
  beta2= result2(:,1)*180/pi; %deg
  phi2= result2(:,2)*180/pi; %deg
  phi_dot2 = result2(:,3)*180/pi; %deg
  psi_dot2 = result2(:,4)*180/pi; %deg
  
%-----Obtaining yaw with numerical integration(Rudder Input)-----------% 
  
  for i = 1:size(t,2)
      if i==1
      psi2(i) = 0;
      else
       psi2(i) = psi2(i-1) + psi_dot2(i)*dt;
      end
  end
  
  t2_e = toc(t2_s);
%% Plot
check = exist ('toc_e','var');
if check ==1
 waitbar(t2_e/toc_e,f,'Start Plotting');
end

 
 figure(1)
 
subplot(3,1,1)
 plot(t, phi1)
 ylabel('\phi (deg)')
 title('Aileron Deflection(1/2)')
 grid on
 
 subplot(3,1,2)
 plot(t, phi_dot1)
 ylabel('$\dot{\phi}$ (deg/sec)','interpreter','latex')
 grid on
 
 subplot(3,1,3)
 plot(t,psi1)
 ylabel('\psi (deg)')
 xlabel('Time(s)')
 grid on

 figure(2)
 
 subplot(3,1,1)
 plot(t, psi_dot1)
 ylabel('$\dot{\psi}$ (deg/sec)','interpreter','latex')
 title('Aileron Deflection(2/2)')
 grid on
 
 subplot(3,1,2)
 plot(t, beta1)
 ylabel('\beta (deg)')
 grid on
 
 subplot(3,1,3)
 plot(t,input_ail)
 ylabel('\delta_{a} (deg)')
 xlabel('Time(s)')
 grid on

 
 figure(3)
 
 subplot(3,1,1)
 plot(t, phi2)
 ylabel('\phi (deg)')
 title('Rudder Deflection(1/2)')
 grid on
 
 subplot(3,1,2)
 plot(t, phi_dot2)
 ylabel('$\dot{\phi}$ (deg/sec)','interpreter','latex')
 grid on
 
 subplot(3,1,3)
 plot(t,psi2)
 ylabel('\psi (deg)')
 xlabel('Time(s)')
 grid on
 
 figure(4)
 
 subplot(3,1,1)
 plot(t, psi_dot2)
 ylabel('$\dot{\psi}$ (deg/sec)','interpreter','latex')
 title('Rudder Deflection(2/2)')
 grid on
 
 subplot(3,1,2)
 plot(t, beta2)
 ylabel('\beta (deg)')
 grid on
 
 subplot(3,1,3)
 plot(t,input_rud)
 ylabel('\delta_{r} (deg)')
 xlabel('Time(s)')
 grid on
 
 t3_e = toc(t3_s);

%% Flight Mode Analysis
check = exist ('toc_e','var');
if check==1
  waitbar(t3_e/toc_e,f,'Start Flight Mode Analysis');
  
end
 syms s
 
 A_s = [(I_x*s^2)/(S*q*b)-(b*C_lp*s)/(2*U) -(I_xz*s^2)/(S*q*b)-(b*C_lr*s)/(2*U) -C_lbeta;
         -(I_xz*s^2)/(S*q*b)-(b*C_np*s)/(2*U) (I_z*s^2)/(S*q*b)-(b*C_nr*s)/(2*U) -C_nbeta;
         -C_yphi (m*U*s)/(S*q)-C_ypsi (m*U*s)/(S*q)-C_ybeta]; %A(s)
     
     vpa(A_s,4) % Variable-precision arithmetic
     
     Del_s = det(A_s); % Determinant of A(s)
     ANS = solve(Del_s); % Solve Characteristic Equation
     ANS = double(ANS);  % Convert to Double format
     roll = ANS(2);
     spiral = ANS(3);
     dutch1 = ANS(4);
     dutch2 = ANS(5);
     
     fprintf('Roll Subsidence = %.4f%+.4fi \n',real(roll),imag(roll));
     fprintf('Spiral Divergence = %.4f%+.4fi \n',real(spiral),imag(spiral));
     fprintf('Dutch Roll Mode = %.4f%+.4fi, %.4f%+.4fi  \n',real(dutch1),imag(dutch1),real(dutch1),imag(dutch2));
 
  toc_e = toc(tic_s);
     
waitbar(1,f,'Finishing');

close(f)
%% Flight mode plot 
figure()
plot(t(find(t==0):find(t==4)),beta2(find(t==0):find(t==4)))
hold on
grid on
plot(t(find(t==0):find(t==4)),phi2(find(t==0):find(t==4)))
plot(t(find(t==0):find(t==4)),psi2(find(t==0):find(t==4)))
xlabel('Time(s)')
ylabel('deg')
legend('\beta','\phi','\psi')
title('Dutch Roll mode(Rudder Deflected)')
figure()
plot(t(find(t==0):find(t==4)),phi_dot1(find(t==0):find(t==4)))
grid on
title('Roll Subsidence Mode(Aileron Deflected)')
xlabel('Time(s)')
ylabel('$\dot{\phi}$ (deg/sec)','interpreter','latex')
figure()
plot(t,phi1)
grid on
xlabel('Time(s)')
ylabel('\phi(deg)')
title('Spiral mode(Aileron Deflected)')
figure()
plot(t,psi1)
grid on
xlabel('Time(s)')
ylabel('\psi(deg)')
title('Spiral mode(Aileron Deflected)')