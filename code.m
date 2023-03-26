clc
clear
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Steps %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1- Pr(do) at free space
% 2- PL(do) = Pt (input) / Pr
% 3- Get Mean = PL(d0) + 10nlog(d/do)
% 4- PL(d) = Mean + (X_sigma = Sigma_Squared)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constants ( Except Loses )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Pt = 50;                                %input
Gt = 2;                                 %input
Gr = 1;                                 %input
F  = 900 * 10 ^ 6;                      %input
d  = [200,500,1000,1500,2000];          %in meters             
do = 100;                               %Assumption
n  = [2,4,5];                           %input                   
sigma = 2;                              %input
x_sigma = sigma .* randn(50,1);       %calculated
n_estimated = 0;
n_estimated_array = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               OUTPUT 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Pr_do_decimal = Pt * Gt * Gr * ( (300000000 / F ) / (4 * pi * do ) ) ^ 2;

Pr_do_dB = 10*log10(Pr_do_decimal);

Pr_do_dBm = Pr_do_dB + 30 ;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PL_do_decimal = Pt / Pr_do_decimal ;

PL_do_dB = 10*log10(PL_do_decimal);

PL_do_dBm = PL_do_dB + 30 ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sum2 = 0 ;
syms n_estimated;
syms variance;

for n_counter = 1 : 1 : length(n)
    
    sum2 = 0 ;
    
    for d_counter = 1 : 1 : length(d)
        
        Mean = PL_do_decimal + 10 * n(n_counter) * log10(d(d_counter)/do);    
        
        PL_d_decimal(d_counter,:) = Mean + x_sigma;
        PL_d_dB(d_counter,:) = 10*log10(PL_d_decimal(d_counter,:));
        PL_d_dBm(d_counter,:) = PL_d_dB(d_counter,:) + 30;
        
                      
    end
    
     PL_Model(d_counter) = PL_do_decimal + 10 * n_estimated * log10(d(d_counter)/do);    
               
     sum2 = sum2 + ( PL_d_decimal(d_counter,:) - PL_Model(d_counter) ) .^ 2;
        
     exp = sum(sum2); 
     tt =  diff(exp/250);
     n_estimated2 = double(solve(tt==0,n_estimated));
     n_estimated_array(n_counter) = n_estimated2;
     sigma_estimated = double(solve(exp , n_estimated2))     
     
     figure
     
     scatter(d,PL_d_decimal);
     xlabel('distance (d)');
     ylabel('path loss (PL)');
     title(sprintf("Scatter Plot for n = %d" , n(n_counter))); 
     
    for d_counter = 1 : 1 : length(d)
      
      model(n_counter,d_counter) = PL_do_decimal + 10 *  n_estimated_array(n_counter) * log10(d(d_counter)/do); 
      
    end     
     figure

     plot(d,model(n_counter,:));
     hold on
     scatter(d,PL_d_decimal);
     xlabel('distance (d)');
     ylabel('path loss (PL)');
     title(sprintf("Scatter Plot for n = %d" , n(n_counter))); 
     hold off
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               OUTPUT2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


