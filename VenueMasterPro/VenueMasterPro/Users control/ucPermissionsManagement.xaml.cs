using System;
using System.Data;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using VenueMasterPro.BLL;

namespace VenueMasterPro
{
    public partial class ucPermissionsManagement : UserControl
    {
        private clsPermission _currentPermission = new clsPermission();
        private DataTable _dtAllPermissions;

        public ucPermissionsManagement()
        {
            InitializeComponent();
        }

        private void UserControl_Loaded(object sender, RoutedEventArgs e)
        {
            _LoadPermissionsData();
            _ResetForm();
        }

        private void _LoadPermissionsData()
        {
            try
            {
                bool onlyActive = chkOnlyActiveFilter.IsChecked == true;
                _dtAllPermissions = clsPermission.GetAllPermissions(onlyActive);
                dgvPermissions.ItemsSource = _dtAllPermissions.DefaultView;
                lblTotalCount.Text = $"إجمالي الصلاحيات: {_dtAllPermissions.Rows.Count}";
            }
            catch (Exception ex)
            {
                MessageBox.Show($"حدث خطأ أثناء تحميل البيانات:\n{ex.Message}", "خطأ", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void _ResetForm()
        {
            _currentPermission = new clsPermission();
            lblFormTitle.Text = "➕ إضافة صلاحية جديدة";
            lblPermissionID.Text = "[جديد]";
            txtPermissionName.Clear();
            txtPermissionCode.Clear();
            txtDescription.Clear();
            chkIsActive.IsChecked = true;
            btnSave.Content = "💾 حفظ البيانات";
            txtPermissionName.Focus();
        }

        private void _LoadPermissionForEdit(int permissionID)
        {
            clsPermission permission = clsPermission.Find(permissionID);
            if (permission == null)
            {
                MessageBox.Show("لم يتم العثور على الصلاحية المطلوبة!", "تنبيه", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            _currentPermission = permission;
            lblFormTitle.Text = "✏️ تعديل بيانات الصلاحية";
            lblPermissionID.Text = _currentPermission.PermissionID.ToString();
            txtPermissionName.Text = _currentPermission.PermissionName;
            txtPermissionCode.Text = _currentPermission.PermissionCode;
            txtDescription.Text = _currentPermission.Description;
            chkIsActive.IsChecked = _currentPermission.IsActive;
            btnSave.Content = "💾 تحديث البيانات";
        }

        private void BtnSave_Click(object sender, RoutedEventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtPermissionName.Text) || string.IsNullOrWhiteSpace(txtPermissionCode.Text))
            {
                MessageBox.Show("يرجى إدخال اسم الصلاحية والكود البرمجي.", "حقول مطلوبة", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            try
            {
                _currentPermission.PermissionName = txtPermissionName.Text.Trim();
                _currentPermission.PermissionCode = txtPermissionCode.Text.Trim().ToUpper();
                _currentPermission.Description = txtDescription.Text.Trim();
                _currentPermission.IsActive = chkIsActive.IsChecked == true;

                if (_currentPermission.Save())
                {
                    MessageBox.Show("تم حفظ بيانات الصلاحية بنجاح.", "نجاح", MessageBoxButton.OK, MessageBoxImage.Information);
                    _LoadPermissionsData();
                    _ResetForm();
                }
                else
                {
                    MessageBox.Show("تعذر حفظ البيانات، يرجى المحاولة مرة أخرى.", "خطأ", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "تنبيه من النظام", MessageBoxButton.OK, MessageBoxImage.Warning);
            }
        }

        private void BtnClear_Click(object sender, RoutedEventArgs e)
        {
            _ResetForm();
        }

        private void BtnGridEdit_Click(object sender, RoutedEventArgs e)
        {
            if (dgvPermissions.SelectedItem is DataRowView row)
            {
                int permissionID = Convert.ToInt32(row["PermissionID"]);
                _LoadPermissionForEdit(permissionID);
            }
        }

        private void DgvPermissions_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            // يمكنك تفعيل التحميل التلقائي عند النقر على الصف إذا رغبت
        }

        private void BtnGridDelete_Click(object sender, RoutedEventArgs e)
        {
            if (dgvPermissions.SelectedItem is DataRowView row)
            {
                int permissionID = Convert.ToInt32(row["PermissionID"]);
                string permissionName = row["PermissionName"].ToString();

                var result = MessageBox.Show(
                    $"هل أنت متأكد من حذف/تعطيل الصلاحية:\n({permissionName})؟",
                    "تأكيد الحذف",
                    MessageBoxButton.YesNo,
                    MessageBoxImage.Question);

                if (result == MessageBoxResult.Yes)
                {
                    try
                    {
                        if (clsPermission.DeletePermission(permissionID))
                        {
                            MessageBox.Show("تم تنفيذ العملية بنجاح.", "تم", MessageBoxButton.OK, MessageBoxImage.Information);
                            _LoadPermissionsData();
                            if (_currentPermission.PermissionID == permissionID)
                                _ResetForm();
                        }
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show($"خطأ أثناء الحذف:\n{ex.Message}", "خطأ", MessageBoxButton.OK, MessageBoxImage.Error);
                    }
                }
            }
        }

        private void TxtSearch_TextChanged(object sender, TextChangedEventArgs e)
        {
            if (_dtAllPermissions == null) return;

            string filterText = txtSearch.Text.Trim().Replace("'", "''");
            if (string.IsNullOrEmpty(filterText))
            {
                _dtAllPermissions.DefaultView.RowFilter = string.Empty;
            }
            else
            {
                _dtAllPermissions.DefaultView.RowFilter =
                    $"PermissionName LIKE '%{filterText}%' OR PermissionCode LIKE '%{filterText}%'";
            }
        }

        private void Filter_Changed(object sender, RoutedEventArgs e)
        {
            // لا تعِد تحميل البيانات إلا بعد اكتمال تحميل العنصر/النافذة في الشجرة البصرية
            if (IsLoaded)
                _LoadPermissionsData();
        }
    }
}