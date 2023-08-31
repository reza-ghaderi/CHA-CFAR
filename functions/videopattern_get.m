function [img,roi] = videopattern_get(img)
numTargets = 1;

roi = [1160 188 139 119];

hf = figure('Color', get(0, 'defaultuicontrolbackgroundcolor'), ...
    'Name', 'Target pattern', ...
    'NumberTitle', 'off');
imshow(img);

h = imrect(gca, roi);
api = iptgetapi(h);
api.setColor([0 1 0]);
api.addNewPositionCallback(@(p) title(mat2str(p)));

% Don't allow the rectangle to be dragged outside of image boundaries
fcn = makeConstrainToRectFcn('imrect',get(gca,'XLim'),get(gca,'YLim'));
api.setDragConstraintFcn(fcn);

yshift = 10;
uicontrol(hf, 'style', 'text', 'Units', 'Pixels', ...
    'String', '', ...
    'Fontsize', 12, ...
    'Position', [80 yshift 150 20]);
hEditBox = uicontrol(hf, 'style', 'text', 'Units', 'Pixels', ...
    'String', '', ...
    'Fontsize', 12, ...
    'Position', [80 yshift 150 20]);
uicontrol(hf, 'style', 'pushbutton', 'Units', 'Pixels', ...
    'String', 'Submit', ...
    'Position', [340 yshift 100 20], ...
    'Callback', @submitFcn);
uiwait;

    function submitFcn(varargin)
        roi = api.getPosition();
        % Extract the template data
        numTargets = round(str2double(get(hEditBox, 'String')));
        if numTargets < 1
            warndlg('Number of targets must be greater than or equal to 1. Setting the number of targets to 1.', 'Invalid number of targets');
            numTargets = 1;
        end
        close(hf);
    end
end


