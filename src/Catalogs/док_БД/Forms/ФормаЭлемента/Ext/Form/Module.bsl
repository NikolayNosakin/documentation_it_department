﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ТипБДСервер();
	СформироватьСтрокуСоединения();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ВидимостьWebСервер();
КонецПроцедуры   

&НаКлиенте
Процедура ТипБДПриИзменении(Элемент)
	ТипБДСервер();
	СформироватьСтрокуСоединения();
КонецПроцедуры

&НаСервере
Процедура ТипБДСервер()	
	Если НЕ Объект.ТипБД.Пустая() Тогда 
		Элементы.ГрСервернаяИБ.Видимость = НЕ Объект.ТипБД = Перечисления.док_ТипБД.Файловая;
		Элементы.ПутьК_БД.Видимость = Объект.ТипБД = Перечисления.док_ТипБД.Файловая;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ОпубликованаНаWebСервереПриИзменении(Элемент)
	ВидимостьWebСервер();
КонецПроцедуры

&НаКлиенте
Процедура ВидимостьWebСервер()	
	Элементы.WebСервер.Видимость = Объект.ОпубликованаНаWebСервере;
	Элементы.АдресПубликации.Видимость = Объект.ОпубликованаНаWebСервере;
КонецПроцедуры

&НаКлиенте
Процедура СУБДПриИзменении(Элемент)
	СУБДПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура СУБДПриИзмененииНаСервере()
	Объект.Клиент = Объект.Сервер.Сервер.Клиент;
КонецПроцедуры

&НаСервере
Процедура СформироватьСтрокуСоединения()
	Если Объект.ТипБД = Перечисления.док_ТипБД.Файловая Тогда
		СтрокаСоединения = "Connect=File=""" + Объект.ПутьК_БД + """";
	Иначе	
		СтрокаСоединения = "Connect=Srvr=""" + Объект.Сервер.Наименование + """;Ref=""" + Объект.ИмяИБ + """";
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИмяИБПриИзменении(Элемент)
	СформироватьСтрокуСоединения();
КонецПроцедуры

&НаКлиенте
Процедура ПутьК_БДПриИзменении(Элемент)
	СформироватьСтрокуСоединения();
КонецПроцедуры
