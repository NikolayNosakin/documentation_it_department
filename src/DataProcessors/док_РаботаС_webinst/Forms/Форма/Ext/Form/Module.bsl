﻿
&НаКлиенте
Процедура ЭлементПриИзменении(Элемент)
	СформироватьСтрокуКоманды();
КонецПроцедуры

&НаКлиенте
Процедура ВебСерверПриИзменении(Элемент)
	
	ИИС = ВебСервер = "iis";
	Элементы.ПутьККонфигурационномуФайлу.Видимость = НЕ ИИС;
	ПутьККонфигурационномуФайлу = ?(ИИС,"",ПутьККонфигурационномуФайлу);
	Элементы.АутентификацияОС.Видимость = ИИС;
	АутентификацияОС = ?(ИИС,АутентификацияОС,Ложь);
	
	СформироватьСтрокуКоманды();
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьСтрокуКоманды()
	Команда = "webinst " + ?(Публикация = 1, "–publish ", "–delete") + 
	"-" + ВебСервер + " -wsdir " + ВиртуальныйКаталог + 
	?(ФизическийКаталог = "", "", " -dir """ + ФизическийКаталог + """") +
	?(СтрокаСоединения = "", "", " -connstr """+ СтрокаСоединения + """") +
	?(ПутьККонфигурационномуФайлу = "", "", " -confpath """ + ПутьККонфигурационномуФайлу + """") +
	?(Шаблон_vrd = "", "", " -descriptor " + Шаблон_vrd) +
	?(АутентификацияОС, " -osauth", "");
КонецПроцедуры                 

&НаКлиенте
Процедура ИБПриИзменении(Элемент)
	ИБПриИзмененииНаСервере();
	СформироватьСтрокуКоманды();
КонецПроцедуры
 
&НаСервере
Процедура ИБПриИзмененииНаСервере()
	ВиртуальныйКаталог = ?(ИБ.ТипБД = Перечисления.док_ТипБД.Файловая, ИБ.Наименование, ИБ.ИмяИБ);
	СтрокаСоединения = ?(ИБ.Пустая(),"",?(ИБ.ТипБД = Перечисления.док_ТипБД.Файловая,"""File=""""" + ИБ.ПутьК_БД + """;""",
	"Srvr=" + Строка(ИБ.Сервер.Сервер) + ";Ref=" + ИБ.ИмяИБ + ";"));
КонецПроцедуры

&НаКлиенте
Процедура Справка(Команда)
	ПерейтиПоНавигационнойСсылке("https://its.1c.ru/db/v8320doc#bookmark:adm:TI000000201");
КонецПроцедуры

&НаКлиенте
Процедура ПутьККонфигурационномуФайлуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ФайловаяСистемаКлиент.ПоказатьДиалогВыбора(Новый ОписаниеОповещения("ПутьККонфигурационномуФайлуНачалоВыбораЗавершение", ЭтаФорма),Диалог);
КонецПроцедуры

&НаКлиенте
Процедура ФизическийКаталогНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ФайловаяСистемаКлиент.ВыбратьКаталог(Новый ОписаниеОповещения("КаталогНачалоВыбораЗавершение", ЭтаФорма));
КонецПроцедуры

&НаКлиенте
Процедура КаталогНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт	
	ФизическийКаталог = Результат;
	СформироватьСтрокуКоманды();
КонецПроцедуры

&НаКлиенте
Процедура ПутьККонфигурационномуФайлуНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт	
	Если НЕ Результат = Неопределено ИЛИ НЕ Результат = "" Тогда     
		ПутьККонфигурационномуФайлу = Результат[0];
		СформироватьСтрокуКоманды();
	КонецЕсли;
КонецПроцедуры
