﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Roslyn.Example_source
{
    public class Aisle
    {
        public string Name;
        public List<Product> Products { get; set; }

        public Aisle(string name)
        {
            this.Name = name;
            this.Products = new List<Product>();
        }

        ~ Aisle()
        {
            this.Name = null;
            this.Products = null;
        }
    }}
