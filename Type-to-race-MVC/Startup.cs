using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(Type_to_race_MVC.Startup))]
namespace Type_to_race_MVC
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
