﻿
&НаКлиенте
Процедура ДПЗ_ЗаказПриИзмененииПосле(Элемент)
	
	ОбновитьОснованиеПечати(Объект, Элементы.Заказ.ТекстРедактирования);
	
КонецПроцедуры

&НаСервере
Процедура ДПЗ_ПередЗаписьюНаСервереПосле(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка)
		И ТипЗнч(ТекущийОбъект.ОснованиеПечатиСсылка) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
		ОбновитьОснованиеПечати(ТекущийОбъект, ПараметрыЗаписи.ТекстОснования);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьОснованиеПечати(Объект, ЗНАЧ ТекстОснования)
	
	Объект.ОснованиеПечати = ТекстОснования;
	Объект.ОснованиеПечатиСсылка = Объект.Заказ;
	
КонецПроцедуры

&НаКлиенте
Процедура ДПЗ_ПередЗаписьюПосле(Отказ, ПараметрыЗаписи)
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		НомераГТДЗаполнитьПоФактическимОстаткамНаСервере(Истина);
		ПараметрыЗаписи.Вставить("ТекстОснования", Элементы.Заказ.ТекстРедактирования);	
	КонецЕсли;
	
КонецПроцедуры
