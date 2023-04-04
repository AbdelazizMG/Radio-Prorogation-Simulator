file = jsondecode(fileread("database.json"));
usernames = fieldnames(file).';

passwords = {}

for i = 1:length(usernames)
    
   passwords{i} = getfield(file,usernames{i});
end

for i = 1:length(usernames)
    
   struct1.(usernames{i}) = passwords(i);
end

