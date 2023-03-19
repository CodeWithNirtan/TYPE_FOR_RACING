using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using Type_to_race_MVC.Models;

namespace Type_to_race_MVC.Controllers
{
    public class HomeController : Controller
    {
        TypetoRaceEntities db = new TypetoRaceEntities();
        public ActionResult Index()
        {

                List<Top_3> score = new List<Top_3>();

            var Topplayer = db.Top_3().FirstOrDefault();
            if (Topplayer != null)
            {

                Top_3 s = new Top_3();
                s.ImageUrl = Topplayer.ImageUrl;
                s.Player_name = Topplayer.Player_name;
                s.PlayerId = Topplayer.PlayerId;
                s.wpm = Topplayer.wpm;

                ViewBag.Playerid = s;

                var top3scores = db.Top_3().ToList();
                foreach (var item in top3scores)
                {

                    Top_3 ts = new Top_3();
                    ts.ImageUrl = item.ImageUrl;
                    ts.Player_name = item.Player_name;
                    ts.PlayerId = item.PlayerId;
                    ts.wpm = item.wpm;
                    score.Add(ts);

                }

                return View(score.ToList());
            }
            else {
                return View(score.ToList());
            }
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact us page.";

            return View();
        }
    
        
        
        [Authorize]
        public ActionResult PlayGame() {
            var useremail = User.Identity.GetUserName();
            if(useremail == null)
            {
                return RedirectToAction("login","account");
            }
            var user = db.players.Where(x => x.Player_email.Equals(useremail)).FirstOrDefault();
            var userid = user.PlayerId;

           
            return View(db.players.Where(x=>x.PlayerId.Equals(userid)).FirstOrDefault());
        }

        [HttpPost]
        public ActionResult check(Player_score score)
        {
            string result = "Could not load Data !ERROR";
            if (score != null)
            {
                score.DateCreated = DateTime.Now;
                db.Player_score.Add(score);
                db.SaveChanges();

                return RedirectToAction("PlayGame");
            }
            else {

            return Json(result, JsonRequestBehavior.AllowGet);
            }
        }

        public ActionResult Tutorials() {
            return View();
        }

    }

}