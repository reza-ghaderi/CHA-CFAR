function [Pfa,Pd]=WAI_CFAR(secondary_data,X_CUT_H1,X_CUT_H0,T,n)
g = secondary_data;
for i=1:size(secondary_data,2)-1
    g=sort(g,2);
    f = g(:,1);
    e = g(:,end);
    g(:,1)=[];
    g(:,end)=[];
    g =[g n.*f+(1-n).*e];
end
Pfa=sum(T*g<X_CUT_H0)./length(X_CUT_H0);
Pd=sum(T*g<X_CUT_H1)./length(X_CUT_H0);
end
