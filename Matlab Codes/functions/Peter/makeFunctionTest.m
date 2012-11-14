
MAX_POS = 120;

func = [1:1000];
func = mod(func, MAX_POS);

thisFullFileName =  mfilename('fullpath');
[thisDirectoryName,thisFileName,thisFileExtension] = fileparts(thisFullFileName);
fullOutFileName = [thisDirectoryName '\position_function_test.mat'];
save(fullOutFileName, 'func');