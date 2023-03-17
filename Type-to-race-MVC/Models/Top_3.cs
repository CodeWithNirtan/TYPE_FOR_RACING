using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Type_to_race_MVC.Models
{
    public class Top_3
    {
 
            public int PlayerId { get; set; }
            public string Player_name { get; set; }
            public string ImageUrl { get; set; }
            public int wpm { get; set; }
    }
}