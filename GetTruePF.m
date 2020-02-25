function true_pf = GetTruePF(func_name)

    load TruePF.mat ZDT_PF DTLZ_PF
    
    index = str2double(func_name(end));
    if contains(func_name, 'zdt')
        true_pf = ZDT_PF{index};
    else
        true_pf = DTLZ_PF{index};
    end
   
end