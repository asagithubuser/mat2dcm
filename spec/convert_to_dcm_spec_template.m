function convert_to_dcm_spec
% Integration spec for convert_to_dcm

% Create a label of each type to be exported
K_SOME_SCALAR = 1.50;
K_SOME_VECTOR = [1 -2.3 10];
K_SOME_MATRIX = [0 10; 0.2 3; -3 9];
K_SOME_TEXT = {'foo'};

KL_SOME_LOOKUP_LINE.x = [-10 0 100];
KL_SOME_LOOKUP_LINE.y = [2 -0.1 2.1];

KL_SOME_TEXT.x = {'foo', 'bar'};
KL_SOME_TEXT.y = [1 2];

KF_SOME_LOOKUP_TABLE.x = [-10 0 100];
KF_SOME_LOOKUP_TABLE.y = [0 1]';
KF_SOME_LOOKUP_TABLE.z = [0 0 0; -1 0 10];

% Save all of them to a temporary file
save('tmp.mat', '-regexp', '^K_SOME_');

% Export using convert_to_dcm
convert_to_dcm('tmp.mat', 'tmp.dcm', ...
  'Precision', '%1.3f', ...
  'LabelPrefix', '', ...
  'Verbose', false);
filecontent = regexprep(fileread('tmp.dcm'), '\r', '');

% Make myassertions about the file content
myassert(~isempty(regexp(filecontent, [...
  'FESTWERT K_SOME_SCALAR\n' ...
  '   EINHEIT_W "-"\n' ...
  '   WERT 1.500\n' ...
  'END\n' ...
])));

myassert(~isempty(regexp(filecontent, [...
  'FESTWERTEBLOCK K_SOME_VECTOR 3\n' ...
  '   EINHEIT_W "-"\n' ...
  '   WERT   1.000   -2.300   10.000\n' ...
  'END\n' ...
])));

myassert(~isempty(regexp(filecontent, [...
'FESTWERTEBLOCK K_SOME_MATRIX 3 @ 2\n' ...
'   EINHEIT_W "-"\n' ...
'   WERT   0.000   -3.000   3.000\n' ...
'   WERT   0.200   10.000   9.000\n' ...
'END\n' ...
])));

myassert(~isempty(regexp(filecontent, [...
'KENNLINIE K_SOME_LOOKUP_LINE 3\n' ...
'   EINHEIT_X "-"\n' ...
'   EINHEIT_W "-"\n' ...
'   ST/X   -10.000   0.000   100.000\n' ...
'   WERT   2.000   -0.100   2.100\n' ...
'END\n' ...
])));

myassert(~isempty(regexp(filecontent, [...
'KENNFELD K_SOME_LOOKUP_TABLE 3 2\n' ...
'   EINHEIT_X "-"\n' ...
'   EINHEIT_Y "-"\n' ...
'   EINHEIT_W "-"\n' ...
'   ST/X   -10.000   0.000   100.000\n' ...
'   ST/Y   0.000\n' ...
'   WERT   0.000   0.000   0.000\n' ...
'   ST/Y   1.000\n' ...
'   WERT   -1.000   0.000   10.000\n' ...
'END\n' ...
])));

% Export again with a prefix
convert_to_dcm('tmp.mat', 'tmp.dcm', ...
  'Precision', '%1.3f', ...
  'SgName', 'le125', ...
  'Prefix', 'Some_Prefix.', ...
  'Verbose', false);
filecontent = regexprep(fileread('tmp.dcm'), '\r', '');

% Make sample myassertion about one label
myassert(~isempty(regexp(filecontent, [...
  'FESTWERT Some_Prefix.K_SOME_SCALAR\n' ...
  '   EINHEIT_W "-"\n' ...
  '   WERT 1.500\n' ...
  'END\n' ...
])));

% Export with LEB450 dimensioning
convert_to_dcm('tmp.mat', 'tmp.dcm', ...
  'Precision', '%1.3f', ...
  'SgName', 'le450', ...
  'Prefix', 'Some_Prefix.', ...
  'Verbose', false);
filecontent = regexprep(fileread('tmp.dcm'), '\r', '');

% Make sample myassertion about matrix
myassert(~isempty(regexp(filecontent, [...
  'FESTWERTEBLOCK Some_Prefix.K_SOME_MATRIX 6\n' ...
  '   EINHEIT_W "-"\n' ...
  '   WERT   0.000   0.200   -3.000   10.000   3.000   9.000\n' ...
  'END' ...
])));

% Delete the temporary files again
if exist('tmp.mat', 'file')
  delete('tmp.mat');
end

if exist('tmp.dcm', 'file')
  delete('tmp.dcm');
end
