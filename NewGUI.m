function varargout = NewGUI(varargin)
% NEWGUI MATLAB code for NewGUI.fig
%      NEWGUI, by itself, creates a new NEWGUI or raises the existing
%      singleton*.
%
%      H = NEWGUI returns the handle to a new NEWGUI or the handle to
%      the existing singleton*.
%
%      NEWGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NEWGUI.M with the given input arguments.
%
%      NEWGUI('Property','Value',...) creates a new NEWGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NewGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NewGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NewGUI

% Last Modified by GUIDE v2.5 30-Oct-2023 10:10:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NewGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @NewGUI_OutputFcn, ...
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


% --- Executes just before NewGUI is made visible.
function NewGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NewGUI (see VARARGIN)

% Choose default command line output for NewGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes NewGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = NewGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in plot.
function plot_Callback(hObject, eventdata, handles)
C = centroids;
I = EM_errorWR;
P = EM_error;
if get(handles.In,'value')==get(handles.In,'max')
    plot(C,I);
else
    plot(C,P);
end

% hObject    handle to plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
