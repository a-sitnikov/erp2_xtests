﻿Перем КонтекстЯдра;
Перем Ожидаем;
Перем Утверждения;
Перем ГенераторТестовыхДанных;
Перем ЗапросыИзБД;
Перем УтвержденияПроверкаТаблиц;
Перем РаботаСДокументами;

#Область ЮнитТестирование

Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	
	КонтекстЯдра = КонтекстЯдраПараметр;
	Ожидаем = КонтекстЯдра.Плагин("УтвержденияBDD");
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
	ГенераторТестовыхДанных = КонтекстЯдра.Плагин("СериализаторMXL");
	ЗапросыИзБД = КонтекстЯдра.Плагин("ЗапросыИзБД");
	УтвержденияПроверкаТаблиц = КонтекстЯдра.Плагин("УтвержденияПроверкаТаблиц");
	
	РаботаСДокументами = КонтекстЯдра.Плагин("Plugin_РаботаСДокументами");
	
КонецПроцедуры

Процедура ЗаполнитьНаборТестов(НаборТестов) Экспорт
	
	НаборТестов.Добавить("ОкруглениеВГрафикеПоступленийТоваров_Пачки");
	НаборТестов.Добавить("ОкруглениеВГрафикеПоступленийТоваров_ПоДокументу");
	НаборТестов.Добавить("ОкруглениеВГрафикеПоступленийТоваров_ПоДокументу0");
	
КонецПроцедуры

Процедура ПередЗапускомТеста() Экспорт
	
КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт
	
КонецПроцедуры

#КонецОбласти

Процедура ОкруглениеВГрафикеПоступленийТоваров_Пачки() Экспорт
	
	Структура = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "Ссылки");
	РаботаСДокументами.УдалитьДокументыПоОрганизации(Структура.Организация);
	
	СтруктураДанных = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "ОкруглениеВГрафикеПоступленийТоваров_Пачки");
	
	ДокументОбъект = СтруктураДанных.ЗаказНаПроизводство1.ПолучитьОбъект();
	ДокументОбъект.Статус = Перечисления.СтатусыЗаказовНаПроизводство.КПроизводству;
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение); //ЗаказНаПроизводство
	
	КолвоПоГрафику = ПолучитьКоличествоПоГрафикуПоступления(СтруктураДанных.ЗаказНаПроизводство1);
	Утверждения.ПроверитьРавенство(КолвоПоГрафику, 1.806, "Не верно рассчиталось количество (до графика)");
	
	РассчитатьГрафикПоЗаказу(СтруктураДанных.ЗаказНаПроизводство1);
		
	КолвоПоГрафику = ПолучитьКоличествоПоГрафикуПоступления(СтруктураДанных.ЗаказНаПроизводство1);
	Утверждения.ПроверитьРавенство(КолвоПоГрафику, 1.806, "Не верно рассчиталось количество (после графика)");
	
	ДокументОбъект = СтруктураДанных.МаршрутныйЛистПроизводства1.ПолучитьОбъект();
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение); //МаршрутныйЛистПроизводства1
	
	КолвоПоГрафику = ПолучитьКоличествоПоГрафикуПоступления(СтруктураДанных.ЗаказНаПроизводство1);
	Утверждения.ПроверитьРавенство(КолвоПоГрафику, 1.806, "Не верно рассчиталось количество (после МЛ)");
	
КонецПроцедуры	

Процедура ОкруглениеВГрафикеПоступленийТоваров_ПоДокументу() Экспорт
	
	Структура = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "Ссылки");
	РаботаСДокументами.УдалитьДокументыПоОрганизации(Структура.Организация);
	
	СтруктураДанных = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "ОкруглениеВГрафикеПоступленийТоваров_ПоДокументу");
	
	ДокументОбъект = СтруктураДанных.ЗаказНаПроизводство1.ПолучитьОбъект();
	ДокументОбъект.Статус = Перечисления.СтатусыЗаказовНаПроизводство.КПроизводству;
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение); //ЗаказНаПроизводство
	
	КолвоПоГрафику = ПолучитьКоличествоПоГрафикуПоступления(СтруктураДанных.ЗаказНаПроизводство1);
	Утверждения.ПроверитьРавенство(КолвоПоГрафику, 0.465, "Не верно рассчиталось количество (до графика)");
	
	РассчитатьГрафикПоЗаказу(СтруктураДанных.ЗаказНаПроизводство1);
		
	КолвоПоГрафику = ПолучитьКоличествоПоГрафикуПоступления(СтруктураДанных.ЗаказНаПроизводство1);
	Утверждения.ПроверитьРавенство(КолвоПоГрафику, 0.465, "Не верно рассчиталось количество (после графика)");
	
	ДокументОбъект = СтруктураДанных.МаршрутныйЛистПроизводства1.ПолучитьОбъект();
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение); //МаршрутныйЛистПроизводства1
	
	КолвоПоГрафику = ПолучитьКоличествоПоГрафикуПоступления(СтруктураДанных.ЗаказНаПроизводство1);
	Утверждения.ПроверитьРавенство(КолвоПоГрафику, 0.465, "Не верно рассчиталось количество (после МЛ)");
	
КонецПроцедуры	

Процедура ОкруглениеВГрафикеПоступленийТоваров_ПоДокументу0() Экспорт
	
	Структура = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "Ссылки");
	РаботаСДокументами.УдалитьДокументыПоОрганизации(Структура.Организация);
	
	СтруктураДанных = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "ОкруглениеВГрафикеПоступленийТоваров_ПоДокументу0");
	
	ДокументОбъект = СтруктураДанных.ЗаказНаПроизводство1.ПолучитьОбъект();
	ДокументОбъект.Статус = Перечисления.СтатусыЗаказовНаПроизводство.КПроизводству;
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение); //ЗаказНаПроизводство
	
	КолвоПоГрафику = ПолучитьКоличествоПоГрафикуПоступления(СтруктураДанных.ЗаказНаПроизводство1);
	Утверждения.ПроверитьРавенство(КолвоПоГрафику, 0.5, "Не верно рассчиталось количество (до графика)");
	
	РассчитатьГрафикПоЗаказу(СтруктураДанных.ЗаказНаПроизводство1);
		
	КолвоПоГрафику = ПолучитьКоличествоПоГрафикуПоступления(СтруктураДанных.ЗаказНаПроизводство1);
	Утверждения.ПроверитьРавенство(КолвоПоГрафику, 0.5, "Не верно рассчиталось количество (после графика)");
	
	ДокументОбъект = СтруктураДанных.МаршрутныйЛистПроизводства1.ПолучитьОбъект();
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение); //МаршрутныйЛистПроизводства1
	
	КолвоПоГрафику = ПолучитьКоличествоПоГрафикуПоступления(СтруктураДанных.ЗаказНаПроизводство1);
	Утверждения.ПроверитьРавенство(КолвоПоГрафику, 0.465, "Не верно рассчиталось количество (после МЛ)");
	
КонецПроцедуры	

Процедура РассчитатьГрафикПоЗаказу(ЗаказНаПроизводство) Экспорт
	
	Результат = ПланированиеПроизводстваВызовСервера.РассчитатьГрафикВыпуска(ЗаказНаПроизводство);
	
	// ПланированиеПроизводстваКлиент.ПланироватьОчередьЗаказов()
	Если НЕ Результат.Запланирован Тогда
		
		Для каждого Ошибка из Результат.Ошибки Цикл
			
			ТекстСообщения = "";
			
			Если ТипЗнч(Ошибка.ВидыРабочихЦентров) = Тип("Массив") Тогда
				
				Для каждого ВидРабочегоЦентра из Ошибка.ВидыРабочихЦентров Цикл
					
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Доступности вида рабочего центра %1 недостаточно для размещения этапа.'"),
						ВидРабочегоЦентра.НаименованиеВидаРабочегоЦентра);
					
					ВызватьИсключение ТекстСообщения;
					
				КонецЦикла;
				
			Иначе
				
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не установлен график, по которому работает подразделение %1.'"),
					Ошибка.ВидыРабочихЦентров);
					
					ВызватьИсключение ТекстСообщения;
					
			КонецЕсли;
				
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьКоличествоПоГрафикуПоступления(Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Регистратор",  Ссылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ГрафикПоступленияТоваров.КоличествоИзЗаказов
	|ИЗ
	|	РегистрНакопления.ГрафикПоступленияТоваров КАК ГрафикПоступленияТоваров
	|ГДЕ
	|	ГрафикПоступленияТоваров.Регистратор = &Регистратор";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат 0;
	Иначе
		Возврат Результат.Выгрузить()[0][0];
	КонецЕсли;	
	
КонецФункции	