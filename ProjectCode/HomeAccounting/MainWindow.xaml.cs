﻿using System.Data.SQLite;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Data;
using System.Text.RegularExpressions;
using System.Windows.Controls.Primitives;

namespace HomeAccounting
{
    /// <summary>
    /// Логика взаимодействия для MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        int rb_expense_income_check = 2;
        ComboBoxViewModel model;


        private string connection_string;
        private SQLiteConnection connection;
        private string sql;
        private SQLiteCommand cmd;
        private DataTable dt;
        private int selectedRowId;



        public MainWindow()
        {

            connection_string = @"Data Source=db\homeaccountingdb.db; Version=3";
            InitializeComponent();

            tb_data.SelectedDate = DateTime.Today;

            model = new ComboBoxViewModel();
            DataContext = new ComboBoxViewModel();
        }
        private void MyWindow_Loaded(object sender, RoutedEventArgs e)
        {
            connection = new SQLiteConnection(connection_string);
            Select();
        }

        private void Select()
        {
            model = new ComboBoxViewModel();

            try
            {
                connection.Open();
                //sql = "select to_char(Дата,'dd-mm-yyyy') as \"Дата\", \"Основная категория\", Категория, Стоимость, Комментарий, id from mainSelect()";

                sql = "select strftime('%d-%m-%Y',e.date) as \"Дата\", m.name as \"Основная категория\",n.name as Категория, ABS(e.cost) as Стоимость, e.comment as Комментарий, e.id as id from Entry as e " +
                    " left join NameCategory as n " +
                    " on e.name_category = n.id " +
                    " left join MainCategory as m " +
                    " on e.main_category = m.id " +
                    " order by e.date; ";

                cmd = new SQLiteCommand(sql, connection);
                cmd.ExecuteNonQuery();

                SQLiteDataAdapter dataAdapter = new SQLiteDataAdapter(cmd);

                dt = new DataTable("mainSelect()");
                dataAdapter.Fill(dt);
                dg.ItemsSource = dt.DefaultView;
                connection.Close();


            }
            catch (Exception ex)
            {

                connection.Close();
            }

        }

        
        

        private void dg_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            System.Data.DataRowView row = (System.Data.DataRowView)dg.SelectedItems[0];
            selectedRowId = Convert.ToInt32(row["id"]);
            tb_data.SelectedDate = DateTime.Parse((string)row["Дата"]);
            tb_data.DisplayDate = DateTime.Parse((string)row["Дата"]);
            tb_category.Text = (string)row["Категория"];
            tb_category.SelectedItem = (string)row["Категория"];
            string rb_check_income_or_expense = (string)row["Основная категория"];
            if (rb_check_income_or_expense == "Доход")
            {
                //MessageBox.Show(rb_income.Content.ToString());
                rb_income.IsChecked = true;
            }
            else if (rb_check_income_or_expense == "Расход")
            {
                rb_expense.IsChecked = true;
            }
            decimal tmp_sum = Convert.ToDecimal(row["Стоимость"]);
            tb_sum.Text = tmp_sum.ToString();
            tb_comment.Text = (string)row["Комментарий"];
        }


        private void Button_Click(object sender, RoutedEventArgs e)
        {
            ha_statistics statistics = new ha_statistics();
            statistics.Owner = this;
            statistics.Show();
            (Application.Current as App).Statistics.Add(statistics);
        }

        private void Button_Click_1(object sender, RoutedEventArgs e)
        {
            ha_add_new_entry new_entry = new ha_add_new_entry();
            new_entry.Owner = this;
            new_entry.Show();
            (Application.Current as App).New_entries.Add(new_entry);
        }

        private void Delete_Data_Button_Click(object sender, RoutedEventArgs e)
        {
            // подключение к бд(postgre)


            try
            {
                //System.Data.DataRowView row = (System.Data.DataRowView)dg.SelectedItems[0];

                connection.Open();
                SQLiteCommand cmdTmp;
                string sql = $"delete from Entry where id = {selectedRowId.ToString()}";
                cmdTmp = new SQLiteCommand(sql, connection);
                cmdTmp.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                //MessageBox.Show(ex.Message);

            }
            finally
            {
                connection.Close();
            }

            if(selectedRowId == 0)
            {
                MessageBox.Show("Вы не выбрали запись.");
            }
            else
            {
                MessageBox.Show("Запись удалена");
            }
            
            Select();

        }

        private void Upload_Data_Button_Click(object sender, RoutedEventArgs e)
        {


            //тут получаю данные для поля категории
            Dictionary<string, string> categories = new Dictionary<string, string>();

            try
            {
                connection.Open();

                sql = $"select id, name from NameCategory;";
                cmd = new SQLiteCommand(sql, connection);
                SQLiteDataReader reader = cmd.ExecuteReader();


                // тут загружаю категории в categories

                while (reader.Read())
                {
                    if (!categories.ContainsKey(reader[1].ToString()))
                    {
                        categories.Add(reader[1].ToString(), reader[0].ToString());
                    }

                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);

            }
            finally
            {
                connection.Close();
            }


            // Update к бд(postgre)

            try
            {
                //System.Data.DataRowView row = (System.Data.DataRowView)dg.SelectedItems[0];

                connection.Open();
                SQLiteCommand cmdTmp;

                //проверка колонки деньги на минус
                //проверка Суммы на корректность
                if (tb_sum.Text == "" || tb_sum.Text == "Сумма")
                {
                    tb_sum.Text = "0";
                }
                else if (rb_expense_income_check == 2 && !(tb_sum.Text.StartsWith("-")))
                {
                    string tmpSum = "-" + tb_sum.Text;
                    tb_sum.Text = tmpSum;

                }
                else if (rb_expense_income_check == 1 && tb_sum.Text.StartsWith("-"))
                {
                    string tmpSum = tb_sum.Text.Substring(1);
                    tb_sum.Text = tmpSum;
                }
                //TODO: check this moment
                // string sql = $"update Entry set main_category = {rb_expense_income_check.ToString()}, name_category = {categories[tb_category.Text]}, date = to_date('{tb_data.SelectedDate}', 'dd-mm-yyyy'), cost = {tb_sum.Text}, comment = '{tb_comment.Text}' where id = {selectedRowId.ToString()};";
                //DateTime dateTime = new DateTime();
                //dateTime = tb_data.SelectedDate.Value;
                //string dt = dateTime.ToString("d-MM-yyyy");
                //dt = dateTime.ToString("yyyy-MM-d");
                string sql = $"update Entry set main_category = {rb_expense_income_check.ToString()}, name_category = {categories[tb_category.Text]}, date = '{tb_data.SelectedDate.Value.ToString("yyyy-MM-dd")}', cost = {tb_sum.Text}, comment = '{tb_comment.Text}' where id = {selectedRowId.ToString()};";
                
                cmdTmp = new SQLiteCommand(sql, connection);
                cmdTmp.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                
                //MessageBox.Show(ex.Message);

            }
            finally
            {
                connection.Close();
            }

            if(selectedRowId == 0)
            {
                MessageBox.Show("Вы не выбрали запись.");
            }
            else
            {
                MessageBox.Show("Запись Обновлена");
            }
            Select();

        }

        

        private void rb_expense_Checked(object sender, RoutedEventArgs e)
        {
            rb_expense_income_check = 2;
        }

        private void rb_income_Checked(object sender, RoutedEventArgs e)
        {
            rb_expense_income_check = 1;
        }

        private void reload_Data_Button_Click(object sender, RoutedEventArgs e)
        {
            Select();
        }


        private void NumberValidationTextBox(object sender, TextCompositionEventArgs e)
        {
            Regex regex = new Regex("[^0-9]+");
            e.Handled = regex.IsMatch(e.Text);
        }

        private void rb_expense_Checked_1(object sender, RoutedEventArgs e)
        {
            //tb_category.SetBinding(Selector.SelectedItemProperty,
            //  new Binding("ExpenseCategoryNameCollection") { Source = new ComboBoxViewModel().ExpenseCategoryNameCollection });
            tb_category.ItemsSource = model.ExpenseCategoryNameCollection;
        }

        private void rb_income_Checked_1(object sender, RoutedEventArgs e)
        {
            //tb_category.SetBinding(Selector.SelectedItemProperty,
            //  new Binding("IncomeCategoryNameCollection") { Source = new ComboBoxViewModel().incomeCategoryNameForComboBox });

            tb_category.ItemsSource = model.IncomeCategoryNameCollection;
        }

        private void rb_expense_Click(object sender, RoutedEventArgs e)
        {
            rb_expense_income_check = 2;
            tb_category.SelectedItem = "Другое";
            tb_category.Text = "Другое";
        }

        private void rb_income_Click(object sender, RoutedEventArgs e)
        {
            rb_expense_income_check = 1;
            tb_category.SelectedItem = "Другое";
            tb_category.Text = "Другое";
        }
    }
}
