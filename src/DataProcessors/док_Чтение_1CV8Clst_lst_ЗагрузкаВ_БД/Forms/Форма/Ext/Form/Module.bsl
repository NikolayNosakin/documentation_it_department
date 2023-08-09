﻿// =============== M[2][Сч] =================
//0  УИД базы					"64a13ab8-6d80-42f1-9e0a-9b20bdb7f33b"	Строка
//1  Наименование				"ERP"	Строка
//2  Описание					"Демо база"	Строка
//3  Тип СУБД					"MSSQLServer"	Строка
//4  Сервер баз данных			"SQL2"	Строка
//5  База данных				"ERP"	Строка
//6  Пользователь сервера БД	"sa"	Строка
//7  Пароль пользователя БД		"iCWEFn46iXu5gwrBCQCC0scf4rRvow/U5t/qTe2JN9Y="	Строка
//8  .служебная строка			"CrSQLDB=Y;DB=ERP;DBMS=MSSQLServer;DBSrvr=SQL2;DBUID=sa;Descr="Демо база";LicDstr=Y;Locale=ru_RU;Ref=ERP;SchJobDn=Y;SLev=0;SQLYOffs=2000;Srvr=Serv1C:1441"	Строка
//9  Защищенное соединение		"0"	Строка
//10 Данные о блокировке		Массив	Массив
//		0 Блокировка начала сеансов включена
//		1 Дата начала в формате 00010101000000
//		2 Дата конца в формате 00010101000000
//		3 Сообщение блокировки
//		4 Код разблокировки
//		5 Параметр блокировки
//11 Блокировка регл.заданий	"1"	Строка	
//12 Разрешить выдачу лицензий	"1"	Строка
//13 Внешнее управление сеансами ""	Строка	(!! в 8.2 нет !!)
//14 Обязательное использование внешнего управления	"0"	Строка	(!! в 8.2 нет !!)
//15 Профиль безопасности		""	Строка	(!! в 8.2 нет !!)
//16 Профиль безопасности безопасного режима ""	Строка	(!! в 8.2 нет !!)
//17 							"1950" или "7872317"	Строка (!! в 8.3.4.496 нет !!)
// ==========================================

&НаКлиенте
Процедура ФайлНастроекНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ДВФ = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДВФ.Фильтр = НСтр("ru = ""Текст""; en = ""Text""")+"(*.lst)|*.lst"; 
	ДВФ.МножественныйВыбор = Ложь; 
	ДВФ.Заголовок = "Выберите файл 1CV8Clst.lst или 1CV8Reg.lst";
	ФайловаяСистемаКлиент.ПоказатьДиалогВыбора( Новый ОписаниеОповещения("КаталогНачалоВыбораЗавершение",ЭтотОбъект),ДВФ);	 
КонецПроцедуры

&НаКлиенте
Процедура КаталогНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
    Если Результат = Неопределено Тогда
        Возврат;
    КонецЕсли;  
    ФайлНастроек = Результат[0];  
КонецПроцедуры

&НаКлиенте
Процедура Прочитать(Команда)
	
	Ф = Новый ЧтениеТекста(ФайлНастроек,,,,Ложь);
	ТекстСтрокой= Ф.Прочитать();
	Ф.Закрыть();
		
	ПрочитатьСервер(ТекстСтрокой);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьСервер(ТекстСтрокой)
	
	БД.Очистить();	
	
	М = РазобратьСтроку(ТекстСтрокой);
	
	Для Сч=1 По М[2].ВГраница() Цикл
		
		ОписаниеБазы = М[2][Сч];
		
		СтрБД = БД.Добавить();
		СтрБД.Гуид = ОписаниеБазы[0];
		СтрБД.ИмяВКластере = ОписаниеБазы[1];
		СтрБД.Описание = ОписаниеБазы[2];
		СтрБД.ТипБД = ОписаниеБазы[3];
		СтрБД.СУБД = ОписаниеБазы[4];
		СтрБД.ИмяИБ_В_СУБД = ОписаниеБазы[5];
		СтрБД.ИмяПользователяСУБД = ОписаниеБазы[6];
		
		СтрБД.БД = Справочники.док_БД.НайтиПоРеквизиту("ИмяИБ",СтрБД.ИмяВКластере);
		СтрБД.Кластер1С = Кластер1С;
		СтрБД.Контрагент = Контрагент;
		СтрБД.СУБД_ = Справочники.док_СУБД.НайтиПоНаименованию(СтрБД.СУБД);
		Если СтрБД.СУБД_.Пустая() И НЕ СтрБД.БД.Пустая() Тогда
			СтрБД.СУБД_ = СтрБД.БД.СУБД;
		КонецЕсли;	
		СтрБД.ТипБД_ = Перечисления.док_ТипБД.КлиентСерверная;		
		СтрБД.ФлЗагрузки = СтрБД.БД.Пустая();
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция РазобратьСтроку(Строка, ТекущийМассив = Неопределено)
	ПризнакКавычкиОткрыты = Ложь;
	ПризнакПерваяКавычкаБыла = Ложь;				
	ТекущееЗначение = "";
	Пока СтрДлина(Строка)>0 Цикл
		ПервыйСимвол = Лев(Строка,1);
		Если ПризнакКавычкиОткрыты Тогда
			// кавычка
			Если ПервыйСимвол="""" И НЕ ПризнакПерваяКавычкаБыла Тогда
				Строка = Сред(Строка,2);
				ПризнакПерваяКавычкаБыла=Истина;
			ИначеЕсли ПервыйСимвол="""" И ПризнакПерваяКавычкаБыла Тогда
				Строка = Сред(Строка,2);
				ТекущееЗначение = ТекущееЗначение + ПервыйСимвол;
				ПризнакПерваяКавычкаБыла=Ложь;
			// не кавычка
			ИначеЕсли ПризнакПерваяКавычкаБыла Тогда
				ПризнакКавычкиОткрыты=Ложь; // строку не обрезаем, тот же символ пойдет по основной ветке
				ПризнакПерваяКавычкаБыла=Ложь;
			Иначе
				Строка = Сред(Строка,2);
				ТекущееЗначение = ТекущееЗначение + ПервыйСимвол;
				ПризнакПерваяКавычкаБыла=Ложь;
			КонецЕсли;
		Иначе
			Если (ПервыйСимвол=Символы.ПС) ИЛИ (ПервыйСимвол=Символы.ВК) Тогда
				Строка = Сред(Строка,2);
			ИначеЕсли ПервыйСимвол="{" Тогда
				Строка = Сред(Строка,2);
				ВложенныйМассив = Новый Массив;
				ТекущееЗначение = РазобратьСтроку(Строка, ВложенныйМассив);
			ИначеЕсли ПервыйСимвол="}" Тогда
				ТекущийМассив.Добавить(ТекущееЗначение);
				Строка = Сред(Строка,2);
				Возврат ТекущийМассив;
			ИначеЕсли ПервыйСимвол="," Тогда
				Строка = Сред(Строка,2);
				ТекущийМассив.Добавить(ТекущееЗначение);
				ТекущееЗначение = "";
			ИначеЕсли ПервыйСимвол="""" Тогда
				Строка = Сред(Строка,2);
				ПризнакКавычкиОткрыты = Истина;
			Иначе
				Строка = Сред(Строка,2);
				ТекущееЗначение = ТекущееЗначение + ПервыйСимвол;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат ТекущееЗначение;
КонецФункции

&НаКлиенте
Процедура УстановитьФлаг(Команда)
	ИзменитьФлагНаСервере(Истина);
КонецПроцедуры 

&НаСервере
Процедура ИзменитьФлагНаСервере(Флаг)
	Для каждого стр из бд цикл
		стр.ФлЗагрузки = Флаг;
	КонецЦикла;	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлаг(Команда)
	ИзменитьФлагНаСервере(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьКластерВ_Таб(Команда)
	ЗаполнитьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	Для каждого стр из бд цикл
		стр.Кластер1С = Кластер1С;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьВСправочник(Команда)
	ЗагрузитьВСправочникНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьВСправочникНаСервере()
	Для каждого стр из бд цикл
		Если стр.ФлЗагрузки Тогда
			Если стр.бд.Пустая() Тогда 
				ОбБД = Справочники.док_БД.СоздатьЭлемент();
			Иначе
				ОбБД = стр.бд.ПолучитьОбъект();
			КонецЕсли;	
			ОбБД = Справочники.док_БД.СоздатьЭлемент();
			ОбБД.Наименование = стр.ИмяВКластере;
			ОбБД.ИмяИБ = стр.ИмяВКластере;
			ОбБД.ИмяИБ_В_СУБД = стр.ИмяИБ_В_СУБД;
			ОбБД.СУБД = стр.субд_;
			ОбБД.Контрагент = стр.Контрагент;
			ОбБД.Сервер = стр.Кластер1С;
			ОбБД.ТипБД = стр.ТипБД_;
			ОбБД.Описание = ?(ОбБД.Описание = "",стр.Описание,ОбБД.Описание);
			ОбБД.Записать();
			стр.бд = ОбБД.Ссылка; 
		КонецЕсли;	
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьКонтрагентаВ_Таб(Команда)
	ЗаполнитьКонтрагентаВ_ТабНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКонтрагентаВ_ТабНаСервере()
	Для каждого стр из бд цикл
		стр.Контрагент = Контрагент;
	КонецЦикла;
КонецПроцедуры

