$source = @"

public class BasicTest
{
  public static int Add(int a, int b)
    {
        return (a + b);
    }
  public int Multiply(int a, int b)
    {
    return (a * b);
    }
}
"@

Add-Type -TypeDefinition $source -Language CSharp

$basicTest = [BasicTest]::new()
$basicTest.Multiply(2, 3)

[BasicTest]::Add(2, 3)
