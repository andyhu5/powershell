write-host "Hello World"

$csharpCode = @"
using System;
using System.Collections.Generic;

public class Person
{
    public string Name { get; set; }
    public int Age { get; set; }

    public Person(string name, int age)
    {
        Name = name;
        Age = age;
    }

    public string GetGreeting()
    {
        return string.Format("Hello, my name is {0} and I am {1} years old.", Name, Age);
    }

    public static List<Person> GetSamplePeople()
    {
        return new List<Person>
        {
            new Person("Alice", 25),
            new Person("Bob", 30)
        };
    }
}
"@

try {
    # Attempt to compile the C# code
    Add-Type -TypeDefinition $csharpCode -Language CSharp
    Write-Host "C# code compiled successfully."

    # Example usage of the compiled code
    $people = [Person]::GetSamplePeople()
    foreach ($person in $people) {
        Write-Host $person.GetGreeting()
    }
}
catch {
    Write-Host "Error compiling C# code: $_"
}