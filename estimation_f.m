function  [n_estimated_value,sigma_estimated_value,PL_d_decimal] = estimation_f(sigma,d,PL_do_decimal,n,do,number_of_samples_per_distance)
syms n_estimated;
x_sigma = sigma .* randn(50,1);
sum2=0;
for d_counter = 1 : 1 : length(d)   
    Mean = PL_do_decimal + 10 * n * log10(d(d_counter)/do);
    PL_d_decimal(:,d_counter) = Mean + x_sigma;
    PL_d_dB(:,d_counter) = 10*log10(PL_d_decimal(:,d_counter));
    PL_d_dBm(:,d_counter) = PL_d_dB(:,d_counter) + 30;
    PL_Model(:,d_counter) = PL_do_decimal + 10 * n_estimated * log10(d(d_counter)/do);
    sum2 =sum2+   (PL_d_decimal(:,d_counter) - PL_Model(d_counter)) .^ 2;
end

exp = sum(sum2);
tt =  diff(exp/(number_of_samples_per_distance*length(d)));
n_estimated_value = double(solve(tt==0,n_estimated));
sigma_estimated_value = sqrt(double(subs(exp/(length(d)*number_of_samples_per_distance),n_estimated,n_estimated_value)));

end
