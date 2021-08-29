// A program which runs many threads with as many different call stacks as possible.

import core.sys.windows.windows;

enum NUM_THREADS = 100;
enum RECURSION_DEPTH = 9;
enum RECURSION_WIDTH = 10;
enum DURATION_MS = 30 * 1000;

extern(Windows):
__gshared:
nothrow:
@nogc:

int sum = 0; // prevent optimizations

DWORD func(int depth, int n)(void*)
{
	static if (depth == 0)
		sum += n;
	else
		foreach (i; RangeTuple!RECURSION_WIDTH)
			func!(depth - 1, i)(null);
	return 0;
}

extern(C)
int start()
{
	HANDLE[NUM_THREADS] hThreads = void;
	DWORD dwThreadID;
	for (int i = 0; i < NUM_THREADS; i++)
		hThreads[i] = CreateThread(null, 0, &func!(RECURSION_DEPTH, 0), null, 0, &dwThreadID);
	Sleep(DURATION_MS);
	for (int i = 0; i < NUM_THREADS; i++)
		TerminateThread(hThreads[i], 0);
	return sum;	
}

// -----------------------------------------------------------------------------------

// In newer D versions we would just use static foreach;
// since the existing tests use D 2.073, use something compatible instead.

template ValueTuple(T...)
{
	alias T ValueTuple;
}

template _RangeTupleImpl(size_t N, R...)
{
	static if (N==R.length)
		alias R _RangeTupleImpl;
	else
		alias _RangeTupleImpl!(N, ValueTuple!(R, R.length)) _RangeTupleImpl;
}

template RangeTuple(size_t N)
{
	alias _RangeTupleImpl!(N, ValueTuple!()) RangeTuple;
}
