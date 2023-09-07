function datatra_by_label_replacement=label_replacement_of_trainingset(datatra,label_replacement_percent)
datatra_temp=datatra;
datatra_size=size(datatra,1);
len_label_replacement_percent=round(datatra_size*label_replacement_percent);
label_kinds=unique(datatra(:,end));
label_replacement_percent_no_temp=randperm(datatra_size);
label_replacement_percent_no=label_replacement_percent_no_temp(1:len_label_replacement_percent);
for i=1:length(label_replacement_percent_no)    
    current_waiting_replacement_label=datatra_temp(label_replacement_percent_no(i),end);    
    i_i=1;
    for i_label_kinds=1:length(label_kinds)
        if current_waiting_replacement_label~=label_kinds(i_label_kinds)
            label_kinds_minus_one(i_i)=label_kinds(i_label_kinds);
            i_i=i_i+1;
        end
    end
    clear i_i
    choose_label_no=randi([1 length(label_kinds_minus_one)],1,1);
    datatra_temp(label_replacement_percent_no(i),end)=label_kinds_minus_one(choose_label_no);
end

datatra_by_label_replacement=datatra_temp;