﻿
#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура УведомлятьОбОкончанииФНПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	ИмяКонстанты = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если ИмяКонстанты <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, ИмяКонстанты);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	ИмяКонстанты = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	УстановитьДоступность(РеквизитПутьКДанным);
	ОбновитьПовторноИспользуемыеЗначения();
	Возврат ИмяКонстанты;
	
КонецФункции

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	
	ЧастиИмени = СтрРазделить(РеквизитПутьКДанным, ".");
	Если ЧастиИмени.Количество() <> 2 Тогда
		Возврат "";
	КонецЕсли;
	
	ИмяКонстанты = ЧастиИмени[1];
	КонстантаМенеджер = Константы[ИмяКонстанты];
	КонстантаЗначение = НаборКонстант[ИмяКонстанты];
	
	Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
		КонстантаМенеджер.Установить(КонстантаЗначение);
	КонецЕсли;
	
	Если ИмяКонстанты = "ИспользоватьДополнительныеРеквизитыИСведения" И КонстантаЗначение = Ложь Тогда
		ЭтотОбъект.Прочитать();
	КонецЕсли;
	
	Возврат ИмяКонстанты;
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	Элементы.НастроитьУведомлениеОбОкончанииФН.Доступность = НаборКонстант.док_УведомлятьОбОкончанииФН;	
КонецПроцедуры

&НаКлиенте
Процедура Настроить(Команда)
	ОткрытьФорму("Обработка.НастройкаУведомленийПользователейОбОкончанииФН.Форма");
КонецПроцедуры

&НаКлиенте
Процедура НастроитьШифрованиеПаролей(Команда)
	ОткрытьФорму("РегистрСведений.док_СправочникиДляШифрования.Форма.ФормаНастроек");
КонецПроцедуры

&НаКлиенте
Процедура ШифроватьПаролиПриИзменении(Элемент)
	Если ВводитьПароль() Тогда
		Оповещение = Новый ОписаниеОповещения("ПослеВводаПароля",ЭтаФорма);
		Пароль = "";
		ПоказатьВводСтроки(Оповещение,Пароль,"Введите пароль для шифрования",100,Ложь);	
	Иначе
		Если док__ОбщегоНазначения.ПолучитьЗначениеКонстанты("док_ПаролиЗашифрованы") Тогда
			ПоказатьВопрос(Новый ОписаниеОповещения("ВопросРасшифроватьДанные",ЭтаФорма), "Расшифровать данные?", РежимДиалогаВопрос.ДаНетОтмена,0,КодВозвратаДиалога.Да, "Шифрование данных");
		КонецЕсли;	
		Подключаемый_ПриИзмененииРеквизита(Элемент);
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Функция ВводитьПароль()
	Возврат НаборКонстант.док_ШифроватьПароли И НЕ (НаборКонстант.док_ШифроватьПароли = Константы.док_ШифроватьПароли.Получить())	
КонецФункции

&НаКлиенте
Процедура ПослеВводаПароля(Пароль, параметры) Экспорт
	Если Пароль = "" Тогда
		НаборКонстант.док_ШифроватьПароли = Ложь;	
	Иначе
		док_ШифрованиеДанныхКлиент.УстановитьПараметрСеансаСПаролем(Пароль);
		Оповещение = Новый ОписаниеОповещения();
		ПоказатьПредупреждение(Оповещение, "Настройте справочники для шифрования и запустите шифрование паролей.");
		Подключаемый_ПриИзмененииРеквизита(Новый Структура("Имя","док_ШифроватьПароли"));
	КонецЕсли;		
КонецПроцедуры

&НаКлиенте
Процедура ВопросРасшифроватьДанные(Результат, параметры) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		док_ШифрованиеДанныхКлиент.РасшифроватьВсеЗашифрованныеДанные();
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура СохранениеВосстановлениеДанных(Команда)
	ОткрытьФорму("ОбщаяФорма.СохранениеВосстановлениеДанных");
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	#Если ВебКлиент Тогда
		Элементы.СохранениеВосстановлениеДанных.Видимость = Ложь;
	#КонецЕсли	
КонецПроцедуры
