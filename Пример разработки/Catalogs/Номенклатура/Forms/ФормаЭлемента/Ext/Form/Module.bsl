﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ГруппаАналогов = ПолучитьГруппуАналоговПоНоменклатуре();
	КонецЕсли;
	
	СтароеЗначениеГруппаАналогов = ГруппаАналогов;
	ОбновитьДанныеПоАналогам();	
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(ГруппаАналогов) Тогда
		ОбработатьТаблицуАналоговПередЗаписью(Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(ГруппаАналогов) Тогда
		
		Менеджер = РегистрыСведений.АналогиНоменклатуры.СоздатьМенеджерЗаписи();
		Менеджер.Номенклатура = Объект.Ссылка;
		Менеджер.ГруппаАналогов = ГруппаАналогов;
		Менеджер.Записать();
		
	Иначе
		
		Менеджер = РегистрыСведений.АналогиНоменклатуры.СоздатьМенеджерЗаписи();
		Менеджер.Номенклатура = Объект.Ссылка;
		Менеджер.Прочитать();
		
		Если Менеджер.Выбран() Тогда
			Менеджер.Удалить();
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГруппаАналоговПриИзменении(Элемент)
	
	Если СтароеЗначениеГруппаАналогов <> ГруппаАналогов Тогда
		ОбновитьДанныеПоАналогам();
		СтароеЗначениеГруппаАналогов = ГруппаАналогов;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаАналоговНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтароеЗначениеГруппаАналогов = ГруппаАналогов;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаАналогов

&НаКлиенте
Процедура ТаблицаАналоговОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Для Каждого ВыбЭлемент из ВыбранноеЗначение Цикл
		
		// исключим добавление дубликатов номенклатуры и ссылку на себя самого
		Если ТаблицаАналогов.НайтиПоЗначению(ВыбЭлемент) = Неопределено 
			И НЕ ОБъект.Ссылка = ВыбЭлемент Тогда
			
			ТаблицаАналогов.Добавить(ВыбЭлемент);
			
		КонецЕсли;
		
	КонецЦикла;
	
	
КонецПроцедуры 

&НаКлиенте
Процедура ТаблицаАналоговЗначениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекДанные = Элементы.ТаблицаАналогов.ТекущиеДанные;
	// исключим добавление дубликатов номенклатуры и ссылку на себя самого
	Если ТаблицаАналогов.НайтиПоЗначению(ВыбранноеЗначение) = Неопределено 
		И НЕ ОБъект.Ссылка = ВыбранноеЗначение Тогда
		
		ТекДанные.Значение = ВыбранноеЗначение;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьГруппуАналоговПоНоменклатуре()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	АналогиНоменклатуры.ГруппаАналогов КАК ГруппаАналогов
	|ИЗ
	|	РегистрСведений.АналогиНоменклатуры КАК АналогиНоменклатуры
	|ГДЕ
	|	АналогиНоменклатуры.Номенклатура = &Номенклатура";
	
	Запрос.УстановитьПараметр("Номенклатура", Объект.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		
		лГруппаАналогов = Выборка.ГруппаАналогов;
		
	Иначе
		
		лГруппаАналогов = ПредопределенноеЗначение("Справочник.ГруппыАналогов.ПустаяСсылка");
		
	КонецЕсли;
	
	Возврат лГруппаАналогов;
	
КонецФункции

&НаСервере
Процедура ОбновитьДанныеПоАналогам();
	
	ТаблицаАналогов.Очистить();
	
	Если ЗначениеЗаполнено(ГруппаАналогов) Тогда
		Элементы.ТаблицаАналогов.Доступность = Истина;
	Иначе
		Элементы.ТаблицаАналогов.Доступность = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ГруппаАналогов) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	АналогиНоменклатуры.Номенклатура КАК Значение,
		|	ПРЕДСТАВЛЕНИЕ(АналогиНоменклатуры.Номенклатура) КАК Представление
		|ИЗ
		|	РегистрСведений.АналогиНоменклатуры КАК АналогиНоменклатуры
		|ГДЕ
		|	АналогиНоменклатуры.ГруппаАналогов = &ГруппаАналогов
		|	И АналогиНоменклатуры.Номенклатура <> &Номенклатура";
		
		Запрос.УстановитьПараметр("ГруппаАналогов", ГруппаАналогов);
		Запрос.УстановитьПараметр("Номенклатура", Объект.Ссылка);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			НовЭлем = ТаблицаАналогов.Добавить();
			ЗаполнитьЗначенияСвойств(НовЭлем, Выборка);
		КонецЦикла;
		
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьТаблицуАналоговПередЗаписью(Отказ)
	
	// уберем пустые строки
	СчетчикЭлементов = ТаблицаАналогов.Количество() - 1;
	Пока СчетчикЭлементов >= 0 Цикл
	
		Если ТаблицаАналогов[СчетчикЭлементов].Значение = ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка") Тогда
			
			ТаблицаАналогов.Удалить(ТаблицаАналогов[СчетчикЭлементов]);
			
		КонецЕсли;
	    СчетчикЭлементов = СчетчикЭлементов - 1;
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	АналогиНоменклатуры.Номенклатура КАК Номенклатура
		|ИЗ
		|	РегистрСведений.АналогиНоменклатуры КАК АналогиНоменклатуры
		|ГДЕ
		|	АналогиНоменклатуры.ГруппаАналогов = &ГруппаАналогов
		|	И АналогиНоменклатуры.Номенклатура <> &Номенклатура";
	
	Запрос.УстановитьПараметр("ГруппаАналогов", ГруппаАналогов);
	Запрос.УстановитьПараметр("Номенклатура", Объект.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	МассивНайденнойНом = Новый Массив;
	
	НаборЗаписей = РегистрыСведений.АналогиНоменклатуры.СоздатьНаборЗаписей();
	
	Для каждого ЭлемСписка ИЗ ТаблицаАналогов Цикл
		
		ВыборкаДетальныеЗаписи.Сбросить();
		Если НЕ ВыборкаДетальныеЗаписи.НайтиСледующий(ЭлемСписка.Значение, "Номенклатура") Тогда
			
			Запись = НаборЗаписей.Добавить();
			Запись.Номенклатура = ЭлемСписка.Значение;
			Запись.ГруппаАналогов = ГруппаАналогов;
			
		Иначе
			
			МассивНайденнойНом.Добавить(ЭлемСписка.Значение);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если НаборЗаписей.Количество() <> 0 Тогда
		
		Попытка
			НаборЗаписей.Записать(Ложь);
		Исключение
			
			Отказ = Истина;
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			Сообщение.Сообщить();
			
			Возврат;
			
		КонецПопытки;
		
	КонецЕсли;
	
	ВыборкаДетальныеЗаписи.Сбросить();
	ПараметрыОтбора = Новый Структура("Аналог", "");
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Если МассивНайденнойНом.Найти(ВыборкаДетальныеЗаписи.Номенклатура) = Неопределено Тогда
			
			Менеджер = РегистрыСведений.АналогиНоменклатуры.СоздатьМенеджерЗаписи();
			Менеджер.Номенклатура = ВыборкаДетальныеЗаписи.Номенклатура;
			Менеджер.Прочитать();
			
			Если Менеджер.Выбран() Тогда
				Менеджер.Удалить();
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
