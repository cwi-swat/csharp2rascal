using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using ExampleCode.Evaluation_Tests;

namespace UnitTestProject
{
    [TestClass]
    public class UnitTest1
    {
        [TestMethod]
        public void TestMethod1()
        {
            Assert.AreEqual(new Test1Class().Test1(), 30);
        }
    }
}