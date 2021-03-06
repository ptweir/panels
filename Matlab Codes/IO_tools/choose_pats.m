function varargout = choose_pats(varargin)
% Edit the above text to modify the response to help choose_pats
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @choose_pats_OpeningFcn, ...
                   'gui_OutputFcn',  @choose_pats_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before choose_pats is made visible.
function choose_pats_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for choose_pats
handles.output = hObject;

%perform initializations here:
handles.file = [];
handles.file_index = 0;
set(handles.button_remove_file, 'enable', 'Off');
set(handles.button_make_image, 'enable', 'Off');
set(handles.button_burn, 'enable', 'Off');
guidata(hObject, handles);  % Update handles structure

% --- Outputs from this function are returned to the command line.
function varargout = choose_pats_OutputFcn(hObject, eventdata, handles)
% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% do some backing up here
% save ....
selection = questdlg('Close Pattern Selection Tool?','Close Request Function', 'Yes','No','Yes');
switch selection,
   case 'Yes',
     delete(hObject)
   case 'No'
     return
end

% --- Executes during object creation, after setting all properties.
function listbox_files_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in listbox_files.
function listbox_files_Callback(hObject, eventdata, handles)
% show the parameters for the highlighted entry
% set this to the file_index, so if changes are made to param list, can
% record them for the correct file
handles.file_index = get(handles.listbox_files,'Value');
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%     Callbacks for all buttons goes here                           %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function button_add_file_Callback(hObject, eventdata, handles)
% --- Executes on button press in button_add_file.
panel_control_paths;
cd(pattern_path)
[FileName,PathName] = uigetfile('Pattern*.mat','Select a PATTERN file');
% returns a 0 if cancel is pressed
if ~(isequal(FileName, 0)|isequal(PathName, 0))
    handles.file_index = length(handles.file) +1;
    handles.file(handles.file_index).FileName = FileName;
    handles.file(handles.file_index).PathName = PathName;
    handles.file_list{handles.file_index} = FileName;
    set(handles.listbox_files, 'String', handles.file_list);
    guidata(hObject, handles);
end
if(length(handles.file) > 0)
    set(handles.button_remove_file, 'enable', 'On');
    set(handles.button_make_image, 'enable', 'On');
end


function button_add_folder_Callback(hObject, eventdata, handles)
% --- Executes on button press in button_add_folder.
dir_path = uigetdir;
if ~isequal(dir_path, 0)
    dir_struct = dir(fullfile(dir_path, 'Pattern*.mat'));
    [sorted_names,sorted_index] = sortrows({dir_struct.name}');
	% loop through the files in the folder, add one at a time
	for j = 1:length(sorted_names)
        handles.file_index = length(handles.file) + 1;
        handles.file(handles.file_index).FileName = sorted_names{j}; % use curly braces to index into cell array
        handles.file(handles.file_index).PathName = [dir_path filesep];
	    handles.file_list{handles.file_index} = sorted_names{j};
        set(handles.listbox_files, 'String', handles.file_list);
        guidata(hObject, handles);  % Update handles structure
    end    
end   
if(length(handles.file) > 0)
    set(handles.button_remove_file, 'enable', 'On');
    set(handles.button_make_image, 'enable', 'On');
end

% --- Executes on button press in button_remove_file.
function button_remove_file_Callback(hObject, eventdata, handles)
% removes the highlighted file from the list
handles.file_index = get(handles.listbox_files,'Value');
file_index = handles.file_index;
num_files = length(handles.file);
files_to_keep = [1:(file_index-1) (file_index+1):num_files];
% create an index of the files to keep    
handles.file = handles.file([files_to_keep]);    
rem_val = get(handles.listbox_files,'Value');
handles.file_list(rem_val) = [];
set(handles.listbox_files, 'String', handles.file_list);
set(handles.listbox_files,'Value', 1); % set this to 1 to prevent attempt to delete
handles.file_index = 1; 
% files just removed from the list
guidata(hObject, handles);  % Update handles structure
if(length(handles.file) <= 0)
    set(handles.button_remove_file, 'enable', 'Off');
    set(handles.button_make_image, 'enable', 'Off');
end

% --- Executes on button press in button_make_image.
function button_make_image_Callback(hObject, eventdata, handles)
% first step is to enable the boxes for entering parameters
set(handles.button_add_folder, 'enable', 'Off');
set(handles.button_add_file, 'enable', 'Off');
set(handles.button_remove_file, 'enable', 'Off');
handles.SD = make_flash_image(handles.file);
set(handles.button_burn, 'enable', 'On');
guidata(hObject, handles);  % Update handles structure

% --- Executes on button press in button_burn.
function button_burn_Callback(hObject, eventdata, handles)
global SD;
panel_control_paths;
% step 1 - get the drive letter
SD_drive = get_SD_drive;
if (SD_drive ~= -1)
    % step 2 - format the drive
    %dos(['format ' SD_drive ': /FS:FAT /Q &']); % here, don't bother to check the status, 
        %if this fails, so will next step - no harm done... open dos prompt
    %dos(['format ' SD_drive ': /FS:FAT32 /Q ']); 
    
    % step 3 - use dd.exe to burn the just created image - temp\SD.img
    if length(dir([SD_drive, ':\*.pat']))
        dos(['del ' SD_drive ':\*.pat']);
    end

     results = dos(['copy /Y ' temp_path '\*.pat ' SD_drive ':\']);  
     %['dd if=' temp_path '\SD.img of=\\.\' SD_drive ': bs=1k &']
    %dos(['dd if=' temp_path '\SD.img of=\\.\' SD_drive ': bs=1k &']);

    if results
        errordlg('Failed to use the dos copy command.');
        return;
    end
    
    SD.pattern = handles.SD;
    save([controller_path '\SD'], 'SD');
    save([SD_drive ':\SD'], 'SD');
    %cannot update handles.PC fields :num_patterns, pattern_x_size,
    %pattern_y_size in PControl.m
    warndlg('You have sucessfully loaded the pattern to the SD card. Please restart PControl to update pattern parameters!','Restart PControl Dialog')
else
    errordlg('Bad choice of disk, or disk is missing, try again');
end

function send_serial(string_to_send)

% this is a function for sending serial port info from matlab. 
% it is written as an alternative to mex_serial
% written in a hurry by MBR, should be modifed to include error checking,
% etc., but seems to work as is, and has not crashed or hung. 

% fid = fopen('com8:', 'w');
% fwrite(fid, string_to_send, 'uchar');
% fclose(fid);
guidata(hObject, handles);
fprintf(handles.PC.serialPort, string_to_send);
