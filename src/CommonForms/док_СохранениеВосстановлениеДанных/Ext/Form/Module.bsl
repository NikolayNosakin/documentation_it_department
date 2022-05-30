﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)	 
	док_РезервноеКопированиеНаЯндексДиск = Константы.док_РезервноеКопированиеНаЯндексДиск.Получить();
	ЯД_ID_Приложения = Константы.ЯД_ID_Приложения.Получить();
	ЯД_КодАвторизации = Константы.ЯД_КодАвторизации.Получить();
	ЯД_ПарольПриложения = Константы.ЯД_ПарольПриложения.Получить();
	ЯД_СрокДействияТокена = Константы.ЯД_СрокДействияТокена.Получить();
	ЯД_Токен = Константы.ЯД_Токен.Получить();	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьВидимость();
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначениеКонстанты(ИмяКонстанты, ЗначениеКонстанты)
	Константы[ИмяКонстанты].Установить(ЗначениеКонстанты);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВидимость()	
	Элементы.НастройкиРезервногоКопированияЯД.Видимость = док_РезервноеКопированиеНаЯндексДиск;	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьДанные(Команда)	
	ПоказатьДлительнуюОперацию(Истина);	
	Если док_РезервноеКопированиеНаЯндексДиск Тогда
		Оповещение = Новый ОписаниеОповещения("ВыборМестаСозданения", ЭтотОбъект);
		ТекстВопроса = "Место сохранения данных:";		
		ПоказатьВопрос(Оповещение, ТекстВопроса, ПолучитьКнопкиДиалога(), 20, КодВозвратаДиалога.Отмена,, КодВозвратаДиалога.Отмена);		
	Иначе
		Оповещение = Новый ОписаниеОповещения("ВыборФайлаСохранение", ЭтотОбъект);
		Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога); 
		Диалог.Показать(Оповещение);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьКнопкиДиалога()	
	Кнопки = Новый СписокЗначений;
	Кнопки.Добавить(КодВозвратаДиалога.Да,"Яндекс Диск");
	Кнопки.Добавить(КодВозвратаДиалога.Нет,"Это устройство");
	Кнопки.Добавить(КодВозвратаДиалога.Отмена,"Отмена");	
	Возврат Кнопки	
КонецФункции	

&НаКлиенте
Процедура ВыборМестаСозданения(Результат, ДополнительныеПараметры) Экспорт	
	Если Результат = КодВозвратаДиалога.Да Тогда
		СохранитьДанныеНаЯД();
		ПоказатьДлительнуюОперацию(Ложь);
		Сообщить("Сохранение данных завершено.", СтатусСообщения.Внимание);
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда	
		Оповещение = Новый ОписаниеОповещения("ВыборФайлаСохранение", ЭтотОбъект);
		Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога); 
		Диалог.Показать(Оповещение);
	Иначе
		ПоказатьДлительнуюОперацию(Ложь);
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура СохранитьДанныеНаЯД()	
	Сруктура = ЯндексДискОбменДанными.СформироватьСтруктуруПараметров(ЯД_КодАвторизации, ЯД_ID_Приложения, ЯД_ПарольПриложения, ЯД_СрокДействияТокена, ЯД_Токен);	
	ПутьКФайлу = КаталогВременныхФайлов(); 
	ИмяФайла = "documentation_backup_"+Формат(ТекущаяДата(),"ДФ=yyyy.MM.dd")+"_"+Формат(ТекущаяДата(),"ДФ=чч.мм.сс")+".json";
	Данные = СохранениеВосстановлениеДанныхСервер.Сохранить();
	ТекДок = Новый ЗаписьТекста(ПутьКФайлу + ИмяФайла);
	ТекДок.ЗаписатьСтроку(Данные);
	ТекДок.Закрыть();	
	АдресФайла = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ПутьКФайлу + ИмяФайла));
	ЯндексДискОбменДанными.ЗагрузитьФайл("app:/" + ИмяФайла, АдресФайла, Истина, Сруктура);
	УдалитьФайлы(ПутьКФайлу + ИмяФайла);	
КонецПроцедуры

&НаКлиенте
Процедура ВыборФайлаСохранение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт	
	Если ВыбранныеФайлы <> Неопределено Тогда		
		ПутьКФайлу = ВыбранныеФайлы[0];
		ИмяФайла = "documentation_backup_"+Формат(ТекущаяДата(),"ДФ=yyyy.MM.dd")+"_"+Формат(ТекущаяДата(),"ДФ=чч.мм.сс")+".json";
		Данные = СохранениеВосстановлениеДанныхСервер.Сохранить();
		ТекДок = Новый ЗаписьТекста(ПутьКФайлу + "\" + ИмяФайла);
		ТекДок.ЗаписатьСтроку(Данные);
		ТекДок.Закрыть();
		Сообщить("Сохранение данных завершено. Файл " + ИмяФайла + " сохранен.",СтатусСообщения.Внимание);
	КонецЕсли;	
	ПоказатьДлительнуюОперацию(Ложь);  	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьДлительнуюОперацию(Показать)	
	Элементы.ВосстановитьДанные.Видимость = НЕ Показать;
	Элементы.СохранитьДанные.Видимость = НЕ Показать; 
	Элементы.док_РезервноеКопированиеНаЯндексДиск.Видимость = НЕ Показать;
	Элементы.НастройкиРезервногоКопированияЯД.Видимость = НЕ Показать;	
	Элементы.ДлительнаяОперация.Видимость = Показать;	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьДанные(Команда)	
	ПоказатьДлительнуюОперацию(Истина);	
	#Если ВебКлиент Тогда
		ПоказатьВопросВосстановлениеДанных(Новый структура("Файл",Истина));	
	#Иначе	
	Если док_РезервноеКопированиеНаЯндексДиск Тогда
		Оповещение = Новый ОписаниеОповещения("ВыборМестаВосстановления", ЭтотОбъект);
		ТекстВопроса = "Место получения данных:";		
		ПоказатьВопрос(Оповещение, ТекстВопроса, ПолучитьКнопкиДиалога(), 20, КодВозвратаДиалога.Отмена,, КодВозвратаДиалога.Отмена);
	Иначе	
		ПоказатьВопросВосстановлениеДанных(Новый структура("Файл",Истина));	 
	КонецЕсли;
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ВыборМестаВосстановления(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		ВосстановитьДанныеС_ЯД();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда	
		ПоказатьВопросВосстановлениеДанных(Новый структура("Файл",Истина));	
	Иначе
		ПоказатьДлительнуюОперацию(Ложь);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВопросВосстановлениеДанных(Параметр)
	Оповещение = Новый ОписаниеОповещения("ВосстановлениеДанныхПродолжение", ЭтотОбъект, Параметр);
	ТекстВопроса = "Все имеющиеся данные будут удалены и заполнены данными из файла. Продолжить?";
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 20, КодВозвратаДиалога.Нет,, КодВозвратаДиалога.Нет);
КонецПроцедуры	

&НаСервере
Процедура ВосстановитьДанныеС_ЯД()	
	Сруктура = ЯндексДискОбменДанными.СформироватьСтруктуруПараметров(ЯД_КодАвторизации, ЯД_ID_Приложения, ЯД_ПарольПриложения, ЯД_СрокДействияТокена, ЯД_Токен);	
	ЯндексДискОбменДанными.СписокФайлов(,,Сруктура,СписокФайлов);	
	ВосстановлениеДанныхЯД_Видимость(Истина);	
КонецПроцедуры

&НаСервере
Процедура ВосстановлениеДанныхЯД_Видимость(Видимость)
	Элементы.СписокФайлов.Видимость = Видимость;
	Элементы.ДлительнаяОперация.Видимость = НЕ Видимость;
КонецПроцедуры	

&НаКлиенте
Процедура ВосстановлениеДанныхПродолжение(Результат, ДополнительныеПараметры) Экспорт	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Если ДополнительныеПараметры.Файл Тогда
			Оповещение = Новый ОписаниеОповещения("ВыборФайлаЧтение", ЭтотОбъект); 
			Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
			Диалог.МножественныйВыбор = Ложь; 
			Диалог.Показать(Оповещение); 
		Иначе			
			Оповещение = Новый ОписаниеОповещения("ЗагрузитьФайлВосстановленияДанных", ЭтотОбъект,ДополнительныеПараметры.Путь); 
			ВыполнитьОбработкуОповещения(Оповещение,Неопределено);
		КонецЕсли;
	Иначе
		ВосстановлениеДанныхЯД_Видимость(Ложь);
		ПоказатьДлительнуюОперацию(Ложь);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ВыборФайлаЧтение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	Если ВыбранныеФайлы = Неопределено Тогда		
		ПоказатьДлительнуюОперацию(Ложь);	
	Иначе	
		Восстановить(ВыбранныеФайлы[0]);
	КонецЕсли;						
КонецПроцедуры

&НаКлиенте
Процедура Восстановить(ПутьКФайлу)	
	ЧТ = Новый ЧтениеТекста(ПутьКФайлу);
	Текст = ЧТ.Прочитать();
	Лог = "";
	СохранениеВосстановлениеДанныхСервер.Восстановить(Текст,Лог);
	Если Лог = "" Тогда
		Сообщить("Восстановление данных завершено.",СтатусСообщения.Внимание);
	Иначе
		Сообщить("В процессе восстановленя произошла ошибка. Описание ошибки: " + Лог,СтатусСообщения.Внимание);
	КонецЕсли;
КонецПроцедуры	

&НаКлиенте
Процедура КонстантыПриИзменении(Элемент)
	УстановитьЗначениеКонстанты(Элемент.Имя, ЭтаФорма[Элемент.Имя]);
	ОбновитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура КодАвторизации(Команда)
	ПараметрыОткрытия = Новый Структура("IDПриложения", ЯД_ID_Приложения);
	ОткрытьФорму("ОбщаяФорма.ЯДФормаАвторизации", ПараметрыОткрытия, ЭтаФорма, УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ПолучениеКодаАвторизации" Тогда
		ЯД_КодАвторизации = Параметр;
		УстановитьЗначениеКонстанты("ЯД_КодАвторизации", ЯД_КодАвторизации);
		Активизировать();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Токен(Команда) 
	Сруктура = ЯндексДискОбменДанными.СформироватьСтруктуруПараметров(ЯД_КодАвторизации, ЯД_ID_Приложения, ЯД_ПарольПриложения, ЯД_СрокДействияТокена, ЯД_Токен);
	ЯндексДискОбменДанными.Токен(Сруктура); 
	ЯД_СрокДействияТокена = Сруктура.СрокДействияТокена;	
	ЯД_Токен = Сруктура.Токен;
	УстановитьЗначениеКонстанты("ЯД_Токен", Сруктура.Токен); 
	УстановитьЗначениеКонстанты("ЯД_СрокДействияТокена", Сруктура.СрокДействияТокена);
КонецПроцедуры

&НаКлиенте
Процедура СписокФайловВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Строка = Элементы.СписокФайлов.ТекущиеДанные;
	ПоказатьВопросВосстановлениеДанных(Новый структура("Файл,Путь", Ложь,Строка.Путь));
КонецПроцедуры

&НаКлиенте
Процедура СписокФайловВыборЗначения(Элемент, Значение, СтандартнаяОбработка)	
	СтандартнаяОбработка = Ложь;
	Строка = Элементы.СписокФайлов.ТекущиеДанные;	
	ПоказатьВопросВосстановлениеДанных(Новый структура("Файл,Путь", Ложь, Строка.Путь));		
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьФайлВосстановленияДанных(Парам, ПутьФайла) Экспорт	
	Если НЕ ПутьФайла = "" Тогда
		ВременныйФайл = ПолучитьИмяВременногоФайла("json");
		Сруктура = ЯндексДискОбменДанными.СформироватьСтруктуруПараметров(ЯД_КодАвторизации, ЯД_ID_Приложения, ЯД_ПарольПриложения, ЯД_СрокДействияТокена, ЯД_Токен);
		АдресФайла = ЯндексДискОбменДанными.СкачатьФайл(ПутьФайла,Сруктура);
		ДанныеФайла = ПолучитьИзВременногоХранилища(АдресФайла);
		ДанныеФайла.Записать(ВременныйФайл);
		Восстановить(ВременныйФайл);
		УдалитьФайлы(ВременныйФайл);
	КонецЕсли;	
КонецПроцедуры