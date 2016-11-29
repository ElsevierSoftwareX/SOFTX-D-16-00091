%+------------------------------------------------------------------------+
%|                                                                        |
%| FILENAME : OSM_Classic_m                               VERSION : 5.1.1 |
%|                                                                        |
%| TITLE : OSM Classic                            AUTHOR : Daniel Aldrich |
%|                                                                        |
%+------------------------------------------------------------------------+
%|                                                                        |
%| DEPENDENT FILES :                                                      |
%|       > OSM_Classic_fig                                                |
%|                                                                        |
%| DESCRIPTION :                                                          |
%|       This program is designed to determine strain on a specimen by the|
%|        use of edge detection. This program was created based on the    |
%|        concept of strain measurements presented by Stephan Frank in his|
%|        open source program (Optical Strain Measurement by Digital Image|
%|        Analysis).                                                      |
%|                                                                        |
%| PUBLIC FUNCTIONS :                                                     |
%|       <none>                                                           |
%|                                                                        |
%| NOTES :                                                                |
%|       <none>                                                           |
%|                                                                        |
%| COPYRIGHT :                                                            |
%|       Copyright (c) 2015 Daniel Aldrich                                |
%{
%|       Permission is hereby granted, free of charge, to any person      |
%|       obtaining a copy of this software and associated documentation   |
%|       files (the "Software"), to deal in the Software without          |
%|       restriction, including without limitation the rights to use,     |
%|       copy, modify, merge, publish, distribute, sublicense, and/or     |
%|       sell copies of the Software, and to permit persons to whom the   |
%|       Software is furnished to do so, subject to the following         |
%|       conditions:                                                      |
%|                                                                        |
%|       The above copyright notice and this permission notice shall be   |
%|       included in all copies or substantial portions of the Software.  |
%|                                                                        |
%|       THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,  |
%|       EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES  |
%|       OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND         |
%|       NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT      |
%|       HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,     |
%|       WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING     |
%|       FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR    |
%|       OTHER DEALINGS IN THE SOFTWARE.                                  |
%}
%|                                                                        |
%| CHANGES :                                                              |
%|       5.1.1 12/11/2015 DA Addition of Save and Quit Button             |
%|                                                                        |
%|       5.1.0 09/11/2015 DA Addition of Live Strain Display              |
%|                                                                        |
%+------------------------------------------------------------------------+
%#ok<*STRNU>
%#ok<*DEFNU>
%#ok<*AGROW>
function varargout = OSM_Classic(varargin)
% Last Modified by GUIDE v2.5 18-Nov-2015 10:33:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @OSM_Classic_OpeningFcn, ...
    'gui_OutputFcn',  @OSM_Classic_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

function OSM_Classic_OpeningFcn(hObject, ~, handles, varargin) 
handles.output = hObject;
handles.rotation = 0;
handles.cdProgram = cd();
cd(fullfile('..','..'))
handles.cdMain = cd();
handles.cdInput = fullfile(cd(),'Input','Classic');
handles.cdOutput = fullfile(cd(),'Output','Classic');
cd(handles.cdProgram)
draw.TB = -1;
draw.BB = -1;
draw.LB = -1;
draw.RB = -1;
draw.LB2 = -1;
draw.RB2 = -1;
draw.IL = -1;
draw.I = -1;
draw.Right = -1;
draw.Left = -1;
draw.Right2 = -1;
draw.Left2 = -1;
draw.curvefit = -1;
handles.draw = draw;
handles.canStart = 0;
handles.iLimit = 1;
guidata(hObject, handles);

function varargout = OSM_Classic_OutputFcn(~, ~, handles)
varargout{1} = handles.output;

%/////////////////////////////////CALLBACKS\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~IMAGE ADJUSTMENTS~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function rotateCCW_Callback(hObject, ~, handles) 
handles.rotation = mod(4+handles.rotation-1,4);
handles = loadImage(handles);
handles = setDefaults(handles);
guidata(hObject,handles)

function rotateCW_Callback(hObject, ~, handles)
handles.rotation = mod(4+handles.rotation+1,4);
handles = loadImage(handles);
handles = setDefaults(handles);
guidata(hObject,handles)

function toggleNegative_Callback(hObject, ~, handles)
switch get(handles.toggleNegative,'Value')
    case true
        set(handles.toggleNegative,'BackgroundColor',[0 0 0])
        set(handles.toggleNegative,'ForegroundColor',[1 1 1])
    case false
        set(handles.toggleNegative,'BackgroundColor',[1 1 1])
        set(handles.toggleNegative,'ForegroundColor',[0 0 0])
end
handles = loadImage(handles);
guidata(hObject,handles)

%~~~~~~~~~~~~~~~~~~~~~~~~~~~IMAGE ADJUSTMENTS END~~~~~~~~~~~~~~~~~~~~~~~~~~

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~BOUNDRIES~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function setLeft_Callback(hObject, ~, handles)
axes(handles.intensityGraph)
hold on
axes(handles.videoPreview)
hold on
while true
    Input = ginput(1);
    Input = round(Input(1));
    if Input<handles.boundries.Right && Input>=1
        handles.boundries.Left = Input;
        if ~ishandle(handles.draw.LB)
            handles.draw.LB = plot(handles.videoPreview,...
                [Input,Input],[1,handles.height],'y-');
            handles.draw.LB2 = plot(handles.intensityGraph,...
                [Input,Input],[0 1],'k--');
        else
            set(handles.draw.LB,'XData',[Input,Input])
            set(handles.draw.LB2,'XData',[Input,Input])
        end
        break
    end
end
handles = updateIntensity(handles);
guidata(hObject,handles)

function setBottom_Callback(hObject, ~, handles)
axes(handles.videoPreview)
hold on
while true
    Input = ginput(1);
    Input = round(Input(2));
    if Input>handles.boundries.Top && Input<=handles.height
        handles.boundries.Bottom = Input;
        if ~ishandle(handles.draw.BB)
            handles.draw.BB = plot([1,handles.width],[Input,Input],'y-');
        else
            set(handles.draw.BB,'YData',[Input,Input])
        end
        break
    end
end
handles = updateIntensity(handles);
guidata(hObject,handles)

function setRight_Callback(hObject, ~, handles)
axes(handles.intensityGraph)
hold on
axes(handles.videoPreview)
hold on
while true
    Input = ginput(1);
    Input = round(Input(1));
    if Input>handles.boundries.Left && Input<=handles.width
        handles.boundries.Right = Input;
        if ~ishandle(handles.draw.RB)
            handles.draw.RB = plot(handles.videoPreview,...
                [Input,Input],[1,handles.height],'y-');
            handles.draw.RB2 = plot(handles.intensityGraph,...
                [Input,Input],[0 1],'k--');
        else
            set(handles.draw.RB,'XData',[Input,Input])
            set(handles.draw.RB2,'XData',[Input,Input])
        end
        break
    end
end
handles = updateIntensity(handles);
guidata(hObject,handles)

function setTop_Callback(hObject, ~, handles)
axes(handles.videoPreview)
hold on
while true
    Input = ginput(1);
    Input = round(Input(2));
    if Input<handles.boundries.Bottom && Input>=1
        handles.boundries.Top = Input;
        if ~ishandle(handles.draw.TB)
            handles.draw.TB = plot([1,handles.width],[Input,Input],'y-');
        else
            set(handles.draw.TB,'YData',[Input,Input])
        end
        break
    end
end
handles = updateIntensity(handles);
guidata(hObject,handles)

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~BOUNDRIES END~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~GUESSES~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function guessLeft_Callback(hObject, ~, handles)
axes(handles.intensityGraph)
hold on
while true
    Input = ginput(1);
    Input = round(Input(1));
    if Input<handles.guesses.Right
        handles.guesses.Left = Input;
        break
    end
end
if ~ishandle(handles.draw.Left)
    handles.draw.Left = plot(handles.intensityGraph,...
        [Input Input],[0 1],'-k');
    handles.draw.Left2 = plot(handles.videoPreview,...
        [Input Input],[1 handles.height],'--r');
else
    set(handles.draw.Left,'XData',[Input,Input])
    set(handles.draw.Left2,'XData',[Input,Input])
end
guidata(hObject,handles)

function guessRight_Callback(hObject, ~, handles)
axes(handles.intensityGraph)
hold on
while true
    Input = ginput(1);
    Input = round(Input(1));
    if Input>handles.guesses.Left
        handles.guesses.Right = Input;
        break
    end
end
if ~ishandle(handles.draw.Right)
    handles.draw.Right = plot(handles.intensityGraph,...
        [Input Input],[0 1],'-k');
    handles.draw.Right2 = plot(handles.videoPreview,...
        [Input Input],[1 handles.height],'--r');
else
    set(handles.draw.Right,'XData',[Input,Input])
    set(handles.draw.Right2,'XData',[Input,Input])
end
guidata(hObject,handles)

function guessAuto_Callback(hObject, ~, handles)
Left = find(handles.intensities>...
    (max(handles.intensities)*0.8),1,'first');

Right = find(handles.intensities>...
    (max(handles.intensities)*0.8),1,'last');

axes(handles.intensityGraph)
hold on

if ~ishandle(handles.draw.Left)
    handles.draw.Left = plot(handles.intensityGraph,...
        [Left Left],[0 1],'-k');
    handles.draw.Left2 = plot(handles.videoPreview,...
        [Left Left],[1 handles.height],'--r');
else
    set(handles.draw.Left,'XData',[Left,Left])
    set(handles.draw.Left2,'XData',[Left,Left])
end
axes(handles.intensityGraph)
if ~ishandle(handles.draw.Right)
    handles.draw.Right = plot(handles.intensityGraph,...
        [Right Right],[0 1],'-k');
    handles.draw.Right2 = plot(handles.videoPreview,...
        [Right Right],[1 handles.height],'--r');
else
    set(handles.draw.Right,'XData',[Right,Right])
    set(handles.draw.Right2,'XData',[Right,Right])
end

handles.guesses.Left = Left;
handles.guesses.Right = Right;

guidata(hObject,handles)

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~GUESSES END~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function loadImages_Callback(hObject, ~, handles)
handles = getImageList(handles);
handles = loadImage(handles);
handles = setDefaults(handles);
set(handles.panelControls1,'Visible','on')
guidata(hObject,handles)

function movingLeft_Callback(~, ~, ~)

function movingRight_Callback(~, ~, ~)

%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\CALLBACKS END//////////////////////////////


%////////////////////////////////NAVIGATION\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

function Quit_Callback(hObject, eventdata, handles)
osmClassic_DeleteFcn(hObject, eventdata, handles)
cd(handles.cdMain)
run('OSM_Suite.m')

function startButton_Callback(hObject, eventdata, handles)
set(handles.panelControls3,'Visible','off')
set(handles.percentComplete,'Visible','on')
set(handles.saveQuit,'Visible','on')

handles.boundries.LeftO = handles.boundries.Left;
handles.boundries.RightO = handles.boundries.Right;
handles.strainRate = plot(handles.strainVsTime,0,0);
xlabel(handles.strainVsTime,'Image #')
ylabel(handles.strainVsTime,'Stain Percent')

numberOfImages = length(handles.imageList);

xtest = 1:handles.width;
MarkerPosition = ones(numberOfImages,2);
options = optimset('Display','off');

lowerBound = ones(1,6).*-inf;
upperBound = ones(1,6).*inf;
set(handles.currentStrain,'Visible','on')
set(handles.strainVsTime,'Visible','on')
set(handles.strainVsTime,'FontUnits','Normalized','FontSize',0.06)
for n = 1:numberOfImages
    if get(handles.saveQuit,'Value')
        break
    end
    handles = getImage(handles,n);
    handles = updateIntensity(handles);
    
    
    ydata = handles.intensities(...
        handles.boundries.Left:handles.boundries.Right);
    xdata = handles.boundries.Left:handles.boundries.Right;
    if n == 1
        curvefitGuess = [handles.guesses.Left, handles.guesses.Right,...
            1,1,max(ydata)/2,min(ydata)/2];
    end
    
    Exitflag = 0;
    j = 0;
    
    while Exitflag == 0
        j = j + 1;
        [FittedData, ~, ~, Exitflag] = lsqcurvefit(...
            @(FittedData, xdata)  (FittedData(5)-FittedData(6))*...
            (erf(FittedData(3)*(xdata-FittedData(1)))-erf(FittedData(4)...
            *(xdata-FittedData(2))))+ 2*FittedData(6), curvefitGuess,...
            xdata, ydata,lowerBound,upperBound,options);
        
        curvefitGuess = FittedData;
        
        if j == 25
            Exitflag = 1;
        end
    end
    
    ytest = (FittedData(5)-FittedData(6))*(erf(FittedData(3)*...
        (xtest-FittedData(1)))-erf(FittedData(4)*...
        (xtest-FittedData(2))))+2*FittedData(6);
    
    
    handles.guesses.Left = FittedData(1);
    handles.guesses.Right = FittedData(2);
    
    if ~ishandle(handles.draw.curvefit)
        handles.draw.curvefit = plot(handles.intensityGraph,...
            xtest, ytest,'b-','LineWidth',1.5);
    else
        set(handles.draw.curvefit,'YData',ytest)
    end
    
    MarkerPosition(n,1:2) = [FittedData(1), FittedData(2)];
    
    set(handles.draw.Left,'XData',[1 1]*handles.guesses.Left)
    set(handles.draw.Right,'XData',[1 1]*handles.guesses.Right)
    set(handles.draw.Left2,'XData',[1 1]*handles.guesses.Left)
    set(handles.draw.Right2,'XData',[1 1]*handles.guesses.Right)
    
    if n>1
        if ~mod(n,6)
            strain = ...
                100*(abs(MarkerPosition(n,2)-MarkerPosition(n,1))/L-1);
            set(handles.currentStrain,'String',['Strain: ',...
                num2str(strain,4),'%'])
            set(handles.strainRate,...
                'XData',0:length(get(handles.strainRate,'YData')),...
                'YData',[get(handles.strainRate,'YData'),strain])
        end
        if get(handles.movingLeft,'Value')
            if handles.boundries.Left > 1
                handles.boundries.Left = floor(handles.boundries.LeftO...
                    +(MarkerPosition(n,1)-MarkerPosition(1,1)));
                if handles.boundries.Left < 1
                    handles.boundries.Left = 1;
                end
            end
            set(handles.draw.LB,'XData',[1 1]*handles.boundries.Left)
            set(handles.draw.LB2,'XData',[1 1]*handles.boundries.Left)
        end
        if get(handles.movingRight,'Value')
            if handles.boundries.Right < handles.width
                handles.boundries.Right = ceil(handles.boundries.RightO...
                    +(MarkerPosition(n,2)-MarkerPosition(1,2)));
                
                if handles.boundries.Right > handles.width
                    handles.boundries.Right = handles.width;
                end
            end
            set(handles.draw.RB,'XData',[1 1]*handles.boundries.Right)
            set(handles.draw.RB2,'XData',[1 1]*handles.boundries.Right)
        end
    else
        L = MarkerPosition(1,2) - MarkerPosition(1,1);
    end
    if ~mod(n,3)
        percent = round(n / numberOfImages * 100); %percent completed
        set(handles.percentComplete,'String',['Percent Complete: ',...
            num2str(percent),'%'])
        drawnow
    end

end
MarkerDistance = abs(MarkerPosition(:,2) - MarkerPosition(:,1)); 
handles.OutData(:, 1) = 1:numberOfImages;
handles.OutData(:, 2) = MarkerPosition(:,1);
handles.OutData(:, 3) = MarkerPosition(:,2);
handles.OutData(:, 4) = MarkerDistance;
handles.OutData(:, 5) = MarkerDistance(:,1)/MarkerDistance(1,1)-1;
if n<numberOfImages
    handles.OutData(n-1:end, 5) = 0;
end

handles = saveData(handles);

uiwait(handles.Plot)
Quit_Callback(hObject, eventdata, handles)

function stepOne_Callback(hObject, ~, handles)
set(handles.imagePreview,'Visible','on')
set(handles.panelControls1,'Visible','on')
set(handles.loadImages,'Visible','on')

set(handles.videoPreview,'Visible','off')
set(handles.intensityGraph,'Visible','off')
set(handles.panelControls2,'Visible','off')

cla(handles.videoPreview)
cla(handles.intensityGraph)

handles = loadImage(handles);
guidata(hObject,handles)

function stepTwo_Callback(hObject, ~, handles)
set(handles.imagePreview,'Visible','off')
set(handles.panelControls1,'Visible','off')
set(handles.loadImages,'Visible','off')

set(handles.videoPreview,'Visible','on')
set(handles.intensityGraph,'Visible','on')
set(handles.panelControls2,'Visible','on')

handles = loadFrame(handles);
handles = updateIntensity(handles);
cla(handles.imagePreview)
guidata(hObject,handles)

function stepTwob_Callback(~, ~, handles)
set(handles.panelControls3,'Visible','off')

set(handles.panelControls2,'Visible','on')

function stepThree_Callback(~, ~, handles)
set(handles.panelControls2,'Visible','off')

set(handles.panelControls3,'Visible','on')

%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\NAVIGATION END//////////////////////////////


%/////////////////////////////////FUNCTIONS\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

function [handles] = getImage(handles,n)
fileString = fullfile(handles.cdFiles,handles.imageList{n});
try
    imageData = rgb2gray(rot90(imread(fileString),-handles.rotation));
    imageData = mat2gray(imageData);
catch
    imageData = mat2gray(rot90(imread(fileString),-handles.rotation));
end
if get(handles.toggleNegative,'Value')
    imageData = 1 - imageData;
end
set(handles.image,'CData',imageData)
handles.currentImage = imageData;

function [handles] = getImage2(handles,n)
fileString = fullfile(handles.cdFiles,handles.imageList{n});
try
    imageData = rgb2gray(rot90(imread(fileString),-handles.rotation));
    imageData = mat2gray(imageData);
catch
    imageData = mat2gray(rot90(imread(fileString),-handles.rotation));
end
if get(handles.toggleNegative,'Value')
    imageData = 1 - imageData;
end
handles.currentImage = imageData;

function [handles] = getImageList(handles)
cd(handles.cdInput)
while true
    temp = {'Random','Random'};
    [filename,filepath] = uigetfile({...
        '*.jpg;*.png;*.jpeg;*.JPG;*.bmp;*.BMP;*.tif;*.tiff',...
        'Image Files';'*.zip','Zip Files (*.zip)';...
        '*.*','All Files (*.*)'},...
        'SELECT IMAGE FILE');
    if filename ~= 0
        temp = strsplit(filename,'.');
    end
    if strcmp(temp{2},'zip')
        cd(filepath)
        unzip(filename);
        cd(handles.cdProgram)
        handles.cdFiles = filepath;
        handles.cdFolder = filename;
        break
    elseif ~filename
        cd(handles.cdProgram)
        return
    else
        handles.cdFiles = filepath;
        handles.cdFolder = filename;
        break
    end
end
cd(handles.cdFiles)
list = dir;
cd(handles.cdProgram)
c = 0;
imageList = {};
for n = 3:length(list)
    Filename = strsplit(list(n).name,'.');
    switch lower(Filename{2})
        case {'jpg','jpeg','png','bmp','tif','tiff','gif'}
            c=c+1;
            imageList{c} = list(n).name; 
        otherwise
            %do nothing
    end
end

[y,x] = size(imread(fullfile(handles.cdFiles,imageList{1})));
handles.imageSize.width = x;
handles.imageSize.height = y;

handles.imageList = imageList;

function [handles] = loadFrame(handles)
fileString = fullfile(handles.cdFiles,handles.imageList{1});
try
    imageData = rgb2gray(rot90(imread(fileString),-handles.rotation));
    imageData = mat2gray(imageData);
catch
    imageData = mat2gray(rot90(imread(fileString),-handles.rotation));
end
axes(handles.videoPreview)
if get(handles.toggleNegative,'Value')
    imageData = 1 - imageData;
end
handles.image = imagesc(imageData);
handles.currentImage = imageData;
[handles.height,handles.width] = size(imageData);
axis ij
axis equal
colormap('gray')

function [handles] = loadImage(handles)
fileString = fullfile(handles.cdFiles,handles.imageList{1});
try
    imageData = rgb2gray(rot90(imread(fileString),-handles.rotation));
    imageData = mat2gray(imageData);
catch
    imageData = mat2gray(rot90(imread(fileString),-handles.rotation));
end
axes(handles.imagePreview)
if get(handles.toggleNegative,'Value')
    imageData = 1 - imageData;
end
imagesc(imageData)
handles.currentImage = imageData;
axis ij
axis equal
colormap('gray')

function [handles] = setDefaults(handles)
boundries.Left = 1;
boundries.Right = size(handles.currentImage,2);
boundries.Top = 1;
boundries.Bottom = size(handles.currentImage,1);
guesses.Right = size(handles.currentImage,2);
guesses.Left = 1;
handles.guesses = guesses;
handles.boundries = boundries;

function [handles] = updateIntensity(handles)
handles.intensities = sum(handles.currentImage(...
    handles.boundries.Top:handles.boundries.Bottom,:),1)/...
    (handles.boundries.Bottom-handles.boundries.Top-1);
handles.intensities([1:handles.boundries.Left,...
    handles.boundries.Right:end]) = 0;

handles.intensities(handles.intensities>handles.iLimit) = handles.iLimit;

if ~ishandle(handles.draw.I)
    handles.draw.I = plot(handles.intensityGraph,...
        1:handles.width,handles.intensities,...
        'r-','LineWidth',2);
else
    set(handles.draw.I,'YData',handles.intensities)
end
set(handles.intensityGraph,'YLim',[0 1])
set(handles.intensityGraph,'XLim',get(handles.videoPreview,'XLim'))

function [handles] = updateIntensity2(handles)
handles.intensities = sum(handles.currentImage(...
    handles.boundries.Top:handles.boundries.Bottom,:),1)/...
    (handles.boundries.Bottom-handles.boundries.Top-1);
handles.intensities([1:handles.boundries.Left,...
    handles.boundries.Right:end]) = 0;

handles.intensities(handles.intensities>handles.iLimit) = handles.iLimit;

function [handles] = saveData(handles)
cd(handles.cdOutput)
break2 = false;
while true
    pause(0.5)
    FolderOutput = inputdlg(...
        'Input the desired folder title.','Folder Name',1);
    if exist([FolderOutput{1}],'dir')==7
        while true
            overwrite = 2 - menu(...
                'Would You Like To OverWrite The File?','Yes','No');
            switch overwrite
                case 0
                    break
                case 1
                    rmdir(FolderOutput{1},'s')
                    mkdir(FolderOutput{1})
                    cd(FolderOutput{1})
                    break2 = true;
                    break
                case 2
                    %Do nothing It Will loop back and comfirm the overwrite
            end
        end
        if break2
            break
        end
    else
        mkdir(FolderOutput{1})
        cd(FolderOutput{1})
        break
    end
end
FilePath = fullfile(handles.cdOutput,FolderOutput{1});
cd(FilePath)
Data.ImageNumber = handles.OutData(:,1);
Data.LeftPosition = handles.OutData(:,2);
Data.RightPosition = handles.OutData(:,3);
Data.Distance = handles.OutData(:,4);
Data.Strain = handles.OutData(:,5); 
% Save Raw Data (Variable)
save(fullfile(FilePath,'Data.mat'),'-struct','Data')

% Save Raw Data (Data File)
fid=fopen(fullfile(FilePath,'StrainMeasurement.dat'),'w');
fprintf(fid,'Raw Data\n\n');
fprintf(fid,'%s\t%s\t%s\t%s\t%s\n\n',...
    'Image', 'Left(Pxl)', 'Right(Pxl)', 'Length(Pxls)', 'Strain');

for i=1:size(handles.OutData(:,1),1)
    fprintf(fid,'%i\t%g\t%g\t%g\t%.6f\n', handles.OutData(i,1),...
        handles.OutData(i,2),handles.OutData(i,3),handles.OutData(i,4),...
        handles.OutData(i,5));
end
fclose(fid);

% Save Strain Data
fid=fopen(fullfile(FilePath,'Strain.dat'),'w');
fprintf(fid, 'Strain Values\n');
fprintf(fid,'%s\t %s\n', 'Image', 'Strain');
for i=1:size(handles.OutData(:,1),1)
    fprintf(fid,'%i\t %.6f\n',handles.OutData(i,1),handles.OutData(i,5));
end
fclose(fid);

% Plot Strain vs Image Number
PlotHandle = figure;
plot(handles.OutData(:,1), handles.OutData(:,5), 'ko');
ylabel('Strain')
xlabel('Image no.')
set(gca, 'Box', 'on')

% Save Plot (Figure)
saveas(PlotHandle, fullfile(FilePath, 'Strain.fig'))

% Save Plot (*.PNG)
print(PlotHandle, fullfile(FilePath, 'Strain.png'),'-dpng')
handles.Plot = PlotHandle;
cd(handles.cdProgram)

%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\FUNCTIONS END//////////////////////////////

function osmClassic_DeleteFcn(~, ~, handles)
delete(handles.osmClassic)
cd(handles.cdMain)

function intensityLimit_Callback(hObject, ~, handles)
axes(handles.intensityGraph)
hold on

Input = ginput(1);
Input = Input(2);

if ~ishandle(handles.draw.IL)
    handles.draw.IL = plot(handles.intensityGraph,...
        [1 handles.width],[Input Input],'--g');
else
    set(handles.draw.IL,'YData',[Input,Input])
end

handles.iLimit = Input;
[handles] = updateIntensity(handles);
guidata(hObject,handles)

function saveQuit_Callback(~, ~, ~)

function fastButton_Callback(hObject, eventdata, handles)
set(handles.panelControls3,'Visible','off')
set(handles.videoPreview,'Visible','off')
set(handles.intensityGraph,'Visible','off')
set(handles.percentComplete,'Visible','on')
set(handles.saveQuit,'Visible','on')

handles.boundries.LeftO = handles.boundries.Left;
handles.boundries.RightO = handles.boundries.Right;

numberOfImages = length(handles.imageList);

MarkerPosition = ones(numberOfImages,2);
options = optimset('Display','off');

lowerBound = ones(1,6).*-inf;
upperBound = ones(1,6).*inf;
set(handles.currentStrain,'Visible','on')
for n = 1:numberOfImages
    if get(handles.saveQuit,'Value')
        break
    end
    handles = getImage2(handles,n);
    handles = updateIntensity2(handles);
    
    
    ydata = handles.intensities(...
        handles.boundries.Left:handles.boundries.Right);
    xdata = handles.boundries.Left:handles.boundries.Right;
    if n == 1
        curvefitGuess = [handles.guesses.Left, handles.guesses.Right,...
            1,1,max(ydata)/2,min(ydata)/2];
    end
    
    Exitflag = 0;
    j = 0;
    
    while Exitflag == 0
        j = j + 1;
        [FittedData, ~, ~, Exitflag] = lsqcurvefit(...
            @(FittedData, xdata)  (FittedData(5)-FittedData(6))*...
            (erf(FittedData(3)*(xdata-FittedData(1)))-erf(FittedData(4)...
            *(xdata-FittedData(2))))+ 2*FittedData(6), curvefitGuess,...
            xdata, ydata,lowerBound,upperBound,options);
        
        curvefitGuess = FittedData;
        
        if j == 25
            Exitflag = 1;
        end
    end
    
    handles.guesses.Left = FittedData(1);
    handles.guesses.Right = FittedData(2);
    
    MarkerPosition(n,1:2) = [FittedData(1), FittedData(2)];
    
    if n>1
        strain=100*(abs((MarkerPosition(n,2) - MarkerPosition(n,1))-L)/L);
        set(handles.currentStrain,'String',['Strain: ',...
            num2str(strain,3),'%'])
        if get(handles.movingLeft,'Value')
            if handles.boundries.Left > 1
                handles.boundries.Left = floor(handles.boundries.LeftO...
                    +(MarkerPosition(n,1)-MarkerPosition(1,1)));
                if handles.boundries.Left < 1
                    handles.boundries.Left = 1;
                end
            end
        end
        if get(handles.movingRight,'Value')
            if handles.boundries.Right < handles.width
                handles.boundries.Right = ceil(handles.boundries.RightO...
                    +(MarkerPosition(n,2)-MarkerPosition(1,2)));
                
                if handles.boundries.Right > handles.width
                    handles.boundries.Right = handles.width;
                end
            end
        end
    else
        L = MarkerPosition(1,2) - MarkerPosition(1,1);
    end
    
    percent = round(n / numberOfImages * 100); %percent completed
    set(handles.percentComplete,'String',['Percent Complete: ',...
        num2str(percent),'%'])
    
    drawnow
end
MarkerDistance = MarkerPosition(:,2) - MarkerPosition(:,1); 
handles.OutData(:, 1) = 1:numberOfImages;
handles.OutData(:, 2) = MarkerPosition(:,1);
handles.OutData(:, 3) = MarkerPosition(:,2);
handles.OutData(:, 4) = MarkerDistance;
handles.OutData(:, 5) = abs(MarkerDistance(:,1)/MarkerDistance(1,1)-1);
if n<numberOfImages
    handles.OutData(n-1:end, 5) = 0;
end

handles = saveData(handles);

uiwait(handles.Plot)
Quit_Callback(hObject, eventdata, handles)
