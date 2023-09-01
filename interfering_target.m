clc;clearvars;close all
addpath('functions/');

% ---------------------------------------------------------
% ------------------  Parameters -------------------------
% ---------------------------------------------------------
iteration = 1000000;                 % Number of iterations
Number_Intefering_target= 15;        % Number of Intefering target
landa = 1;                           % Mean of exponential distribution
pfa=0.001;                           % Probability of false alarm
window_size = 32;                    % Size of sliding window
SNR_dB = -5:2:40;                    % SNR range in decible

% ---------------------------------------------------------
% ------------------ CFAR Parameters ---------------------
% ---------------------------------------------------------
T_CA=(pfa.^(-1/window_size))-1;                     % CA-CFAR
Th_Os=4.12; k_Os = window_size*7/8;                 % OS-CFAR
T_CHA= 283; k_CHA=8;                                % CHA-CFAR
Th_TM=0.395; k1_TM= 3; k2_TM = window_size*7/8;     % TM-CFAR
T_WAI = 19.75; n_WAI = 0.9;                         % WAI-CFAR
% ---------------------------------------------------------

SNR = 10.^(0.1.*SNR_dB);
L = length(SNR);
% Preallocating variables
[Pfa_CA, Pd_CA, Pfa_OS ,Pd_OS, ...   
    Pfa_CHA, Pd_CHA, Pfa_TM, Pd_TM, ...
    Pfa_WAI,Pd_WAI, idel_pfa,ideal_pd] = deal(zeros(L,1));

for i=1:L
    disp(strcat('SNR (dB) = ',num2str(SNR_dB(i)) ))
    secondary_data = ([exprnd(landa,[iteration,window_size-Number_Intefering_target]) exprnd(landa*(1+SNR(i)),[iteration,Number_Intefering_target]) ]);
    secondary_data = secondary_data(:,randperm(window_size));
    X_CUT_H1=(exprnd(landa*(1+SNR(i)),[iteration,1]));
    X_CUT_H0=exprnd(landa,[iteration,1]);
    [Pfa_CA(i,1),Pd_CA(i,1)]=CA_CFAR(secondary_data,X_CUT_H1,X_CUT_H0,T_CA);
    [Pfa_OS(i,1),Pd_OS(i,1)]=OS_CFAR(secondary_data,X_CUT_H1,X_CUT_H0,Th_Os,k_Os);
    [Pfa_CHA(i,1),Pd_CHA(i,1)]=CHA_CFAR(secondary_data,X_CUT_H1,X_CUT_H0,T_CHA,k_CHA);
    [Pfa_TM(i,1),Pd_TM(i,1)]=TM_CFAR(secondary_data,X_CUT_H1,X_CUT_H0,Th_TM,k1_TM,k2_TM);
    [Pfa_WAI(i,1),Pd_WAI(i,1)]=WAI_CFAR(secondary_data,X_CUT_H1,X_CUT_H0,T_WAI,n_WAI);

    % If the number of interfering targets is not zero calculate ideal bound
    if(Number_Intefering_target)
        secondary_data = exprnd(landa,[iteration,window_size]);
        X_CUT_H1=exprnd(landa*(1+SNR(i)),[iteration,1]);
        X_CUT_H0=exprnd(landa,[iteration,1]);
        [idel_pfa(i,1),ideal_pd(i,1)]=CA_CFAR(secondary_data,X_CUT_H1,X_CUT_H0,T_CA);
    end
end


% ---------------------------------------------------------
% ------------------ Plot results -------------------------
% ---------------------------------------------------------
X1 = SNR_dB;
if(~Number_Intefering_target)
    YMatrix_Pd = [Pd_CA Pd_OS Pd_CHA Pd_TM Pd_WAI ];
    YMatrix_Pfa = [Pfa_CA Pfa_OS Pfa_CHA Pfa_TM Pfa_WAI];
else
    YMatrix_Pd = [Pd_CA Pd_OS Pd_CHA Pd_TM Pd_WAI ideal_pd ];
    YMatrix_Pfa = [Pfa_CA Pfa_OS Pfa_CHA Pfa_TM Pfa_WAI idel_pfa];
end

fontSize = 28;
legendFontSize = 20;
markerSize =  16;
LineWidth = 3;

figure1 = figure;
set(figure1, 'Position', [0 0 800 730])
axes1 = axes('Parent',figure1);
hold(axes1,'on');
plot1 = plot(X1,YMatrix_Pd,'LineWidth',LineWidth,'Parent',axes1);
set(plot1(1),'DisplayName','CA - CFAR','MarkerSize',markerSize,'Marker','square','Color',[0 0.85 1]);
set(plot1(2),'DisplayName','OS - CFAR','MarkerSize',markerSize,'Marker','o','LineStyle','--','Color',[0 0.498039215803146 0]);
set(plot1(3),'DisplayName','CHA - CFAR','MarkerSize',markerSize,'Marker','diamond','Color',[0 0 0]);ylabel('Pd','Interpreter','latex');
set(plot1(4),'DisplayName','TM - CFAR','MarkerSize',markerSize,'Marker','+','Color',[1 0 0]);
set(plot1(5),'DisplayName','WAI - CFAR','MarkerSize',markerSize,'Marker','>','Color',[0 0.447058823529412 0.741176470588235]);
if(Number_Intefering_target)
    set(plot1(6),'DisplayName','Ideal','Marker','pentagram','Color',[0.749019622802734 0 0.749019622802734]);
end
xlabel('SCR (dB)','Interpreter','latex');
box(axes1,'on');
set(axes1,'FontSize',fontSize,'TickLabelInterpreter','latex','XGrid','on','YGrid','on');
hold on
xlim([-5 30])
% Create ylabel
ylabel('Pd','Interpreter','latex');
% Create xlabel
xlabel('SCR (dB)','Interpreter','latex');
box(axes1,'on');
% Set the remaining axes properties
set(axes1,'FontSize',fontSize,'TickLabelInterpreter','latex','XGrid','on','YGrid',...
    'on');
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.15053189768149 0.565882378247066 0.26712987293661 0.327050368357047],...
    'Interpreter','latex','FontSize',legendFontSize);

figure1 = figure;
set(figure1, 'Position', [600 0 800 730])
axes1 = axes('Parent',figure1);
hold(axes1,'on');
plot1 = plot(X1,YMatrix_Pfa,'LineWidth',LineWidth,'Parent',axes1);
set(plot1(1),'DisplayName','CA - CFAR','MarkerSize',markerSize,'Marker','square','Color',[0 0.85 1]);
set(plot1(2),'DisplayName','OS - CFAR','MarkerSize',markerSize,'Marker','o','LineStyle','--','Color',[0 0.498039215803146 0]);
set(plot1(3),'DisplayName','CHA - CFAR','MarkerSize',markerSize,'Marker','diamond','Color',[0 0 0]);ylabel('Pd','Interpreter','latex');
set(plot1(4),'DisplayName','TM - CFAR','MarkerSize',markerSize,'Marker','+','Color',[1 0 0]);
set(plot1(5),'DisplayName','WAI - CFAR','MarkerSize',markerSize,'Marker','>','Color',[0 0.447058823529412 0.741176470588235]);
if(Number_Intefering_target)
    set(plot1(6),'DisplayName','Ideal','Marker','pentagram','Color',[0.749019622802734 0 0.749019622802734]);
end
xlabel('SCR (dB)','Interpreter','latex');
box(axes1,'on');
set(axes1,'FontSize',fontSize,'TickLabelInterpreter','latex','XGrid','on','YGrid','on');
hold on
xlim([-5 30])
% Create ylabel
ylabel('Pfa','Interpreter','latex');
% Create xlabel
xlabel('SCR (dB)','Interpreter','latex');
box(axes1,'on');
% Set the remaining axes properties
set(axes1,'FontSize',fontSize,'TickLabelInterpreter','latex','XGrid','on','YGrid',...
    'on');
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.15053189768149 0.565882378247066 0.26712987293661 0.327050368357047],...
    'Interpreter','latex','FontSize',legendFontSize);
ylim([-2*pfa 3*pfa])
