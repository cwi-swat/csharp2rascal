using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AST_Getter.Helpers
{
    public class LocationHelper
    {
        private static string strLocation = "@location";
        public static string CurrentFilename;
        internal static string Get(ICSharpCode.NRefactory.CSharp.AstNode node)
        {
            if (!GlobalConstants.IncludingLocations)
                return "";

            CurrentFilename = CurrentFilename.Replace(":", "").Replace("\\", "/");
            var location = String.Format("|file:///{0}|({1},{2},<{3},{4}>,<{5},{6}>)",
                                         CurrentFilename,
                                         0,
                                         0,
                                         node.StartLocation.Line,
                                         node.StartLocation.Column,
                                         node.EndLocation.Line,
                                         node.EndLocation.Column);

            return String.Format("[{0}={1}]{2}", strLocation, location, Environment.NewLine);

        }

        public static string EmptyLocation = string.Format("[{0}=|file:///|(0,0,<0,0>,<0,0>)]", strLocation);
    }
}