function [Pfa,Pd]=CA_CFAR(secondary_data,X_CUT_H1,X_CUT_H0,T)
g=sum(secondary_data,2);
Pfa=sum(T*g<X_CUT_H0)./length(X_CUT_H0);
Pd=sum(T*g<X_CUT_H1)./length(X_CUT_H0);
end
