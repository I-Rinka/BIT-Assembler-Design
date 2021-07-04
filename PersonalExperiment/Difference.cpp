#include<stdlib.h>
#include<stdio.h>
#include<string.h>
#include<Windows.h>
int main() {

	errno_t pFile;
	FILE* stream1;
	FILE* stream2;

	char buffer1[1024] = { 0 };
	char buffer2[1024] = { 0 };

	scanf_s("%s", buffer1, 1023);
	scanf_s("%s", buffer2, 1023);

	//pFile = fopen_s(&stream1, "C:/Users/I_Rin/source/repos/Cpp_Experiment/test1.txt", "r");
	//pFile = fopen_s(&stream2, "C:/Users/I_Rin/source/repos/Cpp_Experiment/test2.txt", "r");

	pFile = fopen_s(&stream1, buffer1, "r");
	pFile = fopen_s(&stream2, buffer2, "r");

fopen()

	int judge = 0;
	int line = 0;

	if (pFile == NULL && stream2 != NULL && stream1 != NULL) {
		while (fgets(buffer1, 1023, stream1) != NULL)
		{
			line++;
			if (fgets(buffer2, 1023, stream2) != NULL)
			{
				if (strcmp(buffer1, buffer2) != 0)
				{
					judge = 1;
					break;
				}
			}
			else
			{
				judge = 1;
				break;
			}
		}
		if (fgets(buffer2, sizeof(buffer2), stream2) != NULL) {
			judge = 1;

		}
		fclose(stream1);
		fclose(stream2);
	}
	else
	{
		MessageBoxA(NULL, "Open file error!", "Difference!", 0);
		exit(1);
	}
	if (judge)
	{
		char text[100];
		sprintf_s(text, 100, "Content is different at line %d\n", line);
		MessageBoxA(NULL, text, "Difference!", 0);
	}
	else
	{
		MessageBoxA(NULL, "No difference!", "Difference!", 0);
	}
}