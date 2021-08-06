#include "registerManager.hpp"

void clear_registers(int *array, int size)
{
	for (int i = 0; i < size; i++)
	{
		array[i] = 0;
	}
}

void showstack(stack<int> s)
{
	while (!s.empty())
	{
		cout << '\t' << s.top();
		s.pop();
	}
	cout << '\n';
}