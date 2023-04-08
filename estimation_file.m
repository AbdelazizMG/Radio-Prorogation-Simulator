function  [n_estimated_value,sigma_estimated_value,model] = estimation_file(PL_d,d,PL_do_decimal,do)

syms n_estimated;
sum2=0;
number_of_samples_per_distance = 1;

for d_counter = 1 : 1 : length(d)   
    PL_Model(:,d_counter) = PL_do_decimal + 10 * n_estimated * log10(d(d_counter)/do);
    sum2 =sum2 +   (PL_d(:,d_counter) - PL_Model(d_counter)) .^ 2;
end

exp = sum(sum2);
tt =  diff(exp/(number_of_samples_per_distance*length(d)));
n_estimated_value = double(solve(tt==0,n_estimated));

sigma_estimated_value = sqrt(double(subs(exp/(length(d)*number_of_samples_per_distance),n_estimated,n_estimated_value)));
for d_counter = 1 : 1 : length(d)
      model(d_counter) = PL_do_decimal + 10 *  n_estimated_value * log10(d(d_counter)/do);  
end
end
