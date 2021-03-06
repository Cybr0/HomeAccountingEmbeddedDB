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
using System.Windows.Shapes;
using System.Text.RegularExpressions;

namespace HomeAccounting
{
    /// <summary>
    /// Логика взаимодействия для ha_add_new_entry.xaml
    /// </summary>
    public partial class ha_add_new_entry : Window
    {
        //check non adding
        //если ничего не введено
        bool nonentering = true;

        //числовое значение Главной категории
        int rb_main_category = 2;

        //индекс для новой категории, если добавлена
        int newCategory = 0;


        //проверка на первую загрузку окна добавить
        bool rb_expense_Checked_first_load = false;

        ComboBoxViewModel model = new ComboBoxViewModel();

        public ha_add_new_entry()
        {
            InitializeComponent();
            
            DataContext = new ComboBoxViewModel();
            tb_data.SelectedDate = DateTime.Today;
        }

        public void SetContent(string content)
        {
            this.Content = content;
        }

        private void Window_Closed(object sender, EventArgs e)
        {
            (Application.Current as App).New_entries.Remove(this);
        }

        private void Close_window_Button_Click(object sender, RoutedEventArgs e)
        {
            //todo
            Visibility = Visibility.Collapsed;
        }




        //Adding data menu. Button "Add"
        private void btnAdd_Click(object sender, RoutedEventArgs e)
        {
            // подключение к бд(postgre) start
            string connection_string = @"Data Source=db\homeaccountingdb.db; Version=3";

            SQLiteConnection connection = new SQLiteConnection(connection_string);
            string sql;
            SQLiteCommand cmd;
            SQLiteDataReader reader;
            // подключение к бд(postgre) end


            //тут получаю данные для поля категории
            Dictionary<string, string> categories = new Dictionary<string, string>();

            try
            {
                connection.Open();

                sql = $"select id, name from NameCategory order by id;";
                cmd = new SQLiteCommand(sql, connection);
                reader = cmd.ExecuteReader();


                // тут загружаю категории в categories

                while (reader.Read())
                {
                    if (!categories.ContainsKey(reader[1].ToString()))
                    {
                        categories.Add(reader[1].ToString(), reader[0].ToString());
                        newCategory = Convert.ToInt32((reader[0].ToString()));
                    }
                    newCategory += 1;
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




            // тут проверка наличия категории, если нет то добавляем
            if (!(categories.ContainsKey(tb_new_category.Text)))
            {
                //MessageBox.Show(tb_new_category.Text + "start");
                try
                {
                    connection.Open();
                    //sql = $"select * from nameCategory_insert({rb_main_category}, '{tb_new_category.Text}');";
                    sql = $"insert into NameCategory(main_category, name) values({rb_main_category}, '{tb_new_category.Text}'); ";
                    SQLiteCommand cmd2 = new SQLiteCommand(sql, connection);
                    cmd2.ExecuteNonQuery();
                 //   MessageBox.Show(tb_new_category.Text + "end");

                }
                catch (Exception ex)
                {

                    MessageBox.Show(ex.Message);
                }
                finally
                {
                    connection.Close();
                 //   MessageBox.Show(tb_new_category.Text + "end");
                }
            }
            try
            {

                ////дата по умолчанию
                //if (tb_data.Text == "Дата")
                //{
                //    DateTime currentDate = DateTime.Today;
                //    tb_data.Text = currentDate.Date.ToString("dd-MM-yyyy");
                //}



                //проверка Суммы на корректность
                if (tb_sum.Text == "" || tb_sum.Text == "Сумма")
                {
                    tb_sum.Text = "0";
                }
                else if (rb_main_category == 2 && !(tb_sum.Text.StartsWith("-")))
                {
                    string tmpSum = "-" + tb_sum.Text;
                    tb_sum.Text = tmpSum;

                }


                //проверка Комментария по умолчанию
                if (tb_comment.Text == "Комментарий")
                {
                    tb_comment.Text = "";
                }





                connection.Open();
                DateTime dateTime = new DateTime();
                dateTime = tb_data.SelectedDate.Value;
                string dt = dateTime.ToString("yyyy-MM-dd");
                if (tb_new_category.Text == "Новая категория")
                {
                    //sql = $"select * from adding_new_date({rb_main_category}, {categories[tb_category.Text]}, to_date('{tb_data.SelectedDate.ToString()}','dd-mm-yyyy'), {tb_sum.Text}, '{tb_comment.Text}');";
                    sql = $"insert into Entry (main_category, name_category, date, cost, comment) values({rb_main_category}, {categories[tb_category.Text]}, '{tb_data.SelectedDate.Value.ToString("yyyy-MM-dd")}', {tb_sum.Text}, '{tb_comment.Text}');";
                }
                else
                {
                    //название категории в число
                    int tmp = categories.Count + 1;
                    //   MessageBox.Show(tmp.ToString());

                    if (categories.ContainsKey(tb_new_category.Text))
                    {
                        //sql = $"select * from adding_new_date({rb_main_category}, {newCategory.ToString()}, to_date('{tb_data.SelectedDate.ToString()}','dd-mm-yyyy'), {tb_sum.Text}, '{tb_comment.Text}');";
                        sql = $"insert into Entry (main_category, name_category, date, cost, comment) values({rb_main_category}, {categories[tb_new_category.Text]}, '{tb_data.SelectedDate.Value.ToString("yyyy-MM-dd")}', {tb_sum.Text}, '{tb_comment.Text}');";
                    }
                    else
                    {
                        sql = $"insert into Entry (main_category, name_category, date, cost, comment) values({rb_main_category}, {newCategory.ToString()}, '{tb_data.SelectedDate.Value.ToString("yyyy-MM-dd")}', {tb_sum.Text}, '{tb_comment.Text}');";

                    }
                }
                SQLiteCommand cmd3 = new SQLiteCommand(sql, connection);
                cmd3.ExecuteNonQuery();

            }
            catch (Exception ex)
            {
                if (ex.Message != "Данный ключ отсутствует в словаре.")
                    MessageBox.Show(ex.Message);
                else
                {
                    nonentering = false;
                }
            }
            finally
            {
                connection.Close();
                if (nonentering) 
                {
                MessageBox.Show("Запись добавлена");
                }
                else
                {
                    MessageBox.Show("Чтобы добавить запись, необходимо выбрать категорию!");
                }
                Visibility = Visibility.Collapsed;
            }



        }
        //-------------------------------------------------//





        //Adding data menu. RadioButtons "main category"
        private void rb_expense_Checked(object sender, RoutedEventArgs e)
        {
            rb_main_category = 2;
            
            if (rb_expense_Checked_first_load)
            {
                tb_category.ItemsSource = model.ExpenseCategoryNameCollection;
            }
            rb_expense_Checked_first_load = true;

            //tb_category.Text = "Другое";
            
        }
        private void rb_income_Checked(object sender, RoutedEventArgs e)
        {
            rb_main_category = 1;
            tb_category.ItemsSource = model.IncomeCategoryNameCollection;
        }


        //change category selectedItem
        private void rb_expense_Click(object sender, RoutedEventArgs e)
        {
            rb_main_category = 2;
            tb_category.SelectedItem = "Другое";
            tb_category.Text = "Другое";
        }

        private void rb_income_Click(object sender, RoutedEventArgs e)
        {
            rb_main_category = 1;
            tb_category.SelectedItem = "Другое";
            tb_category.Text = "Другое";
        }

        //-------------------------------------------------//


        //Adding data menu. Textbox "second category"
        private void tb_category_DropDownClosed(object sender, EventArgs e)
        {
            if (tb_category.Text == "Другое" || tb_category.Text == "Новая категория")
            {
                tb_new_category.IsReadOnly = false;
            }
            else
            {
                tb_new_category.Text = "Новая категория";
                tb_new_category.IsReadOnly = true;
            }
        }
        //-------------------------------------------------//


        //Adding data menu. Textbox "sum"
        private void tb_sum_PreviewMouseDown(object sender, MouseButtonEventArgs e)
        {
            if(tb_sum.Text == "Сумма")
            {
                tb_sum.Text = "";
            }
        }
        private void tb_sum_PreviewLostKeyboardFocus(object sender, KeyboardFocusChangedEventArgs e)
        {
            if (tb_sum.Text == "")
            {
                tb_sum.Text = "Сумма";
            }
        }
        private void NumberValidationTextBox(object sender, TextCompositionEventArgs e)
        {
            Regex regex = new Regex("[^0-9]+");
            e.Handled = regex.IsMatch(e.Text);
        }
        //-------------------------------------------------//



        //Adding data menu. Textbox "comment"
        private void tb_comment_PreviewMouseDown(object sender, MouseButtonEventArgs e)
        {
            if (tb_comment.Text == "Комментарий")
            {
                tb_comment.Text = "";
            }
        }
        private void tb_comment_PreviewLostKeyboardFocus(object sender, KeyboardFocusChangedEventArgs e)
        {
            if (tb_comment.Text == "")
            {
                tb_comment.Text = "Комментарий";
            }
        }
        //-------------------------------------------------//




        //Adding data menu. Textbox "new category"
        private void tb_new_category_PreviewMouseDown(object sender, MouseButtonEventArgs e)
        {
            if (tb_new_category.Text == "Новая категория")
            {
                if(tb_category.Text == "Другое" || tb_category.Text == "Новая категория")
                {
                    tb_new_category.Text = "";
                }
            }
        }

        private void tb_new_category_PreviewLostKeyboardFocus(object sender, KeyboardFocusChangedEventArgs e)
        {
            if (tb_new_category.Text == "")
            {
                if (tb_category.Text == "Другое" || tb_category.Text == "Новая категория")
                {
                    tb_new_category.Text = "Новая категория";
                }
            }
        }

        


        //-------------------------------------------------//



    }
}
