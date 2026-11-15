using System.Windows;

namespace VenueMasterPro
{
    public partial class MainWindow : Window
    {
        private bool isPasswordVisible = false;

        public MainWindow()
        {
            InitializeComponent();
        }

        // زر إغلاق التطبيق
        private void BtnClose_Click(object sender, RoutedEventArgs e)
        {
            Application.Current.Shutdown();
        }

        // زر إظهار/إخفاء كلمة المرور
        private void BtnShowPassword_Click(object sender, RoutedEventArgs e)
        {
            if (!isPasswordVisible)
            {
                // إظهار النص
                txtVisiblePassword.Text = txtPassword.Password;
                txtPassword.Visibility = Visibility.Collapsed;
                txtVisiblePassword.Visibility = Visibility.Visible;
                isPasswordVisible = true;
                btnShowPassword.Foreground = System.Windows.Media.Brushes.DodgerBlue;
            }
            else
            {
                // إخفاء النص (إعادة التشفير)
                txtPassword.Password = txtVisiblePassword.Text;
                txtVisiblePassword.Visibility = Visibility.Collapsed;
                txtPassword.Visibility = Visibility.Visible;
                isPasswordVisible = false;
                btnShowPassword.Foreground = System.Windows.Media.Brushes.Gray;
            }
        }

        // زر تسجيل الدخول
        private void BtnLogin_Click(object sender, RoutedEventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = isPasswordVisible ? txtVisiblePassword.Text.Trim() : txtPassword.Password.Trim();

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                MessageBox.Show("يرجى إدخال اسم المستخدم وكلمة المرور.", "تنبيه", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            MessageBox.Show($"مرحباً بك: {username}", "تسجيل الدخول", MessageBoxButton.OK, MessageBoxImage.Information);
        }
    }
}