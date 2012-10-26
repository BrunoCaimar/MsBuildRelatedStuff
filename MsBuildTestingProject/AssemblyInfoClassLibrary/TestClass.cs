using System.Diagnostics;

#pragma warning disable 1587
/// Just a sample to show AssemblyInfo data Generation 
/// AssemblyFileVersion - FileVersion and InformationalVersion
/// If you want to change open project file (xml) (VS - Edit Project File)
#pragma warning restore 1587
namespace AssemblyInfoClassLibrary
{
    public class TestClass
    {
        public void DoNothing()
        {
            // Do Nothing
            Debug.WriteLine("Somebody call this...");
        }
    }
}
