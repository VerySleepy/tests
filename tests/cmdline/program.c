int vs_test_fun()
{
	unsigned int i, n = 17;
	// This is 4x longer than the other ones because we need more time to gather samples.
	for (i=0; i<4000000000u; i++)
		n = n * 17 + i;
	return n;
}

int main()
{
	return vs_test_fun();
}
