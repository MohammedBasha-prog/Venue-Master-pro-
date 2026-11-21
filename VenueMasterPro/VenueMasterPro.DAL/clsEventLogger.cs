using System;
using System.Diagnostics;
using System.Runtime.Versioning;

namespace VenueMasterPro.DAL
{
    [SupportedOSPlatform("windows")]
    public static class clsEventLogger
    {
        // اسم المصدر الذي سيظهر به برنامجك داخل أداة Event Viewer في ويندوز
        private const string _sourceName = "VenueMasterPro";
        private const string _logName = "Application";

        public static void LogError(Exception ex, string methodName = "")
        {
            try
            {
                // إنشاء المصدر في ويندوز إذا لم يكن موجوداً مسبقاً
                if (!EventLog.SourceExists(_sourceName))
                {
                    EventLog.CreateEventSource(_sourceName, _logName);
                }

                // تنسيق تفاصيل الخطأ بشكل واضح ومنظم
                string message =
                    $"Method      : {methodName}{Environment.NewLine}" +
                    $"Message     : {ex.Message}{Environment.NewLine}" +
                    $"Inner Error : {ex.InnerException?.Message ?? "None"}{Environment.NewLine}" +
                    $"Stack Trace : {ex.StackTrace}";

                // كتابة الخطأ في سجل التطبيقات الخاص بويندوز كـ Error
                EventLog.WriteEntry(_sourceName, message, EventLogEntryType.Error);
            }
            catch
            {
                // في حال فشل التسجيل (مثلاً لعدم وجود صلاحيات Administrator عند أول تشغيل)
                // نتجاهل الخطأ هنا حتى لا يتوقف التطبيق عن العمل
            }
        }
    }
}