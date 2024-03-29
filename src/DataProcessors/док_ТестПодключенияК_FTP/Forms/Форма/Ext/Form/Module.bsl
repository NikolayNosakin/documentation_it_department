﻿
&НаКлиенте
Процедура Подключиться(Команда)
	УстановитьСоедиенениеFTP();		
КонецПроцедуры

&НаСервере
Процедура УстановитьСоедиенениеFTP()
	
	Начало = ТекущаяДата();
	Соединение = Неопределено;
	ssl1 = Неопределено;
	Если SSL Тогда 
		ssl1 = Новый ЗащищенноеСоединениеOpenSSL(
		Новый СертификатКлиентаWindows(),
		Новый СертификатыУдостоверяющихЦентровWindows());
	КонецЕсли;
	
	УИЗС = УровеньИспользованияЗащищенногоСоединенияFTP[УровеньИспользованияЗащищенногоСоединения_FTP];
	
	Если ПроксиИспользуется Тогда
		Прокси = Новый ИнтернетПрокси();
		Прокси.Установить(ПроксиПротокол,ПроксиСервер,ПроксиПорт,ПроксиЛогин,ПроксиПароль,ПроксиИспользоватьАутентификациюОС);		
	КонецЕсли;

	Попытка
		Если ПроксиИспользуется Тогда
			Соединение = Новый FTPСоединение(ftp,port,login,pass,Прокси,ПассивноеСоединение,Таймаут,ssl1,УИЗС);
		Иначе
			Соединение = Новый FTPСоединение(ftp,port,login,pass,,ПассивноеСоединение,Таймаут,ssl1,УИЗС);
		КонецЕсли;
		Сообщить("Соединение с FTP сервером установлено корректно");
	Исключение
		Сообщить("Ошибка соединения по причине " + ОписаниеОшибки());
	КонецПопытки;
	Конец = ТекущаяДата();
	Разница = Конец - Начало;
	Сообщить("Время подключения " + Разница + "сек.");
	
КонецПроцедуры	
	
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	port = 21;
	ПассивноеСоединение = Истина;
	УровеньИспользованияЗащищенногоСоединения_FTP = "Авто";
КонецПроцедуры
