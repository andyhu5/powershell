using System;
using System.Threading;
using System.Threading.Tasks;

namespace Hello
{
    public class App
    {
        // Semaphore to enforce alternating execution
        private static readonly SemaphoreSlim semaphore = new SemaphoreSlim(1, 1);

        public static async Task Test(string[] args)
        {
            Task foo = Foo(10);
            Task bar = Bar(10);

            await Task.WhenAll(foo, bar);
        }

        private static async Task Foo(int counter)
        {
            for (int i = 0; i < counter; i++)
            {
                await semaphore.WaitAsync(); // Acquire semaphore
                try
                {
                    Console.WriteLine("Foo");
                    await Task.Delay(2000); // Simulate work with 2-second delay
                }
                finally
                {
                    semaphore.Release(); // Release semaphore
                }
            }
        }

        private static async Task Bar(int counter)
        {
            for (int i = 0; i < counter; i++)
            {
                await semaphore.WaitAsync(); // Acquire semaphore
                try
                {
                    Console.WriteLine("Bar");
                    await Task.Delay(2000); // Simulate work with 2-second delay
                }
                finally
                {
                    semaphore.Release(); // Release semaphore
                }
            }
        }
    }
}

// compile to library use csc commmand ,use developer command prompt
// csc /t:library Hello.cs