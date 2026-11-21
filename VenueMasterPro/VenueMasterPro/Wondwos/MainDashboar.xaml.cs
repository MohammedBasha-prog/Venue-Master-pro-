using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;

namespace VenueMasterPro
{
    public partial class MainDashboard : Window
    {
        private bool isAdmin = true;
        private Button _currentActiveButton = null;

        public MainDashboard()
        {
            InitializeComponent();
            CheckUserRole();
            LoadDefaultDashboard();
        }

        private void LoadDefaultDashboard()
        {
            MainContentArea.Content = new DashboardView();
            HighlightActiveButton(btnDashboard);
        }

        private void HighlightActiveButton(Button clickedButton)
        {
            var brushConverter = new BrushConverter();

            if (_currentActiveButton != null)
            {
                _currentActiveButton.ClearValue(BackgroundProperty);
                _currentActiveButton.ClearValue(ForegroundProperty);
            }

            _currentActiveButton = clickedButton;
            if (_currentActiveButton != null)
            {
                _currentActiveButton.Background = (Brush)brushConverter.ConvertFrom("#FFDBEAFE");
                _currentActiveButton.Foreground = (Brush)brushConverter.ConvertFrom("#FF1E3A8A");
            }
        }

        private void btnDashboard_Click_1(object sender, RoutedEventArgs e)
        {
            BtnDashboard_Click(sender, e);
        }

        private void BtnDashboard_Click(object sender, RoutedEventArgs e)
        {
            MainContentArea.Content = new DashboardView();
            HighlightActiveButton(btnDashboard);
        }

        private void BtnReservations_Click(object sender, RoutedEventArgs e)
        {
            // MainContentArea.Content = new ReservationsView();
            HighlightActiveButton(sender as Button);
        }

        private void BtnSettingsMenu_Click(object sender, RoutedEventArgs e)
        {
            if (pnlSettingsSubMenu.Visibility == Visibility.Collapsed)
            {
                pnlSettingsSubMenu.Visibility = Visibility.Visible;
                txtSettingsArrow.Text = "▲";
            }
            else
            {
                pnlSettingsSubMenu.Visibility = Visibility.Collapsed;
                txtSettingsArrow.Text = "▼";
            }
        }

        private void BtnAccountMenu_Click(object sender, RoutedEventArgs e)
        {
            if (pnlAccountSubMenu.Visibility == Visibility.Collapsed)
            {
                pnlAccountSubMenu.Visibility = Visibility.Visible;
                txtArrow.Text = "▲";
            }
            else
            {
                pnlAccountSubMenu.Visibility = Visibility.Collapsed;
                txtArrow.Text = "▼";
            }
        }

        private void CheckUserRole()
        {
            if (btnAddUser != null)
                btnAddUser.Visibility = isAdmin ? Visibility.Visible : Visibility.Collapsed;
        }

        private void BtnPermissions_Click(object sender, RoutedEventArgs e)
        {
            MainContentArea.Content = new ucPermissionsManagement();
            HighlightActiveButton(btnPermissions);
        }

        private void BtnRoles_Click(object sender, RoutedEventArgs e)
        {
            MainContentArea.Content = new ucRolesManagement();
            HighlightActiveButton(btnRoles);
        }

        private void BtnAddAccount_Click(object sender, RoutedEventArgs e)
            => MessageBox.Show("فتح شاشة إضافة مستخدم جديد...", "إعدادات النظام", MessageBoxButton.OK, MessageBoxImage.Information);

        private void BtnEditAccount_Click(object sender, RoutedEventArgs e)
            => MessageBox.Show("تعديل الحساب", "إدارة الحساب", MessageBoxButton.OK, MessageBoxImage.Information);

        private void HeaderGrid_MouseDown(object sender, MouseButtonEventArgs e)
        {
            if (e.LeftButton == MouseButtonState.Pressed)
                DragMove();
        }

        private void BtnMinimize_Click(object sender, RoutedEventArgs e)
            => WindowState = WindowState.Minimized;

        private void BtnClose_Click(object sender, RoutedEventArgs e)
            => Application.Current.Shutdown();

        private void BtnLogout_Click(object sender, RoutedEventArgs e)
        {
            new MainWindow().Show();
            this.Close();
        }


        ////////////////////
        
       
    }
}