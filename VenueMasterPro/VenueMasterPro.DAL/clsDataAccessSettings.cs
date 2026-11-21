//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Text;
//using System.Threading.Tasks;

//namespace VenueMasterPro.DAL
//{
//    internal class clsDataAccessSettings
//    {

//        public static string ConnectionString = "Server = . ; DataBase = DVLD ; User ID = sa ; password = sa123456";
//    }
//}


namespace VenueMasterPro.DAL
{
    internal class clsDataAccessSettings
    {
        // تأكد من استبدال VenueMasterDb باسم قاعدة بيانات مشروعك الفعلي في SQL Server
        public static string ConnectionString =
            "Server=.;Database=VenueMasterProDB;User ID=sa;Password=sa123456;TrustServerCertificate=True;";
    }
}


