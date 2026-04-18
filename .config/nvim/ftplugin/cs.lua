require('runner').f9(
	'mcs %:S && mono %:r:S.exe',
	'Build and run current C# file'
)
