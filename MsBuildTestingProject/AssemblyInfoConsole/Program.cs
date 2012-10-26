﻿using System;
using System.Diagnostics;
using System.Reflection;
using AssemblyInfoClassLibrary;

#pragma warning disable 1587
/// Use's a linked GlobalAssemblyInfo file
/// FileVersionInfo is generated by AssemblyInfoClassLibrary using MsBuildCommunityTask
#pragma warning restore 1587
namespace AssemblyInfoConsole
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Say Hello to my little darling! ");

            var assemblyVersion = Assembly.GetExecutingAssembly().GetName().Version.ToString();
            var fileVersion = FileVersionInfo.GetVersionInfo(Assembly.GetExecutingAssembly().Location).FileVersion;
            var productVersion = FileVersionInfo.GetVersionInfo(Assembly.GetExecutingAssembly().Location).ProductVersion;

            Console.WriteLine("{0} -- {1} -- {2}", assemblyVersion, fileVersion, productVersion);

            // AssemblyTitle
            Console.WriteLine(FileVersionInfo.GetVersionInfo(Assembly.GetExecutingAssembly().Location).FileDescription);            

            var testClass = new TestClass();
            testClass.DoNothing();

            // AssemblyTitle
            Console.WriteLine(FileVersionInfo.GetVersionInfo(testClass.GetType().Assembly.Location).FileDescription);            

            var testClassassemblyVersion = testClass.GetType().Assembly.GetName().Version.ToString();
            var testClassfileVersion = FileVersionInfo.GetVersionInfo(testClass.GetType().Assembly.Location).FileVersion;
            var testClassproductVersion = FileVersionInfo.GetVersionInfo(testClass.GetType().Assembly.Location).ProductVersion;

            Console.WriteLine("{0} -- {1} -- {2}", testClassassemblyVersion, testClassfileVersion, testClassproductVersion);

            Console.WriteLine(DateTime.Parse("2012-01-01 00:00:00"));
        }

    }
}
