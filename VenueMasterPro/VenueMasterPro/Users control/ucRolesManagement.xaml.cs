using System;
using System.Collections.Generic;
using System.Data;
using System.Windows;
using System.Windows.Controls;
using VenueMasterPro.BLL;
using VenueMasterPro.DAL;

namespace VenueMasterPro
{
    public partial class ucRolesManagement : UserControl
    {
        private clsRole _currentRole = new clsRole();
        private DataTable _dtAllRoles;
        private DataTable _dtPermissionsMatrix;

        // مُنشئ الكنترول: يهيّئ عناصر واجهة XAML الأساسية فقط.
        public ucRolesManagement()
        {
            InitializeComponent();
        }

        // يُنفَّذ عند اكتمال تحميل الكنترول على الشاشة: يحمّل الأدوار ويضبط النموذج لوضع الإضافة.
        private void UserControl_Loaded(object sender, RoutedEventArgs e)
        {
            _LoadRolesData();
            _ResetForm();
        }

        // يجلب قائمة الأدوار (الكل أو النشطة فقط) ويعرضها في الجدول مع تحديث العداد.
        private void _LoadRolesData()
        {
            try
            {
                bool onlyActive = chkOnlyActiveRoles.IsChecked == true;
                _dtAllRoles = clsRole.GetAllRoles(onlyActive);
                dgvRoles.ItemsSource = _dtAllRoles?.DefaultView;
                lblTotalRolesCount.Text = $"إجمالي الأدوار: {_dtAllRoles?.DefaultView.Count ?? 0}";
            }
            catch (Exception ex)
            {
                clsEventLogger.LogError(ex, nameof(_LoadRolesData));
                MessageBox.Show($"حدث خطأ أثناء تحميل الأدوار:\n{ex.Message}", "خطأ", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        // يجلب مصفوفة الصلاحيات لدور معيّن (أو يفرغ التحديد عند roleID = -1) ويسمح بتعديل IsSelected.
        private void _LoadPermissionsMatrix(int roleID)
        {
            try
            {
                _dtPermissionsMatrix = clsRole.GetPermissionsMatrix(roleID);

                if (_dtPermissionsMatrix != null && _dtPermissionsMatrix.Columns.Contains("IsSelected"))
                {
                    _dtPermissionsMatrix.Columns["IsSelected"].ReadOnly = false;
                }

                lstPermissions.ItemsSource = _dtPermissionsMatrix?.DefaultView;
                _UpdateSelectedPermissionsCount();
            }
            catch (Exception ex)
            {
                clsEventLogger.LogError(ex, nameof(_LoadPermissionsMatrix));
                MessageBox.Show($"حدث خطأ أثناء تحميل قائمة الصلاحيات:\n{ex.Message}", "خطأ", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        // يحسب عدد الصلاحيات المؤشَّر عليها ويحدّث العداد وحالة مربع "تحديد الكل".
        private void _UpdateSelectedPermissionsCount()
        {
            if (_dtPermissionsMatrix == null)
            {
                lblSelectedPermissionsCount.Text = "المحددة: 0";
                chkSelectAllPermissions.IsChecked = false;
                return;
            }

            int selectedCount = 0;
            foreach (DataRow row in _dtPermissionsMatrix.Rows)
            {
                if (row["IsSelected"] != DBNull.Value && Convert.ToBoolean(row["IsSelected"]))
                    selectedCount++;
            }

            lblSelectedPermissionsCount.Text = $"المحددة: {selectedCount}";
            chkSelectAllPermissions.IsChecked = (_dtPermissionsMatrix.Rows.Count > 0 && selectedCount == _dtPermissionsMatrix.Rows.Count);
        }

        // يعيد تهيئة النموذج لحالة "إضافة دور جديد" ويمسح الحقول والبحث ويعيد تحميل الصلاحيات.
        private void _ResetForm()
        {
            _currentRole = new clsRole();
            lblFormTitle.Text = "➕ إضافة دور جديد";
            lblRoleID.Text = "[جديد]";
            txtRoleName.Clear();
            txtDescription.Clear();
            txtSearchPermissions.Clear();
            chkIsActive.IsChecked = true;
            btnSave.Content = "💾 حفظ البيانات";
            _LoadPermissionsMatrix(-1);
            txtRoleName.Focus();
        }

        // يجلب بيانات دور موجود للتعديل ويعبّئ الحقول ومصفوفة الصلاحيات الخاصة به.
        private void _LoadRoleForEdit(int roleID)
        {
            clsRole role = clsRole.Find(roleID);
            if (role == null)
            {
                MessageBox.Show("لم يتم العثور على الدور المطلوب!", "تنبيه", MessageBoxButton.OK, MessageBoxImage.Warning);
                _LoadRolesData();
                return;
            }

            _currentRole = role;
            lblFormTitle.Text = "✏️ تعديل بيانات الدور";
            lblRoleID.Text = _currentRole.RoleID.ToString();
            txtRoleName.Text = _currentRole.RoleName;
            txtDescription.Text = _currentRole.Description;
            chkIsActive.IsChecked = _currentRole.IsActive;
            btnSave.Content = "💾 تحديث البيانات";

            _LoadPermissionsMatrix(_currentRole.RoleID);
            txtRoleName.Focus();
        }

        // يستخرج صف البيانات (DataRowView) المرتبط بالزر المضغوط داخل الجدول ويحدده في الجدول.
        private DataRowView _GetRowFromButton(object sender)
        {
            if (sender is FrameworkElement element && element.DataContext is DataRowView rowView)
            {
                dgvRoles.SelectedItem = rowView;
                return rowView;
            }

            return dgvRoles.SelectedItem as DataRowView;
        }

        // يجمع أرقام (PermissionID) لجميع الصلاحيات المحددة في قائمة (List<int>).
        private List<int> _GetSelectedPermissionIDs()
        {
            List<int> selectedIds = new List<int>();
            if (_dtPermissionsMatrix == null)
                return selectedIds;

            foreach (DataRow row in _dtPermissionsMatrix.Rows)
            {
                if (row["IsSelected"] != DBNull.Value && Convert.ToBoolean(row["IsSelected"]))
                {
                    selectedIds.Add(Convert.ToInt32(row["PermissionID"]));
                }
            }
            return selectedIds;
        }

        // يتحقق من إدخال اسم الدور ثم يحفظ الدور وصلاحياته المحددة ويحدّث الجدول ويعيد ضبط النموذج.
        private void BtnSave_Click(object sender, RoutedEventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtRoleName.Text))
            {
                MessageBox.Show("يرجى إدخال اسم الدور الوظيفي.", "حقل مطلوب", MessageBoxButton.OK, MessageBoxImage.Warning);
                txtRoleName.Focus();
                return;
            }

            try
            {
                _currentRole.RoleName = txtRoleName.Text.Trim();
                _currentRole.Description = txtDescription.Text.Trim();
                _currentRole.IsActive = chkIsActive.IsChecked == true;

                List<int> selectedPermissions = _GetSelectedPermissionIDs();

                if (_currentRole.SaveWithPermissions(selectedPermissions))
                {
                    MessageBox.Show("تم حفظ الدور الوظيفي وصلاحياته بنجاح.", "نجاح", MessageBoxButton.OK, MessageBoxImage.Information);
                    _LoadRolesData();
                    _ResetForm();
                }
                else
                {
                    MessageBox.Show("تعذر حفظ البيانات، يرجى المحاولة مرة أخرى.", "خطأ", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
            catch (Exception ex)
            {
                clsEventLogger.LogError(ex, nameof(BtnSave_Click));
                MessageBox.Show(ex.Message, "تنبيه من النظام", MessageBoxButton.OK, MessageBoxImage.Warning);
            }
        }

        // يعيد تعيين النموذج عند الضغط على زر المسح/الإلغاء.
        private void BtnClear_Click(object sender, RoutedEventArgs e)
        {
            _ResetForm();
        }

        // يبدأ عملية تعديل الدور المختار من صف الجدول.
        private void BtnGridEdit_Click(object sender, RoutedEventArgs e)
        {
            e.Handled = true;
            DataRowView row = _GetRowFromButton(sender);
            if (row == null)
            {
                MessageBox.Show("تعذر تحديد الصف المطلوب تعديله.", "تنبيه", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            try
            {
                int roleID = Convert.ToInt32(row["RoleID"]);
                _LoadRoleForEdit(roleID);
            }
            catch (Exception ex)
            {
                clsEventLogger.LogError(ex, nameof(BtnGridEdit_Click));
                MessageBox.Show($"حدث خطأ أثناء تحميل بيانات التعديل:\n{ex.Message}", "خطأ", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        // يطلب تأكيد المستخدم ثم يحذف أو يعطّل الدور المختار من الجدول ويحدّث الواجهة.
        private void BtnGridDelete_Click(object sender, RoutedEventArgs e)
        {
            e.Handled = true;
            DataRowView row = _GetRowFromButton(sender);
            if (row == null)
            {
                MessageBox.Show("تعذر تحديد الصف المطلوب حذفه.", "تنبيه", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            int roleID = Convert.ToInt32(row["RoleID"]);
            string roleName = row["RoleName"]?.ToString() ?? string.Empty;

            var result = MessageBox.Show(
                $"هل أنت متأكد من حذف/تعطيل الدور الوظيفي:\n({roleName})؟",
                "تأكيد الحذف",
                MessageBoxButton.YesNo,
                MessageBoxImage.Question);

            if (result != MessageBoxResult.Yes)
                return;

            try
            {
                if (clsRole.DeleteRole(roleID))
                {
                    MessageBox.Show("تم تنفيذ العملية بنجاح.", "تم", MessageBoxButton.OK, MessageBoxImage.Information);
                    _LoadRolesData();
                    if (_currentRole != null && _currentRole.RoleID == roleID)
                        _ResetForm();
                }
                else
                {
                    MessageBox.Show(
                        "تعذر حذف أو تعطيل الدور. تأكد من عدم ارتباطه بمستخدمين أو راجع الإجراء المخزن في قاعدة البيانات.",
                        "تنبيه",
                        MessageBoxButton.OK,
                        MessageBoxImage.Warning);
                }
            }
            catch (Exception ex)
            {
                clsEventLogger.LogError(ex, nameof(BtnGridDelete_Click));
                MessageBox.Show($"خطأ أثناء الحذف:\n{ex.Message}", "خطأ", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        // يحدّد أو يلغي تحديد جميع الصلاحيات الظاهرة حالياً في القائمة ثم يحدّث العداد.
        private void ChkSelectAllPermissions_Click(object sender, RoutedEventArgs e)
        {
            if (_dtPermissionsMatrix == null) return;

            bool isChecked = chkSelectAllPermissions.IsChecked == true;
            foreach (DataRowView rowView in _dtPermissionsMatrix.DefaultView)
            {
                rowView["IsSelected"] = isChecked;
            }
            _UpdateSelectedPermissionsCount();
        }

        // يحدّث عداد الصلاحيات المحددة وحالة "تحديد الكل" عند تأشير أو إلغاء أي صلاحية.
        private void PermissionCheckBox_Click(object sender, RoutedEventArgs e)
        {
            _UpdateSelectedPermissionsCount();
        }

        // يفلتر قائمة الصلاحيات في الذاكرة حسب الاسم أو الكود أثناء الكتابة.
        private void TxtSearchPermissions_TextChanged(object sender, TextChangedEventArgs e)
        {
            if (_dtPermissionsMatrix == null)
                return;

            string filter = txtSearchPermissions.Text.Trim().Replace("'", "''");
            _dtPermissionsMatrix.DefaultView.RowFilter = string.IsNullOrEmpty(filter)
                ? string.Empty
                : $"PermissionName LIKE '%{filter}%' OR PermissionCode LIKE '%{filter}%'";
        }

        // يفلتر جدول الأدوار في الذاكرة حسب اسم الدور أثناء الكتابة ويحدّث عداد النتائج.
        private void TxtSearchRoles_TextChanged(object sender, TextChangedEventArgs e)
        {
            if (_dtAllRoles == null) return;

            string filter = txtSearchRoles.Text.Trim().Replace("'", "''");
            _dtAllRoles.DefaultView.RowFilter = string.IsNullOrEmpty(filter)
                ? string.Empty
                : $"RoleName LIKE '%{filter}%'";

            lblTotalRolesCount.Text = $"إجمالي الأدوار: {_dtAllRoles.DefaultView.Count}";
        }

        // يعيد تحميل قائمة الأدوار عند تغيير خيار الفلترة بعد اكتمال تحميل الكنترول.
        private void FilterRoles_Changed(object sender, RoutedEventArgs e)
        {
            if (IsLoaded)
                _LoadRolesData();
        }

       
    }
}