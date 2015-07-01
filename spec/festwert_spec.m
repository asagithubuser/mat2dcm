function festwert_spec

K_SOME_SCALAR = 1.50;
K_SOME_TEXT = {'foo'};

% Save labels to a temporary file
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

% Delete temporary files
if exist('tmp.mat', 'file'), delete('tmp.mat'); end
if exist('tmp.dcm', 'file'), delete('tmp.dcm'); end
