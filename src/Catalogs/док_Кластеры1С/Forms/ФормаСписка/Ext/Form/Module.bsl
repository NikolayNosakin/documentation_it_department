﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)	
	УстановитьПараметрДинамисческогоСписка();
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрДинамисческогоСписка()
	Список.Параметры.УстановитьЗначениеПараметра("Клиент", Клиент);
КонецПроцедуры

&НаКлиенте
Процедура КлиентПриИзменении(Элемент)
	УстановитьПараметрДинамисческогоСписка();
	ОтборПоКлиенту = Клиент;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	док_СобытияФормКлиент.ПриОткрытии(ЭтаФорма, Отказ);
	Клиент = ОтборПоКлиенту;	
	УстановитьПараметрДинамисческогоСписка();
КонецПроцедуры
