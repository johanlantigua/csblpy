function varargout = agility_GUI_LA_camp(varargin)
% AGILITY_GUI_LA_CAMP MATLAB code for agility_GUI_LA_camp.fig
%      AGILITY_GUI_LA_CAMP, by itself, creates a new AGILITY_GUI_LA_CAMP or raises the existing
%      singleton*.
%
%      H = AGILITY_GUI_LA_CAMP returns the handle to a new AGILITY_GUI_LA_CAMP or the handle to
%      the existing singleton*.
%
%      AGILITY_GUI_LA_CAMP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AGILITY_GUI_LA_CAMP.M with the given input arguments.
%
%      AGILITY_GUI_LA_CAMP('Property','Value',...) creates a new AGILITY_GUI_LA_CAMP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before agility_GUI_LA_camp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to agility_GUI_LA_camp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help agility_GUI_LA_camp

% Last Modified by GUIDE v2.5 12-May-2022 20:59:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @agility_GUI_LA_camp_OpeningFcn, ...
                   'gui_OutputFcn',  @agility_GUI_LA_camp_OutputFcn, ...
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


% --- Executes just before agility_GUI_LA_camp is made visible.
function agility_GUI_LA_camp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to agility_GUI_LA_camp (see VARARGIN)

% Choose default command line output for agility_GUI_LA_camp
handles.output = hObject;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes agility_GUI_LA_camp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = agility_GUI_LA_camp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in initialize_button.
function initialize_button_Callback(hObject, eventdata, handles)
% hObject    handle to initialize_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
get(handles.port_edit,'String')


handles.a = arduino(get(handles.port_edit,'String'),'uno')
set(handles.port_edit,'BackgroundColor','green')
guidata(hObject, handles);

% --- Executes on button press in start_button.
function start_button_Callback(hObject, eventdata, handles)
% hObject    handle to start_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.total_time=str2double(get(handles.sampling_dur_edit,'String'))
axes(handles.plot_axes)
cla
handles.time_point_1='NaN'
handles.time_point_2='NaN'
handles.measured_time='NaN'
set(handles.time_point_1_text, 'BackgroundColor', [1 0 0])
set(handles.time_point_2_text, 'BackgroundColor', [1 0 0])
set(handles.measured_time_text, 'BackgroundColor', [1 0 0])
set(handles.time_point_1_text,'String','No Data')
set(handles.time_point_2_text,'String','No Data')
set(handles.measured_time_text,'String','No Data')

t=0
tic
data_out=nan(1500,2);
i=1

while t < (handles.total_time) %for loop that iterates for the amount of time specified. timing will need to be tweaked if a sampling interval other than one second is used.
    t = toc; %notes the time elapsed since tic
    
   
   
    
    data_out(i,1) = t; %puts data into an i X 4 matrix for output to CSV
    data_out(i,2) = readVoltage(handles.a,'A1');
  
if i==1
    scatter(data_out(i,1),data_out(i,2),'Filled','k')
    
    xlim([0 handles.total_time])
    hold on
    else
    plot(data_out(i-1:i,1),data_out(i-1:i,2),'b')
end




drawnow limitrate

    i = i + 1;
end 
hold off

i
handles.sample_rate=i/handles.total_time;
size(data_out)
handles.raw_data=data_out(1:i,:)

guidata(hObject, handles);

% --- Executes on button press in export_data_button.
function export_data_button_Callback(hObject, eventdata, handles)
% hObject    handle to export_data_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

export_name=strcat('agility_',get(handles.player_number_edit,'String'))
cd('C:\Users\John\Dropbox\4th Family\LA Skills Acadamy\evaluation folder\agility')
test_info={'Player Number';'year';'month';'day';'hour';'minute';'second';'Sample Duration';'Sample Rate';'Time 1',;'Time 2';'Time Measured'}
c=fix(clock)
test_results={get(handles.player_number_edit,'String');num2str(c(1));num2str(c(2));num2str(c(3));num2str(c(4));num2str(c(5));num2str(c(6));handles.total_time;handles.sample_rate;handles.time_point_1;handles.time_point_2;handles.measured_time}
output=[test_info test_results]

xlswrite(strcat(export_name,'.xlsx'),output)
xlswrite(strcat(export_name,'.xlsx'),handles.raw_data,'Sheet1','E3')
xlswrite(strcat(export_name,'.xlsx'),{'Time (s)' 'Signal (V)'},'Sheet1','E2')


function player_number_edit_Callback(hObject, eventdata, handles)
% hObject    handle to player_number_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of player_number_edit as text
%        str2double(get(hObject,'String')) returns contents of player_number_edit as a double


% --- Executes during object creation, after setting all properties.
function player_number_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to player_number_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in first_time_point_button.
function first_time_point_button_Callback(hObject, eventdata, handles)
% hObject    handle to first_time_point_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


input_start=ginput(1)
handles.time_point_1=input_start(1,1)
set(handles.time_point_1_text,'String',num2str(handles.time_point_1))

for i=1:length(handles.raw_data)
    if handles.time_point_1<handles.raw_data(i,1)
out=i
break
    end
end
hold on
scatter(handles.raw_data(out,1),handles.raw_data(out,2),'Filled','r')
hold off

text(handles.time_point_1+.1,handles.raw_data(out,2),'Start Point');

set(handles.time_point_1_text, 'BackgroundColor', [0 1 0])

guidata(hObject, handles);



% --- Executes on button press in second_time_point_button.
function second_time_point_button_Callback(hObject, eventdata, handles)
% hObject    handle to second_time_point_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

input_end=ginput(1)
handles.time_point_2=input_end(1,1)


for i=1:length(handles.raw_data)
    if handles.time_point_2<handles.raw_data(i,1)
out=i
break
    end
end
hold on
scatter(handles.raw_data(out,1),handles.raw_data(out,2),'Filled','r')
hold off


handles.measured_time=handles.time_point_2-handles.time_point_1


ax = get(gcf,'CurrentAxes')





text(handles.time_point_2+.1,handles.raw_data(out,2),'End Point');



set(handles.time_point_2_text,'String',num2str(handles.time_point_2))
set(handles.measured_time_text,'String',num2str(handles.measured_time))
set(handles.time_point_2_text, 'BackgroundColor', [0 1 0])
set(handles.measured_time_text, 'BackgroundColor', [0 1 0])

guidata(hObject, handles);


function sampling_dur_edit_Callback(hObject, eventdata, handles)
% hObject    handle to sampling_dur_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sampling_dur_edit as text
%        str2double(get(hObject,'String')) returns contents of sampling_dur_edit as a double


% --- Executes during object creation, after setting all properties.
function sampling_dur_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sampling_dur_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function port_edit_Callback(hObject, eventdata, handles)
% hObject    handle to port_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of port_edit as text
%        str2double(get(hObject,'String')) returns contents of port_edit as a double


% --- Executes during object creation, after setting all properties.
function port_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to port_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
