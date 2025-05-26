using System;

namespace AndyHU
{
    public class Tools
    {
        public string Greet(string name)
        {
            return $"Hello, {name}!";
        }
    }
}

// compile to library
// csc /target:library /out:Hello.dll Hello.cs
// compile to executable
// csc /out:Hello.exe Hello.cs