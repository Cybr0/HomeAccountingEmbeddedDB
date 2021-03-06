PGDMP     "                    x            homeaccountingtest    12.3    12.3 #    =           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            >           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            ?           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            @           1262    16523    homeaccountingtest    DATABASE     �   CREATE DATABASE homeaccountingtest WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'English_United States.1252' LC_CTYPE = 'English_United States.1252';
 "   DROP DATABASE homeaccountingtest;
                homeaccountingUser    false                        2615    16534    homeaccounting    SCHEMA        CREATE SCHEMA homeaccounting;
    DROP SCHEMA homeaccounting;
                postgres    false                        3079    16788 	   tablefunc 	   EXTENSION     =   CREATE EXTENSION IF NOT EXISTS tablefunc WITH SCHEMA public;
    DROP EXTENSION tablefunc;
                   false            A           0    0    EXTENSION tablefunc    COMMENT     `   COMMENT ON EXTENSION tablefunc IS 'functions that manipulate whole tables, including crosstab';
                        false    2            �            1255    16835 C   adding_new_date(integer, integer, date, numeric, character varying)    FUNCTION     �  CREATE FUNCTION public.adding_new_date(_main_category integer, _name_category integer, _date date, _cost numeric, _comment character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	insert into homeAccounting.Entry(main_category, name_category, date, cost, comment)
	values(_main_category, _name_category, _date, _cost, _comment);
	if found then --inserted successfully
		return 1;
	else return 0; --inserted fail
	end if;
end
$$;
 �   DROP FUNCTION public.adding_new_date(_main_category integer, _name_category integer, _date date, _cost numeric, _comment character varying);
       public          postgres    false            �            1255    16832    mainselect()    FUNCTION     ,  CREATE FUNCTION public.mainselect() RETURNS TABLE(id integer, "Основная категория" character varying, "Категория" character varying, "Дата" date, "Стоимость" numeric, "Комментарий" character varying)
    LANGUAGE plpgsql
    AS $$
begin
	return query
	select e.id, m.name, n.name, e.date, e.cost, e.comment from homeAccounting.Entry as e
	left join homeAccounting.NameCategory as n
	on e.name_category = n.id
	left join homeAccounting.MainCategory as m
	on e.main_category = m.id
	order by e.date;
end
$$;
 #   DROP FUNCTION public.mainselect();
       public          postgres    false            �            1255    16834 /   namecategory_insert(integer, character varying)    FUNCTION     T  CREATE FUNCTION public.namecategory_insert(_main_category integer, _name character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	insert into homeAccounting.NameCategory(main_category, name) 
	values(_main_category, _name);
	if found then --inserted successfully
		return 1;
	else return 0; --inserted fail
	end if;
end
$$;
 [   DROP FUNCTION public.namecategory_insert(_main_category integer, _name character varying);
       public          postgres    false            �            1255    16811    test_select(integer, integer)    FUNCTION     �  CREATE FUNCTION public.test_select(_month integer, _year integer) RETURNS TABLE(c_entry character varying, c_total numeric)
    LANGUAGE plpgsql
    AS $$
begin
	return query
	select distinct(n.name) as Месяц, sum(e.cost) as "Итоговая стоимость" from homeAccounting.Entry as e
	left join homeAccounting.NameCategory as n
	on e.name_category = n.id
	where Extract(month from e.date::date ) = _month and (Extract(year from e.date::date ) = _year)
	group by n.name;
end
$$;
 A   DROP FUNCTION public.test_select(_month integer, _year integer);
       public          postgres    false            �            1259    16766    entry    TABLE     �   CREATE TABLE homeaccounting.entry (
    id integer NOT NULL,
    main_category integer NOT NULL,
    name_category integer NOT NULL,
    date date DEFAULT CURRENT_DATE,
    cost numeric DEFAULT 0,
    comment character varying(100)
);
 !   DROP TABLE homeaccounting.entry;
       homeaccounting         heap    postgres    false    8            �            1259    16764    entry_id_seq    SEQUENCE     �   CREATE SEQUENCE homeaccounting.entry_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE homeaccounting.entry_id_seq;
       homeaccounting          postgres    false    209    8            B           0    0    entry_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE homeaccounting.entry_id_seq OWNED BY homeaccounting.entry.id;
          homeaccounting          postgres    false    208            �            1259    16653    maincategory    TABLE     o   CREATE TABLE homeaccounting.maincategory (
    id integer NOT NULL,
    name character varying(50) NOT NULL
);
 (   DROP TABLE homeaccounting.maincategory;
       homeaccounting         heap    postgres    false    8            �            1259    16651    maincategory_id_seq    SEQUENCE     �   CREATE SEQUENCE homeaccounting.maincategory_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE homeaccounting.maincategory_id_seq;
       homeaccounting          postgres    false    8    205            C           0    0    maincategory_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE homeaccounting.maincategory_id_seq OWNED BY homeaccounting.maincategory.id;
          homeaccounting          postgres    false    204            �            1259    16753    namecategory    TABLE     �   CREATE TABLE homeaccounting.namecategory (
    id integer NOT NULL,
    main_category integer NOT NULL,
    name character varying(50) NOT NULL
);
 (   DROP TABLE homeaccounting.namecategory;
       homeaccounting         heap    postgres    false    8            �            1259    16751    namecategory_id_seq    SEQUENCE     �   CREATE SEQUENCE homeaccounting.namecategory_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE homeaccounting.namecategory_id_seq;
       homeaccounting          postgres    false    8    207            D           0    0    namecategory_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE homeaccounting.namecategory_id_seq OWNED BY homeaccounting.namecategory.id;
          homeaccounting          postgres    false    206            �
           2604    16769    entry id    DEFAULT     t   ALTER TABLE ONLY homeaccounting.entry ALTER COLUMN id SET DEFAULT nextval('homeaccounting.entry_id_seq'::regclass);
 ?   ALTER TABLE homeaccounting.entry ALTER COLUMN id DROP DEFAULT;
       homeaccounting          postgres    false    209    208    209            �
           2604    16656    maincategory id    DEFAULT     �   ALTER TABLE ONLY homeaccounting.maincategory ALTER COLUMN id SET DEFAULT nextval('homeaccounting.maincategory_id_seq'::regclass);
 F   ALTER TABLE homeaccounting.maincategory ALTER COLUMN id DROP DEFAULT;
       homeaccounting          postgres    false    205    204    205            �
           2604    16756    namecategory id    DEFAULT     �   ALTER TABLE ONLY homeaccounting.namecategory ALTER COLUMN id SET DEFAULT nextval('homeaccounting.namecategory_id_seq'::regclass);
 F   ALTER TABLE homeaccounting.namecategory ALTER COLUMN id DROP DEFAULT;
       homeaccounting          postgres    false    206    207    207            :          0    16766    entry 
   TABLE DATA           ^   COPY homeaccounting.entry (id, main_category, name_category, date, cost, comment) FROM stdin;
    homeaccounting          postgres    false    209   �.       6          0    16653    maincategory 
   TABLE DATA           8   COPY homeaccounting.maincategory (id, name) FROM stdin;
    homeaccounting          postgres    false    205   �0       8          0    16753    namecategory 
   TABLE DATA           G   COPY homeaccounting.namecategory (id, main_category, name) FROM stdin;
    homeaccounting          postgres    false    207   �0       E           0    0    entry_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('homeaccounting.entry_id_seq', 61, true);
          homeaccounting          postgres    false    208            F           0    0    maincategory_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('homeaccounting.maincategory_id_seq', 2, true);
          homeaccounting          postgres    false    204            G           0    0    namecategory_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('homeaccounting.namecategory_id_seq', 23, true);
          homeaccounting          postgres    false    206            �
           2606    16776    entry entry_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY homeaccounting.entry
    ADD CONSTRAINT entry_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY homeaccounting.entry DROP CONSTRAINT entry_pkey;
       homeaccounting            postgres    false    209            �
           2606    16658    maincategory maincategory_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY homeaccounting.maincategory
    ADD CONSTRAINT maincategory_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY homeaccounting.maincategory DROP CONSTRAINT maincategory_pkey;
       homeaccounting            postgres    false    205            �
           2606    16758    namecategory namecategory_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY homeaccounting.namecategory
    ADD CONSTRAINT namecategory_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY homeaccounting.namecategory DROP CONSTRAINT namecategory_pkey;
       homeaccounting            postgres    false    207            �
           2606    16777    entry entry_main_category_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY homeaccounting.entry
    ADD CONSTRAINT entry_main_category_fkey FOREIGN KEY (main_category) REFERENCES homeaccounting.maincategory(id);
 P   ALTER TABLE ONLY homeaccounting.entry DROP CONSTRAINT entry_main_category_fkey;
       homeaccounting          postgres    false    2735    209    205            �
           2606    16782    entry entry_name_category_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY homeaccounting.entry
    ADD CONSTRAINT entry_name_category_fkey FOREIGN KEY (name_category) REFERENCES homeaccounting.namecategory(id);
 P   ALTER TABLE ONLY homeaccounting.entry DROP CONSTRAINT entry_name_category_fkey;
       homeaccounting          postgres    false    2737    209    207            �
           2606    16759 ,   namecategory namecategory_main_category_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY homeaccounting.namecategory
    ADD CONSTRAINT namecategory_main_category_fkey FOREIGN KEY (main_category) REFERENCES homeaccounting.maincategory(id);
 ^   ALTER TABLE ONLY homeaccounting.namecategory DROP CONSTRAINT namecategory_main_category_fkey;
       homeaccounting          postgres    false    207    205    2735            :   �  x���;N#A��S4�UW��}�M@$`��V+RD@Jjf��B�����`�%f��3���U�_�OB��u��������k]�<��;���軮XJ��u�c�����$�ҩ.�-� �(�`U8O����]��8�#����*jK,����XI�&y�B�-�����iv��7l�"��O�f�rK�F�pkD��OMhR�R�n;�s(�n����VP��z�����!��t9:=����+s<�0�W����D��a*3��|H�/����f������gE2��+�>=��G��7�K��1�oy�K�K����	��:������-T�nb�4�M-�{�i 6�Q^�'}����qH�W�"Y�O�vv���I�a\�q�͡j+h׼�"�0��ˊp�Ļ7ب9~ 8�t�$t��~^bo��8�*����M��~ �L�����6�&      6   %   x�3�0�¾���]��e�ya����=... >�6      8     x�5�KN�@D��S�	v�ޅ7��BY8�$A�8bűs��Q=I���75�gE��k�&D)�<�F�:L�D��Zf6yE�9�x��k����<+Ƃ.Z����N+�W�E�?>{BJ���k��E�UaG�6n����^�1�O:|Ԓ����ܚ��ܚ�A��Nt��`K��9�F�qV`���o��l3PZ��vP��|���K��� �%1W����A�D�Պv.�Jq�Z'��K)rS�9��K}>�:.�ǆ�Z��)��3h��BD��� �     