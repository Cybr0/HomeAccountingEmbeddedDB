   M S B A M L   `   `   `  ���� I  EHomeAccounting, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null/clr-namespace:HomeAccountingHomeAccounting      HomeAccounting.MainWindow   R NWindowsBase, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35\ XPresentationFramework, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35W SPresentationCore, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35D 9http://schemas.microsoft.com/winfx/2006/xaml/presentation    R NSystem.Xaml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     @d2http://schemas.microsoft.com/expression/blend/2008     Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     .localclr-namespace:HomeAccounting     -     � Title$  Home Accounting��$	��600��$	��900��.��� ���	#FF24292E � ColumnDefinitions �� $	��100 ��� $	��100 ��� $	��100 ��� $	��100 ��� $	��100 ��� $	��100 ��� $	��100 ��� $
��100* � � RowDefinitions �� $	��100 ��� $	��100 ��� $	��100 ��� $	��100 ��� $	��100 ��� $	��100 �.+�&   System.Windows.Controls.DataGrid  -   $��dg��   ColumnWidth5  /System.Windows.Controls.DataGridLengthConverter$ *    AutoGenerateColumns . $
��Left=�$	��432��$��	0,0,40,58q�$��Bottom=�$	��650��$��1��$��2��$��6��$��5��   
IsReadOnly .    SelectionMode$ Single=�(� $
��Left=�$	��120��$��	34,66,0,0q�$	��Top=�$	��127��$��2��$��2��.��&   System.Windows.Controls.Calendar  -   $��tb_data��$	��158��$	��171���� -    ��Name$ 
btn_upload��$��Обновить��$
��Left=�$��
34,33,0,32q�$��4��$	��127��$��2�����	#FF0366D6���	#FF0758B2
������� J� OpacityMask
 �   ��� -   $��Удалить��$
��Left=�$��34,0,0,0q�$��5��$	��Top=�$	��127��$��2�����	#FFD22F3C
����������	#FF7C3139$��34���� -   $��Добавить��$��7��$
��Left=�$��	40,39,0,0q�$	��Top=�$	��110��$��45�����	#FF2EC350���	#FF236A37
��������� $��Данные записи��$
��Left=�$��	34,17,0,0q�$	��Top=�$��2��$	��129��{�.  
�������$��16(��� -   $��tb_category��$
��Left=�$��
34,35,0,39q�$	��127��$��2��$��2��	 J� RenderTransformOrigin$	 0.622,0.565&����� *CategoryNameCollection+�� -   
 ��Name$
 tb_sum��$��2��$
��Left=�$��23��$��	34,86,0,0q�$��2�� �� TextWrapping$
 Wrap=�$��
Сумма��$	��Top=�$	��127�����	#FF3F4448���	#FF8D9092 �� SelectionBrush �	#FF626769$��2���� -	   $
 
tb_comment��$��2��$
��Left=�$��63��$��	34,37,0,0q�$��3��$
 Wrap=�$��Комментарий��$	��Top=�$	��127�����	#FF3F4448���	#FF8D9092 �	#FF626769	� -
    	�Name$ 	rb_income��$��
Доход��$��1��$
��Left=�$��8,0,0,0q�$��2��$	��Top=�
�������$	 0.478,1.489&�	� -   $ 
rb_expense��$��Расход��$
��Left=�$��34,0,0,0q�$��2��$	��Top=�
�������$	 0.839,0.533&��� -   $��Статистика��$��5��$
��Left=�$��	84,39,0,0q�$	��Top=�$	��116��$��45��$��2��
����������	#FF9B9B9F�� $��Бухгалтерия��$��30(�$��Verdana)�
�������$��2��$
��Left=�$��0,20,0,0q�$	��Top=�$��3��$	��218��$��45���� -   $#��Обновить данные��$��2��$
��Left=�$��0,85,0,0q�$	��Top=�$	��110��$��2�����	#FF767676���	#FFABADB3
�������$��2��