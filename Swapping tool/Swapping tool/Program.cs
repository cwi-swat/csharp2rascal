using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace Swapping_tool
{
    class Program
    {
        public static void Main(string[] args)
        {
            //empty the output directory
            Directory.Delete(Constants.OutputPath, true);

            var swapFile = File.ReadAllLines(Constants.SwapFile);
            
            SwapLine swapLine = null;
            for (int i = 0; i < swapFile.Length; i++)
            {
                var line = swapFile[i];
                if (line.StartsWith("-"))
                {
                    swapLine.AddAvailableSwap(new SwapLine(line));
                }
                else
                {
                    if (swapLine != null)
                        swapLine.Process();

                    swapLine = new SwapLine(line);
                }
            }
            swapLine.Process();

        }
    }
}
