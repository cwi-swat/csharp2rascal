using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Swapping_tool
{
    public class SwapLine
    {
        public int From { get; set; }
        public int To { get; set; }
        public string Filepath { get; set; }
        public string FileName { get; set; }
        public List<SwapLine> AvailableSwaps { get; set; }

        public SwapLine(string line)
        {
            Filepath = line.Split('|').First();
            FileName = Filepath.Substring(Filepath.LastIndexOf("\\") + 1);
            From = int.Parse(line.Split('|').Last().Split(',').First());
            To = int.Parse(line.Split('|').Last().Split(',').Last());
            AvailableSwaps = new List<SwapLine>();
        }
        public void AddAvailableSwap(SwapLine swapLine)
        {
            AvailableSwaps.Add(swapLine);
        }

        public void Process()
        {
            var fileLines = File.ReadAllLines(Filepath).ToList();
            var i = 1;

            foreach (var swapLine in AvailableSwaps)
            {
                var filepath = String.Format(Constants.OutputPath + FileName + " - {0}\\", i);
                while (Directory.Exists(filepath))
                {
                    i++;
                    filepath = String.Format(Constants.OutputPath + FileName + " - {0}\\", i);
                }
                Directory.CreateDirectory(filepath);

                var filename = filepath + FileName;
                CreateSwappedFile(fileLines, filename, swapLine.From, swapLine.To);
                i++;
            }
        }

        private void CreateSwappedFile(List<string> fileLines, string filename, int from, int to)
        {
            //add all before our line
            var newfileLines = fileLines.Take(From - 1).ToList();

            //add the swap content
            newfileLines.AddRange(fileLines.Range(from - 1, to - 1));

            //add all the lines between the swaps
            newfileLines.AddRange(fileLines.Range(To - 1, from - 1));

            //add our line
            newfileLines.AddRange(fileLines.Range(From - 1, To - 1));

            //add all the other lines
            newfileLines.AddRange(fileLines.Range(to - 1, fileLines.Count));

            var newFile = File.CreateText(filename);
            foreach (var line in newfileLines)
            {
                newFile.WriteLine(line);
            }
            newFile.Close();
            newFile.Dispose();
        }
    }
}
