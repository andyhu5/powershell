$source = @"
using System;
using System.Collections.Generic;

public class BasicTest
{
  public int Add(int a, int b)
  {
      return (a + b);
  }

  public int Multiply(int a, int b)
  {
    return (a * b);
  }

  public void PrintHello(string name)
  {
    System.Console.WriteLine(string.Format("Hello {0}!", name));
  }
  public void PrintList(List<string> list)
  {
    foreach (var item in list)
    {
      System.Console.WriteLine(item);
    }
  }
  public void PrintDictionary(Dictionary<string, string> dict)
  {
    foreach (var kvp in dict)
    {
      System.Console.WriteLine(string.Format("{0}: {1}", kvp.Key, kvp.Value));
    }
  }

  public void PrintHashTable(System.Collections.Hashtable hashtable)
  {
    foreach (var key in hashtable.Keys)
    {
      System.Console.WriteLine(string.Format("{0}: {1}", key, hashtable[key]));
    }
  }

  public void PrintArray(string[] array)
  {
    foreach (var item in array)
    {
      System.Console.WriteLine(item);
    }
  }
    
  public void PrintHelloWorld()
  {
    System.Console.WriteLine("Hello World!");
  }

  public Dictionary<string, string> GetDictionary()
  {
    var dict = new Dictionary<string, string>();
    dict.Add("name", "apple");
    dict.Add("model", "macbook Air");
    dict.Add("color", "silver");
    return dict;
  }

  public System.Collections.Hashtable GetHashTable()
  {
    var hashtable = new System.Collections.Hashtable();
    hashtable.Add("name", "apple");
    hashtable.Add("model", "macbook Air");
    hashtable.Add("color", "silver");
    return hashtable;
  }

}
"@

Add-Type -TypeDefinition $source -Language CSharp

$basicTest = [BasicTest]::new()
$sum = $basicTest.Add(5, 10)
Write-Host "Sum of 5 and 10 is: $sum"
$basicTest.PrintHello("World")
$basicTest.PrintHelloWorld()
$basicTest.PrintList(@("apple", "banana", "cherry"))

$dict = [System.Collections.Generic.Dictionary[string, string]]::new()
$dict.Add("name", "Apple")
$basicTest.PrintDictionary($dict)

$hashtable = @{}
$hashtable.Add("color", "Red")
$hashtable.Add("taste", "Sweet")
$basicTest.PrintHashTable(@{"color" = "Red"; "taste" = "Sweet"; "shape" = "Round"})

$array = @("one", "two", "three")
$basicTest.PrintArray($array)

$dictFromMethod = $basicTest.GetDictionary()
Write-Host $dictFromMethod["name"]
Write-Host $dictFromMethod["model"]
Write-Host $dictFromMethod["color"]

$hashtableFromMethod = $basicTest.GetHashTable()
Write-Host $hashtableFromMethod["name"]
Write-Host $hashtableFromMethod["model"]
Write-Host $hashtableFromMethod["color"]

