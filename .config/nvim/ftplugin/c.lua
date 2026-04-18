local cmd
if vim.bo.filetype == 'c' then
	cmd = 'gcc -Wall %:S -o %:t:r:S && ./%:t:r:S'
else
	cmd = 'g++ -Wall %:S -o %:t:r:S && ./%:t:r:S'
end

require('runner').f9(cmd, 'Build and run current C/C++ file')
