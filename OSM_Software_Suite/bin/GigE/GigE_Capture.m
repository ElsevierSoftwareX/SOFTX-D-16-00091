%+------------------------------------------------------------------------+
%|                                                                        |
%| FILENAME : GigE_Capture_m                              VERSION : A.0.0 |
%|                                                                        |
%| TITLE : GigE Camera Capture                    AUTHOR : Daniel Aldrich |
%|                                                                        |
%+------------------------------------------------------------------------+
%|                                                                        |
%| DEPENDENT FILES :                                                      |
%|       GigE_Capture_fig                                                 |
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

function varargout = GigE_Capture(varargin)
% Last Modified by GUIDE v2.5 30-Oct-2015 09:12:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GigE_Capture_OpeningFcn, ...
                   'gui_OutputFcn',  @GigE_Capture_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end
imaqreset
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

function GigE_Capture_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
handles.cdProgram = cd();
cd(fullfile('..','..'))
handles.cdMain = cd();
handles.cdOutput = fullfile(cd(),'Input','Videos');
cd(handles.cdProgram)

handles.cameraID = -1;
handles.hImage = -1;

handles.gigeInfo = imaqhwinfo('gige');
handles.deviceIDs = [];
List = '';
for i = 1:length(handles.gigeInfo.DeviceIDs)
    if i == 1
        List = char(handles.gigeInfo.DeviceInfo(i).DeviceName);
    else
        List = char(List,handles.gigeInfo.DeviceInfo(i).DeviceName);
    end
    handles.deviceIDs(i) = handles.gigeInfo.DeviceInfo(i).DeviceID;
    
    handles.deviceFormats{i} =...
        handles.gigeInfo.DeviceInfo(i).SupportedFormats;
    
    handles.deviceDefaultFormat = ...
        handles.gigeInfo.DeviceInfo(i).DefaultFormat;
end

if isempty(List)
    List = 'No Available Cameras';
end

set(handles.selectCamera,'String',List)

handles = setFormats(handles,'Clear');

guidata(hObject, handles);

function varargout = GigE_Capture_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;




function selectCamera_Callback(hObject, eventdata, handles)



function selectCamera_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function selectFormat_Callback(hObject, eventdata, handles)
index = get(hObject,'Value');
contents = cellstr(get(hObject,'String'));
switch get(handles.cameraID,'VideoFormat')
    case contents{index}
        
    otherwise
        delete(handles.cameraID)
        idValue = get(handles.selectCamera,'Value');
        handles.cameraID = imaq.VideoDevice('gige',...
            handles.deviceIDs(idValue),...
            contents{index});
end
handles = updatePreview(handles);
guidata(hObject,handles)


function selectFormat_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function updatePreview_Callback(hObject, eventdata, handles)
handles = updatePreview(handles);
guidata(hObject,handles)


function flirCorrection_Callback(hObject, eventdata, handles)

function checkbox2_Callback(hObject, eventdata, handles)

function edit6_Callback(hObject, eventdata, handles)

function edit6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit7_Callback(hObject, eventdata, handles)

function edit7_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit8_Callback(hObject, eventdata, handles)

function edit8_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit9_Callback(hObject, eventdata, handles)

function edit9_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit1_Callback(hObject, eventdata, handles)

function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit2_Callback(hObject, eventdata, handles)

function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit3_Callback(hObject, eventdata, handles)

function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit4_Callback(hObject, eventdata, handles)

function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit5_Callback(hObject, eventdata, handles)

function edit5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function checkbox3_Callback(hObject, eventdata, handles)

function connectionButton_Callback(hObject, eventdata, handles)
switch get(hObject,'String')
    case 'Connect'
        set(hObject,'String','Disconnect')
        set(hObject,'BackgroundColor',[1,0,0])
        
        idValue = get(handles.selectCamera,'Value');
        handles.cameraID = imaq.VideoDevice('gige',...
            handles.deviceIDs(idValue));
        
        set(handles.selectCamera,'Enable','off')
        set(handles.updatePreview,'Enable','on')
        set(handles.selectFormat,'Enable','on')
        handles = setFormats(handles);
        handles = updatePreview(handles);
    case 'Disconnect'
        set(hObject,'String','Connect')
        set(hObject,'BackgroundColor',[0,1,0])
        set(handles.selectCamera,'Enable','on')
        set(handles.updatePreview,'Enable','off')
        set(handles.selectFormat,'Enable','off')
        handles = setFormats(handles,'Clear');
        delete(handles.cameraID)
        handles.camera.ID = -1;
    otherwise
        set(hObject,'String','Connect')
        set(hObject,'BackgroundColor',[0,1,0])
        set(handles.selectCamera,'Enable','on')
        set(handles.updatePreview,'Enable','off')
        set(handles.selectFormat,'Enable','off')
        handles = setFormats(handles,'Clear');
        try
            delete(handles.cameraID)
        catch
        end
        handles.camera.ID = -1;
end
guidata(hObject,handles)

function [handles] = updatePreview(handles)
imageData = step(handles.cameraID);

if get(handles.flirCorrection,'Value')
    imageData = (imageData-0.75)/0.25;
    colormap(handles.videoPreview,'Jet')
else
    colormap(handles.videoPreview,'Gray')
end

if ~ishandle(handles.hImage)
    handles.hImage = imagesc(imageData);
    axis equal
else
    set(handles.hImage,'CData',imageData)
    axis equal
end
drawnow

function [handles] = setFormats(handles,command)
if nargin==2
    switch command
        case 'Clear'
            set(handles.selectFormat,'Value',1)
            List = '-Select a Format-';
        otherwise
            set(handles.selectFormat,'Value',1)
            index = get(handles.selectCamera,'Value');
            List = handles.deviceDefaultFormat;
            Formats = handles.deviceFormats{index};
            for i = 1:length(handles.deviceFormats{index})
                switch Formats{i}
                    case handles.deviceDefaultFormat

                    otherwise
                        List = char(List,Formats{i});
                end
            end
    end
else
    set(handles.selectFormat,'Value',1)
    index = get(handles.selectCamera,'Value');
    List = handles.deviceDefaultFormat;
    Formats = handles.deviceFormats{index};
    for i = 1:length(handles.deviceFormats{index})
        switch Formats{i}
            case handles.deviceDefaultFormat

            otherwise
                List = char(List,Formats{i});
        end
    end
end
set(handles.selectFormat,'String',List)
