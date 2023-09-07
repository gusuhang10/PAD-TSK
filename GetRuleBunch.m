function [RuleBunch,RuleList]=GetRuleBunch(xc,RuleNum,HI) 
    RuleList=[];
    for i=1:RuleNum 
        [~,RuleList]=ChooseRules(HI,xc,RuleList);
    end
    RuleBunch=RuleList(end-RuleNum+1:end,:)/HI; 
end

function [OneRule,RuleList]=ChooseRules(HI,D,RuleList) 
    OneRuleX=zeros(1,D); 
    while true 
        for i=1:D
            OneRuleX(i)=randperm(HI+1,1)-1; 
        end
        Repeated=HasBeenChoosed(OneRuleX,RuleList);
        if Repeated==false 
            RuleList=[RuleList;OneRuleX]; 
            break;
        end
    end
    
    OneRule=OneRuleX/HI;
    clear OneRuleX
end

function [exist]=HasBeenChoosed(OneRule,RuleList)
    exist=false; 
    if isempty(RuleList) 
        return; 
    end
    [rr,rc]=size(RuleList); 
    for i=1:rr 
        if length(OneRule(OneRule==RuleList(i,:)))==rc 
            exist=true;
            break;
        end
    end
end