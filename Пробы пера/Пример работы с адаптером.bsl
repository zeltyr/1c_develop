Перем КоличествоФактПоСтроке; // хранит количество по выбранной строке ДО изменения

&НаКлиенте
Процедура ДеревоТоваровФактПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДеревоТоваров.ТекущиеДанные;

	Если КоличествоФактПоСтроке = ТекущиеДанные.Факт Тогда
		
		Событие = "Обработка не нужна";
		
	ИначеЕсли ТекущиеДанные.Факт > ТекущиеДанные.План
		И Объект.Операция = ПредопределенноеЗначение("Перечисление.МоёПеречисление.СборкаЗаказовКлиента") Тогда
		
		Событие = "Отменить изменение";
		
	Иначе
		
		Событие = "Открыть форму редактирования";
		
	КонецЕсли;
	
	ОбработатьСобытиеИзмененияКоличестваФакт(Событие, ТекущиеДанные);

КонецПроцедуры

// Процедура - Дерево товаров факт при изменении завершение
//
// Параметры:
//  РезультатЗакрытия - Структура
//    - КоличествоФакт - Число
//    - НоменклатураПредставление - Строка
//    - ИсключаемыеРаспоряжения - Массив - набор распоряжений для установки признака "Исключен"
//    - ИзмененияРасходныхОрдеров - Массив - строки с данными для изменения расходных ордеров
//      -- РасходныйОрдер - ДокументСсылка.РасходныйОрдер
//      -- Номенклатура - СправочникСсылка.Номенклатуры
//      -- Количество - Число
//      -- НоменклатураПредставление - Строка
//  ДополнительныеПараметры - Неопределено
//
&НаКлиенте
Процедура ДеревоТоваровФактПриИзмененииЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	ТекущиеДанные = Элементы.ДеревоТоваров.ТекущиеДанные;
	
	ПустойРезультат =  РезультатЗакрытия = Неопределено;
	ЭтоСборкаЗаказовКлиента = Объект.Операция = ПредопределенноеЗначение("Перечисление.МоёПеречисление.СборкаЗаказовКлиента");
	НеВыбраныРаспоряжения = (ЭтоСборкаЗаказовКлиента И РезультатЗакрытия.ИсключаемыеРаспоряжения.Количество() = 0);

	Если ПустойРезультат ИЛИ НеВыбраныРаспоряжения Тогда
	
		Событие = "Отменить изменение";
		СледующееСобытие = "";

	ИначеЕсли ЭтоСборкаЗаказовКлиента Тогда
		
		Событие = "Исключить распоряжения";
		СледующееСобытие = "Перезаписать документ";
		
	Иначе
		
		Событие = "Изменить расходные ордера";
		СледующееСобытие = "Перезаписать документ";
		
	КонецЕсли;
	
	ОбработатьСобытиеИзмененияКоличестваФакт(Событие, ТекущиеДанные)
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьСобытиеИзмененияКоличестваФакт(Событие, ТекущиеДанные, РезультатЗакрытия = Неопределено, СледующееСобытие = "")
	
	Если Событие = "Обработка не нужна" Тогда
		
		Возврат;
		
	ИначеЕсли Событие = "Отменить изменение" Тогда
		
		ТекущиеДанные.Факт = КоличествоФактПоСтроке;
		Возврат;
		
	ИначеЕсли Событие = "Открыть форму редактирования" Тогда
		     
		ОткрытьФормуИзмененияКоличестваФакт(ТекущиеДанные);
		
	ИначеЕсли Событие = "Исключить распоряжения" Тогда
		
		ОбработатьРаспоряженийНаСборкуПослеИзмененияКоличестваФакт(
			РезультатЗакрытия.ИсключаемыеРаспоряжения, 
			РезультатЗакрытия.НоменклатураПредставление);
		
		ТекущиеДанные.Факт = РезультатЗакрытия.Количество;
		
	ИначеЕсли Событие = "Изменить расходные ордера" Тогда
		
		ДанныеВозврата = ОбработатьРасходныеОрдераПослеИзмененияКоличестваФакт(РезультатЗакрытия.ИзмененияРасходныхОрдеров);
			
		Если НЕ ДанныеВозврата.Отказ Тогда
			
			ОбработатьРаспоряженийНаСборкуПослеИзмененияКоличестваФакт(
				ДанныеВозврата.ИсключаемыеРаспоряжения, 
				РезультатЗакрытия.НоменклатураПредставление);
			
		КонецЕсли;
		
	ИначеЕсли Событие = "Перезаписать документ" Тогда
		
		ОбновитьТаблицыТоваров = Истина;
		ЭтаФорма.Записать();
		
		ПосторитьДеревоТоваровПоДаннымДокумента();
		УстановитьТекущуюСтрокуДереваТоваров();
		
		
	Иначе
		
		ВызватьИсключение "Неизвестное событие редактирования 'Количества (факт)'. Обратитесь к программисту";
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СледующееСобытие) Тогда
		ОбработатьСобытиеИзмененияКоличестваФакт(СледующееСобытие, ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

