clc;clearvars;close all

% ---------------------------------------------------------
% ------------------  Load Image --------------------------
% ---------------------------------------------------------
p = '/RealData/';
addpath('functions/');
RootPath =  [pwd,p];
NameI = 'i_VV.img';
NameQ = 'q_VV.img';
imageSize = [3351 1772];
Path_I = [RootPath,NameI];
Path_Q = [RootPath,NameQ];
ImHeight = imageSize(2);
ImWidth = imageSize(1);
FidI_ = fopen(Path_I,'rb');
xImst_= fread(FidI_,ImHeight*ImWidth,'int16','b');
fclose(FidI_);
FidQ_ = fopen(Path_Q,'rb');
xQmst_ = fread(FidQ_,ImHeight*ImWidth,'int16','b');
fclose(FidQ_);
xmst_I = xImst_.*xImst_+xQmst_.*xQmst_;
xmst_I = reshape(xmst_I,ImWidth,ImHeight).';
[~,roi] = videopattern_get(xmst_I./100000);
img = imcrop(xmst_I,roi);

% ---------------------------------------------------------
% ------------------  Parameteres -------------------------
% ---------------------------------------------------------
% Size of sliding window
w = 33 ;Guard = 7;
if(Guard==0)
    window_size = (w.^2)-1;
else
    window_size = (w.^2)-(Guard.^2);
end
% Probability of false alarm
pfa=0.001;

% ---------------------------------------------------------
% ------------------ CFAR Parameteres ---------------------
% ---------------------------------------------------------
T_CA=(pfa.^(-1/window_size))-1;                     % CA-CFAR
Th_Os=5; k_Os = window_size*0.75;                   % OS-CFAR
T_CHA= 33550; k_CHA=8;                              % CHA-CFAR
Th_TM=0.0165; k1_TM= 1; k2_TM = window_size*0.75;   % TM-CFAR
% ---------------------------------------------------------
i2 = 0;
for i1=(((w-1)/2)+1):size(img,1)-(((w-1)/2))
    i2 =i2+1;
    j2 = 0;
    for j1=(((w-1)/2)+1):size(img,2)-(((w-1)/2))
        j2=j2+1;
        secondary_data = double(img(i1-((w-1)/2):i1+((w-1)/2),j1-((w-1)/2):j1+((w-1)/2)));
        secondary_data((((w-1)/2)+1-((Guard-1)/2)):(((w-1)/2)+1+((Guard-1)/2)),(((w-1)/2)+1-((Guard-1)/2)):(((w-1)/2)+1+((Guard-1)/2)))=NaN;
        secondary_data = secondary_data(:)';
        secondary_data(isnan(secondary_data))=[]; % Remove Gaurd Pixels
        X_CUT = double(img(i1,j1));                 
        [~,Pd_CA(i2,j2)]=CA_CFAR(secondary_data,X_CUT,X_CUT,T_CA);
        [~,Pd_OS(i2,j2)]=OS_CFAR(secondary_data,X_CUT,X_CUT,Th_Os,k_Os);
        [~,Pd_CHA(i2,j2)]=CHA_CFAR(secondary_data,X_CUT,X_CUT,T_CHA,k_CHA);
        [~,Pd_TM(i2,j2)]=TM_CFAR(secondary_data,X_CUT,X_CUT,Th_TM,k1_TM,k2_TM);
    end
end

A = 10*log10(img);

figure1 = figure;
colormap(gray);
set(figure1, 'Position', [0 200 1400 300])
subplot(1,5,1)
image(A((((w-1)/2)+1):size(img,1)-(((w-1)/2)),(((w-1)/2)+1):size(img,2)-(((w-1)/2))),'CDataMapping','scaled');
ylabel('Azimuth','Interpreter','latex');
xlabel({'Range',''},'Interpreter','latex');
title('Orginal Image')
subplot(1,5,2)
image(Pd_CA,'CDataMapping','scaled')
ylabel('Azimuth','Interpreter','latex');
xlabel({'Range',''},'Interpreter','latex');
title('CA-CFAR')
subplot(1,5,3)
image(Pd_OS,'CDataMapping','scaled')
ylabel('Azimuth','Interpreter','latex');
xlabel({'Range',''},'Interpreter','latex');
title('OS-CFAR')
subplot(1,5,4)
image(Pd_CHA,'CDataMapping','scaled')
ylabel('Azimuth','Interpreter','latex');
xlabel({'Range',''},'Interpreter','latex');
title('CHA-CFAR')
subplot(1,5,5)
image(Pd_TM,'CDataMapping','scaled')
ylabel('Azimuth','Interpreter','latex');
xlabel({'Range',''},'Interpreter','latex');
title('TM-CFAR')



