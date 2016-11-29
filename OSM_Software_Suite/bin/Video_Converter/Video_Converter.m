%+------------------------------------------------------------------------+
%|                                                                        |
%| FILENAME : Video_Converter_m                           VERSION : 0.0.0 |
%|                                                                        |
%| TITLE : Video Conversion                       AUTHOR : Daniel Aldrich |
%|                                                                        |
%+------------------------------------------------------------------------+
%|                                                                        |
%| DEPENDENT FILES :                                                      |
%|       Video_Converter_fig                                              |
%|                                                                        |
%| DESCRIPTION :                                                          |
%|       <none>                                                           |
%|                                                                        |
%| PUBLIC FUNCTIONS :                                                     |
%|       <none>                                                           |
%|                                                                        |
%| NOTES :                                                                |
%|       <note>                                                           |
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
%|       <none>                                                           |
%|                                                                        |
%+------------------------------------------------------------------------+

function varargout = Video_Converter(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Video_Converter_OpeningFcn, ...
                   'gui_OutputFcn',  @Video_Converter_OutputFcn, ...
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

function Video_Converter_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

% Initialize Variables
handles.Format = 'tif';

% Generate Directory Locations
handles.cdProgram = cd();
cd(fullfile('..','..'))
handles.cdMain = cd();
handles.cdInput = fullfile(cd(),'Input','Videos');
cd(handles.cdProgram)

guidata(hObject, handles);

function varargout = Video_Converter_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function loadVideo_Callback(hObject, eventdata, handles)
handles = loadVideofile(handles);
set(handles.startConversion,'Enable','on')
guidata(hObject,handles)

function startConversion_Callback(hObject, eventdata, handles)
handles = saveLocation(handles);
handles = saveFolder(handles);
handles = saveImages(handles);
try
    delete(handles.hBar)
catch
end
cd(handles.cdProgram)

function Quit_Callback(hObject, eventdata, handles)
videoConverter_DeleteFcn(hObject, eventdata, handles)
cd(handles.cdMain)
run('OSM_Suite.m')

function panelFormating_SelectionChangedFcn(hObject, eventdata, handles)
handles.Format = get(hObject,'String');
guidata(hObject,handles)

function videoConverter_DeleteFcn(hObject, eventdata, handles)
delete(handles.videoConverter)
cd(handles.cdMain)

function [handles] = saveFolder(handles)
while true
    pause(0.5)
    OutputFolder = inputdlg('Input the desired folder title.',...
        'Folder Name',1);
    OutputFolder = fullfile(handles.cdOutput,OutputFolder{1});
    if exist(OutputFolder,'dir')==7
        breakCheck = overwriteCheck(OutputFolder);
        if breakCheck
            break
        end
    else
        mkdir(OutputFolder)
        cd(OutputFolder)
        break
    end
end
handles.OutputFolder = OutputFolder;

function [breakCheck] = overwriteCheck(OutputFolder)
while true
    overwrite = 2 - menu(...
        'Would You Like To OverWrite The File?','Yes','No');
    switch overwrite
        case 0
            breakCheck = false;
            break
        case 1
            rmdir(OutputFolder,'s')
            mkdir(OutputFolder)
            cd(OutputFolder)
            breakCheck = true;
            break
        case 2
            breakCheck = false;
    end
end

function [handles] = saveLocation(handles)
while true
    answer = menu('Choose Save File',...
        'Classic',...
        '2D',...
        'Field',...
        'Other');
    switch answer
        case 1
            % Save to Classic
            handles.cdOutput = ...
                fullfile(handles.cdMain,'Input','Classic');
            break
        case 2
            % Save to 2D
            handles.cdOutput = ...
                fullfile(handles.cdMain,'Input','2Dimensional');
            break
        case 3
            % Save to Field
            handles.cdOutput = ...
                fullfile(handles.cdMain,'Input','Correlation');
            break
        case 4
            % Save to Other
            handles.cdOutput = ...
                fullfile(handles.cdMain,'Input','Other');
            break
        case 0
            % Do Nothing
        otherwise
            % Unexpected Event Handling
    end
end

function [handles] = saveImages(handles)
handles.hBar = waitbar(0,sprintf('Saving Image 0 of %i',handles.nFrames));
for n = 1:handles.nFrames
    if ~ishandle(handles.hBar)
        handles.hBar = waitbar(n/handles.nFrames,...
            sprintf('Saving Image %i of %i',n,handles.nFrames));
    else
        waitbar(n/handles.nFrames,handles.hBar,...
            sprintf('Saving Image %i of %i',n,handles.nFrames));
    end
    Frames = readFrame(handles.Video);
    drawnow
    filenames = sprintf('Image%05i.%s',n,handles.Format);
    imwrite(Frames,fullfile(handles.OutputFolder,filenames),...
        handles.Format)
end

function [handles] = loadVideofile(handles)
while true
    pause(0.5)
    cd(handles.cdInput)
    temp = {'Random','Random'};
    [filename,filepath] = uigetfile({'*.avi;*.mpg;*.mp4;*.mov;*.wmv',...
        'Video files';'*.*',...
        'all files (*.*)'},...
        'SELECT VIDEO FILE');
    cd(handles.cdProgram)
    if filename ~= 0
        temp = strsplit(filename,'.');
        temp{2} = lower(temp{2});
    end
    switch lower(temp{2})
        case {'avi','mpg','mp4','mov','wmv','mj2'}
            cd(filepath)
            handles.Video = VideoReader(filename);
            handles.nFrames = handles.Video.NumberOfFrames;
            handles.Video = VideoReader(filename);
            cd(handles.cdProgram)
            break
        otherwise
            % Handles for unexpected returns
    end
end