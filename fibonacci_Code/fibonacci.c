int main ()
{
    int n = 10; // compute the the 10th fibonacci number
    int a = 0, b = 1;
    int fib;
    
    for (int i = 0; i < n; i++)
    {
        fib = a + b;
        a = b;
        b = fib;
    }


    volatile int *result = (int *)32; // to store the result in memory 
    *result = a;


    while (1) {} // halt trap
}
