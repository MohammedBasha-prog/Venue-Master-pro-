//using System.Windows;
//using System.Windows.Input;

//namespace VenueMasterPro
//{
//    public partial class MainDashboard : Window
//    {
//        // متغير وهمي لتحديد الصلاحيات (يمكن ربطه بقاعدة البيانات لاحقاً)
//        // إذا كان true سيظهر خيار "إضافة حساب"، وإذا كان false سيختفي
//        private bool isAdmin = true;
//        private bool isAccountMenuOpen = false;

//        public MainDashboard()
//        {
//            InitializeComponent();
//            CheckUserRole();
//        }

//        // فحص صلاحيات المستخدم وإخفاء/إظهار زر إضافة حساب
//        private void CheckUserRole()
//        {
//            if (isAdmin)
//            {
//                btnAddAccount.Visibility = Visibility.Visible;
//            }
//            else
//            {
//                btnAddAccount.Visibility = Visibility.Collapsed;
//            }
//        }

//        // زر فتح وإغلاق قائمة الحسابات المنسدلة
//        private void BtnAccountMenu_Click(object sender, RoutedEventArgs e)
//        {
//            if (isAccountMenuOpen)
//            {
//                pnlAccountSubMenu.Visibility = Visibility.Collapsed;
//                isAccountMenuOpen = false;
//            }
//            else
//            {
//                pnlAccountSubMenu.Visibility = Visibility.Visible;
//                isAccountMenuOpen = true;
//            }
//        }

//        // حدث إضافة حساب جديد (خاص بالمدير)
//        private void BtnAddAccount_Click(object sender, RoutedEventArgs e)
//        {
//            MessageBox.Show("فتح شاشة إضافة حساب جديد...", "إدارة الحسابات", MessageBoxButton.OK, MessageBoxImage.Information);
//        }

//        // حدث تعديل الحساب الحالي
//        private void BtnEditAccount_Click(object sender, RoutedEventArgs e)
//        {
//            MessageBox.Show("فتح شاشة تعديل بيانات الحساب...", "إدارة الحسابات", MessageBoxButton.OK, MessageBoxImage.Information);
//        }

//        // زر تحريك النافذة
//        private void HeaderGrid_MouseDown(object sender, MouseButtonEventArgs e)
//        {
//            if (e.LeftButton == MouseButtonState.Pressed)
//            {
//                DragMove();
//            }
//        }

//        // زر تصغير النافذة
//        private void BtnMinimize_Click(object sender, RoutedEventArgs e)
//        {
//            WindowState = WindowState.Minimized;
//        }

//        // زر إغلاق التطبيق
//        private void BtnClose_Click(object sender, RoutedEventArgs e)
//        {
//            Application.Current.Shutdown();
//        }

//        // زر تسجيل الخروج (يعيد فتح شاشة تسجيل الدخول)
//        private void BtnLogout_Click(object sender, RoutedEventArgs e)
//        {
//            MainWindow loginWindow = new MainWindow();
//            loginWindow.Show();
//            this.Close();
//        }
//    }
//}



using System.Windows;
using System.Windows.Input;
using System.Windows.Media;

namespace VenueMasterPro
{
    public partial class MainDashboard : Window
    {
        private bool isAdmin = true;
        private bool isAccountMenuOpen = false;

        public MainDashboard()
        {
            InitializeComponent();
            CheckUserRole();

            // 1. جعل لوحة التحكم تفتح تلقائياً فور تشغيل النظام
            LoadDefaultDashboard();
        }

        private void LoadDefaultDashboard()
        {
            // عرض UserControl الخاص بلوحة التحكم في مساحة العرض الرئيسية
            MainContentArea.Content = new DashboardView();

            // تحديد زر لوحة التحكم بصرياً كزر مفعل حالياً (Active)
            HighlightActiveButton(btnDashboard);
        }

        // دالة لتغيير لون الزر النشط ليعلم المستخدم أنه في هذه الصفحة
        private System.Windows.Controls.Button currentActiveButton = null;
        private void HighlightActiveButton(System.Windows.Controls.Button clickedButton)
        {
            // إعادة الزر السابق إلى وضعه العادي إن وجد
            if (currentActiveButton != null)
            {
                currentActiveButton.Background = Brushes.Transparent;
                currentActiveButton.Foreground = (Brush)new BrushConverter().ConvertFrom("#FF94A3B8");
            }

            // تمييز الزر الحالي
            currentActiveButton = clickedButton;
            if (currentActiveButton != null)
            {
                currentActiveButton.Background = (Brush)new BrushConverter().ConvertFrom("#FF1E293B");
                currentActiveButton.Foreground = Brushes.White;
            }
        }

        // عند الضغط على زر "لوحة التحكم" من القائمة الجانبية
        private void BtnDashboard_Click(object sender, RoutedEventArgs e)
        {
            MainContentArea.Content = new DashboardView();
            HighlightActiveButton(sender as System.Windows.Controls.Button);
        }

        // عند الضغط على زر "إدارة الحجوزات"
        private void BtnReservations_Click(object sender, RoutedEventArgs e)
        {
            // MainContentArea.Content = new ReservationsView(); // ضع صفحة الحجوزات لاحقاً هنا
            HighlightActiveButton(sender as System.Windows.Controls.Button);
        }

        // ... وباقي أحداث الأزرار بنفس الطريقة ...

        // دالة فتح وإغلاق قائمة الحسابات
        private void BtnAccountMenu_Click(object sender, RoutedEventArgs e)
        {
            pnlAccountSubMenu.Visibility = (pnlAccountSubMenu.Visibility == Visibility.Visible) ? Visibility.Collapsed : Visibility.Visible;
            //isAccountMenuOpen = !isAccountMenuOpen;
        }

        private void CheckUserRole()
        {
            if (btnAddAccount != null)
                btnAddAccount.Visibility = isAdmin ? Visibility.Visible : Visibility.Collapsed;
        }

        private void BtnAddAccount_Click(object sender, RoutedEventArgs e) => MessageBox.Show("إضافة حساب جديد");
        private void BtnEditAccount_Click(object sender, RoutedEventArgs e) => MessageBox.Show("تعديل الحساب");
        private void HeaderGrid_MouseDown(object sender, MouseButtonEventArgs e) { if (e.LeftButton == MouseButtonState.Pressed) DragMove(); }
        private void BtnMinimize_Click(object sender, RoutedEventArgs e) => WindowState = WindowState.Minimized;
        private void BtnClose_Click(object sender, RoutedEventArgs e) => Application.Current.Shutdown();
        private void BtnLogout_Click(object sender, RoutedEventArgs e) { new MainWindow().Show(); this.Close(); }
    }
}