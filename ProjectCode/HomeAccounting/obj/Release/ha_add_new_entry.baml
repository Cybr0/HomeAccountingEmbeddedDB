   M S B A M L   `   `   `  ���� I  EHomeAccounting, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null/clr-namespace:HomeAccountingHomeAccounting  %    HomeAccounting.ha_add_new_entry   R NWindowsBase, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35\ XPresentationFramework, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35W SPresentationCore, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35D 9http://schemas.microsoft.com/winfx/2006/xaml/presentation    R NSystem.Xaml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     @d2http://schemas.microsoft.com/expression/blend/2008     Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     .localclr-namespace:HomeAccounting     -     � Title$/  )Добавить новую запись.��$	��660��$	��200��.��� ���	#FF24292E$��	0,-24,0,0q�.+��� $��Данные записи��$
��Left=�$��	30,31,0,0q�$	��Top=�$	��129��{�.  
�������$��16(�(� $
��Left=�$	��120��$��	30,87,0,0q�$	��Top=�$	��127��.��&   System.Windows.Controls.Calendar  -   $��tb_data��$	��176��$	��186��	� -    	�Name$ 
rb_expense��$��Расход��$
��Left=�$��
30,233,0,0q�$	��Top=�
������� J� RenderTransformOrigin$ 0.839,0.533&� � Cursor$
 Hand�� d� 	IsChecked$
 TrueY�	� -   $ 	rb_income��$��
Доход��$
��Left=�$��104,233,0,0q�$	��Top=�
�������$
 Hand��$ 	0.528,0.2&��� -    ��Name$ tb_sum��$
��Left=�$��31��$��
30,367,0,0q� �� TextWrapping$
 Wrap=�$��
Сумма��$	��Top=�$	��127�����	#FF3F4448���	#FF8D9092 �� SelectionBrush �	#FF626769�� -   $ 
tb_comment��$
��Left=�$��67��$��
30,416,0,0q�$
 Wrap=�$��Комментарий��$	��Top=�$	��127�����	#FF3F4448���	#FF8D9092 �	#FF626769�� -   $��btnAdd��$��Добавить��$
��Left=�$��
30,512,0,0q�$	��Top=�$	��127��$��45�����	#FF2EC350���	#FF236A37
��������� -   $��btnEsc��$��Отмена��$
��Left=�$��
30,576,0,0q�$	��Top=�$	��127��$��41��
����������	#FF9B9B9F�� -	   $��tb_category��$
��Left=�$��30,265,0,352q�$	��127������ *ExpenseCategoryNameCollection+�� $
��Left=�$��
65,212,0,0q�$
��Wrap=�$��Категории��$	��Top=����	#FF24292E
�������$ 	0.509,1.5&��� -
   $ tb_new_category�� �� 
IsReadOnly . $
��Left=�$��30��$��
30,319,0,0q�$
 Wrap=�$#��Новая категория��$	��Top=�$	��127�����	#FF3F4448���	#FF8D9092 �	#FF626769