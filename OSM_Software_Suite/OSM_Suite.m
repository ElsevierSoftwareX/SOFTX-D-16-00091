%+------------------------------------------------------------------------+
%|                                                                        |
%| FILENAME : OSM_Suite_m                                 VERSION : B.1.1 |
%|                                                                        |
%| TITLE : OSM Software Suite                     AUTHOR : Daniel Aldrich |
%|                                                                        |
%+------------------------------------------------------------------------+
%|                                                                        |
%| DEPENDENT FILES :                                                      |
%|       > OSM_Suite_fig                                                  |
%|       > OSM_Classic_m                                                  |
%|       > OSM_Classic_fig                                                |
%|       > Video_Converter_m                                              |
%|       > Video_Converter_fig                                            |
%|                                                                        |
%| DESCRIPTION :                                                          |
%|       This program is designed to be the main screen for the OSM       |
%|        Software Package.                                               |
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
%|       B.1.1 23/10/2015 DA Addition of OSM: Classic and Video Converter |
%|       A.0.1 16/10/2015 DA Creation of Main Menu for the Suite          |
%|                                                                        |
%+------------------------------------------------------------------------+
function varargout = OSM_Suite(varargin)
% Last Modified by GUIDE v2.5 21-Oct-2015 19:02:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OSM_Suite_OpeningFcn, ...
                   'gui_OutputFcn',  @OSM_Suite_OutputFcn, ...
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

function OSM_Suite_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

folderCheck()

guidata(hObject, handles);

function varargout = OSM_Suite_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function mainMenu_DeleteFcn(hObject, eventdata, handles)
delete(handles.mainMenu)

function osmClassic_Callback(hObject, eventdata, handles)
mainMenu_DeleteFcn(hObject, eventdata, handles)
cd(fullfile(cd(),'bin','OSM_Classic'))
run('OSM_Classic.m')

function osmTwoD_Callback(hObject, eventdata, handles)

function gigeImaq_Callback(hObject, eventdata, handles)

function xCorrelation_Callback(hObject, eventdata, handles)

function videoConversion_Callback(hObject, eventdata, handles)
mainMenu_DeleteFcn(hObject, eventdata, handles)
cd(fullfile(cd(),'bin','Video_Converter'))
run('Video_Converter.m')

function quit_Callback(hObject, eventdata, handles)
mainMenu_DeleteFcn(hObject,eventdata,handles)

function[] = folderCheck()
if exist('Input','dir')~=7
    mkdir('Input')
    cd('Input')
    mkdir('Classic')
    mkdir('2Dimesional')
    mkdir('Correlation')
    mkdir('Videos')
    mkdir('Other')
    cd('..')
else
    cd('Input')
    if exist('Classic','dir')~=7
        mkdir('Classic')
    end
    if exist('2Dimensional','dir')~=7
        mkdir('2Dimensional')
    end
    if exist('Correlation','dir')~=7
        mkdir('Correlation')
    end
    if exist('Videos','dir')~=7
        mkdir('Videos')
    end
    if exist('Other','dir')~=7
        mkdir('Other')
    end
    cd('..')
end
if exist('Output','dir')~=7
    mkdir('Output')
    cd('Output')
    mkdir('Classic')
    mkdir('2Dimesional')
    mkdir('Correlation')
    mkdir('Other')
    cd('..')
else
    cd('Output')
    if exist('Classic','dir')~=7
        mkdir('Classic')
    end
    if exist('2Dimensional','dir')~=7
        mkdir('2Dimensional')
    end
    if exist('Correlation','dir')~=7
        mkdir('Correlation')
    end
    if exist('Other','dir')~=7
        mkdir('Other')
    end
    cd('..')
end
