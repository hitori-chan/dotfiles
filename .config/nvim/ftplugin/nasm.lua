require("runner").f9("nasm -felf64 %:t:S && gcc %:t:r:S.o -o %:t:r:S && ./%:t:r:S", "Build and run current ASM file")
