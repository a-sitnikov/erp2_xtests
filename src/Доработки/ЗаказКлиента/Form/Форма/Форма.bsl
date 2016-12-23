﻿&НаКлиенте
Перем КонтекстЯдра;
&НаКлиенте
Перем Ожидаем;
&НаКлиенте
Перем Утверждения;
&НаКлиенте
Перем ГенераторТестовыхДанных;
&НаКлиенте
Перем ЗапросыИзБД;
&НаКлиенте
Перем УтвержденияПроверкаТаблиц;

&НаКлиенте
Перем Форма;

#Область ЮнитТестирование

&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	
	КонтекстЯдра = КонтекстЯдраПараметр;
	Ожидаем = КонтекстЯдра.Плагин("УтвержденияBDD");
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
	ГенераторТестовыхДанных = КонтекстЯдра.Плагин("СериализаторMXL");
	ЗапросыИзБД = КонтекстЯдра.Плагин("ЗапросыИзБД");
	УтвержденияПроверкаТаблиц = КонтекстЯдра.Плагин("УтвержденияПроверкаТаблиц");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНаборТестов(НаборТестов) Экспорт
	НаборТестов.Добавить("КоличествоМест");
	НаборТестов.Добавить("КоличествоМестОбеспечение");
	НаборТестов.Добавить("КоличествоМестОбеспечениеСводно");
КонецПроцедуры

&НаКлиенте
Процедура ПередЗапускомТеста() Экспорт
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗапускаТеста() Экспорт
	
	Попытка
		Форма.Модифицированность = Ложь;
		Форма.Закрыть();
	Исключение
	КонецПопытки;	
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура КоличествоМест() Экспорт
	
	Макет = ПолучитьМакет();
	СтруктураДанных = ГенераторТестовыхДанных.СоздатьДанныеПоТабличномуДокументу(Макет,,, Истина);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", СтруктураДанных.ЗаказКлиента1);
	
	Форма = ПолучитьФорму("Документ.ЗаказКлиента.ФормаОбъекта", ПараметрыФормы);
	Форма.Открыть();
	
	Утверждения.ПроверитьРавенство(Форма.Элементы._КоличествоМест.Видимость, Истина, "Нет поля Количество мест");
	Утверждения.ПроверитьРавенство(Форма.Элементы.Товары.Подвал, Истина, "Нет подвала");
	
	СтрокаТЧ = Форма.Объект.Товары[0];
	СтрокаТЧ._КоличествоМест = 1;
	
	Форма.Элементы.Товары.ТекущаяСтрока = СтрокаТЧ.ПолучитьИдентификатор();
	Форма._КоличествоМестПриИзменении(Форма.Элементы._КоличествоМест);
	
	Утверждения.ПроверитьРавенство(0.5, СтрокаТЧ.Количество, "Не рассчиталось количество");
	Утверждения.ПроверитьРавенство(500, СтрокаТЧ.Сумма,      "Не рассчиталась сумма");
	
	Форма._ПересчитатьКоличествоМест();
	
КонецПроцедуры	

&НаКлиенте
Процедура КоличествоМестОбеспечениеСводно() Экспорт
	
	Макет = ПолучитьМакет("Ссылки");
	Ссылки = ГенераторТестовыхДанных.СоздатьДанныеПоТабличномуДокументу(Макет,,, Истина);
	УдалитьДокументыПоОрганизации(Ссылки.Организация);
	
	Макет = ПолучитьМакет("ДанныеОбеспечение");
	СтруктураДанных = ГенераторТестовыхДанных.СоздатьДанныеПоТабличномуДокументу(Макет,,, Истина);
	
	ПровестиДокумент(СтруктураДанных.ПоступлениеТоваровИУслуг1);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", СтруктураДанных.ЗаказКлиента1);
	
	Форма = ПолучитьФорму("Документ.ЗаказКлиента.ФормаОбъекта", ПараметрыФормы);
	Форма.Открыть();
	
	СтрокаТЧ = Форма.Объект.Товары[0];
	Форма.Элементы.Товары.ТекущаяСтрока = СтрокаТЧ.ПолучитьИдентификатор();
	
	Массив = Новый Массив;
	Массив.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.Отгрузить"));
	Массив.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.Требуется"));
	
	ФормаВыбора = ПолучитьФорму("Перечисление.ВариантыОбеспечения.Форма.ИсполнениеЗаказа",, Форма);
	ФормаВыбора.ОповеститьОВыборе(Массив);
	
	Утверждения.ПроверитьРавенство(2,  Форма.Объект.Товары.Количество(), "Не верное количество строк");
	Утверждения.ПроверитьРавенство(50, Форма.Объект.Товары.Итог("_КоличествоМест"), "Не верное итоговое количество мест");
	
	Форма.Модифицированность = Ложь;
	
КонецПроцедуры	

&НаКлиенте
Процедура КоличествоМестОбеспечение() Экспорт
	
	Макет = ПолучитьМакет("Ссылки");
	Ссылки = ГенераторТестовыхДанных.СоздатьДанныеПоТабличномуДокументу(Макет,,, Истина);
	УдалитьДокументыПоОрганизации(Ссылки.Организация);
	
	Макет = ПолучитьМакет("ДанныеОбеспечение");
	СтруктураДанных = ГенераторТестовыхДанных.СоздатьДанныеПоТабличномуДокументу(Макет,,, Истина);
	
	ПровестиДокумент(СтруктураДанных.ПоступлениеТоваровИУслуг1);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", СтруктураДанных.ЗаказКлиента1);
	
	Форма = ПолучитьФорму("Документ.ЗаказКлиента.ФормаОбъекта", ПараметрыФормы);
	Форма.Открыть();
	
	СтрокаТЧ = Форма.Объект.Товары[0];
	Форма.Элементы.Товары.ТекущаяСтрока = СтрокаТЧ.ПолучитьИдентификатор();
	
	Массив = Новый Массив;
	Массив.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.Отгрузить"));
	Массив.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.Требуется"));
	
	ПараметрыФормы = ПараметрыВыбораОбеспечения(Форма.Объект, Форма.УникальныйИдентификатор);
	
	ФормаВыбора = ПолучитьФорму("Перечисление.ВариантыОбеспечения.Форма.ВыборВариантаОбеспечения", ПараметрыФормы, Форма);
	ФормаВыбора.Открыть();
	
	ФормаВыбора.Элементы.Действия.ТекущаяСтрока = 0;
	СтрокаТаблицы = ФормаВыбора.Действия.НайтиПоИдентификатору(0);
	ВыбратьНаКлиенте(ФормаВыбора, СтрокаТаблицы);
	
	Утверждения.ПроверитьРавенство(2,  Форма.Объект.Товары.Количество(), "Не верное количество строк");
	Утверждения.ПроверитьРавенство(50, Форма.Объект.Товары.Итог("_КоличествоМест"), "Не верное итоговое количество мест");
	
КонецПроцедуры	

&НаКлиенте
Процедура ВыбратьНаКлиенте(Форма, СтрокаТаблицы)

	Обособленно = ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.Обособленно");
	МассивВыбора = Новый Массив();

	МассивВыбора = Новый Массив();
	Если Форма.КоличествоОтгружено > 0 Тогда
		ЗначениеВыбора = ОбеспечениеКлиентСервер.СтруктураВариантаОбеспечения();
		ЗначениеВыбора.ВариантОбеспечения   = Форма.Параметры.ТекущийВариант.ВариантОбеспечения;
		ЗначениеВыбора.ДатаОтгрузки         = Форма.Параметры.ТекущийВариант.ДатаДоступности;
		ЗначениеВыбора.Склад                = Форма.Параметры.ТекущийВариант.Склад;
		ЗначениеВыбора.Серия                = ПредопределенноеЗначение("Справочник.СерииНоменклатуры.ПустаяСсылка");
		ЗначениеВыбора.Количество           = Форма.КоличествоОтгружено;
		ЗначениеВыбора.Вставить("Отгружено", 1);
		МассивВыбора.Добавить(ЗначениеВыбора);
	КонецЕсли;

	Для Каждого СтрокаТаблицы Из Форма.ВыбранныеДействия Цикл

		ЗначениеВыбора = ОбеспечениеКлиентСервер.СтруктураВариантаОбеспечения();
		ЗначениеВыбора.ВариантОбеспечения   = СтрокаТаблицы.ВариантОбеспечения;
		ЗначениеВыбора.ДатаОтгрузки         = СтрокаТаблицы.ДатаДоступности;
		ЗначениеВыбора.Склад                = СтрокаТаблицы.Склад;
		ЗначениеВыбора.Серия                = ПредопределенноеЗначение("Справочник.СерииНоменклатуры.ПустаяСсылка");
		ЗначениеВыбора.Количество           = СтрокаТаблицы.Количество;
		ЗначениеВыбора.Вставить("Отгружено", 0);

		Если Форма.КоличествоОтгружено > 0 И ЗначениеВыбора.ВариантОбеспечения = МассивВыбора[0].ВариантОбеспечения
			И ЗначениеВыбора.Склад = МассивВыбора[0].Склад Тогда

			МассивВыбора[0].Количество = МассивВыбора[0].Количество + ЗначениеВыбора.Количество;

		Иначе

			МассивВыбора.Добавить(ЗначениеВыбора);

		КонецЕсли;

	КонецЦикла;

	Форма.ОповеститьОВыборе(МассивВыбора);

КонецПроцедуры

&НаСервере
Функция ПараметрыВыбораОбеспечения(Знач Объект, Знач УникальныйИдентификатор)

	ПутиКДанным = Новый Соответствие();
	ПутиКДанным.Вставить("ДатаОтгрузкиРабот", "ДатаОтгрузки");

	ПараметрыЗаполнения = Новый Структура("СтатусКВыполнению, ГруппаСкладов, МенеджерРегистра",
		Объект.Статус <> Перечисления.СтатусыЗаказовКлиентов.НеСогласован, Объект.Склад, РегистрыНакопления.ЗаказыКлиентов);

	Результат = ОбеспечениеСервер.ПараметрыВыбораОбеспечения(
		0,
		Объект,
		Объект.Товары,
		ПутиКДанным,
		ПараметрыЗаполнения);
		
	ОбеспечениеСервер.ДобавитьСвойствоАдресТаблицыПодобраноРанее(Результат, УникальныйИдентификатор);
	
	Возврат Результат;

КонецФункции

&НаСервереБезКонтекста
Процедура ПровестиДокумент(Ссылка)
	
	ДокументОбъект = Ссылка.ПолучитьОбъект();
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	
КонецПроцедуры	

&НаСервере
Функция ПолучитьМакет(ИмяМакета = "Данные")
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	Возврат ОбработкаОбъект.ПолучитьМакет(ИмяМакета);
	
КонецФункции

#Область УдалениеДокументов

&НаСервереБезКонтекста
Процедура УдалитьДокументыПоОрганизации(Организация)
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Имя");
	Таблица.Колонки.Добавить("Отбор");
	
	ДобавитьДокумент(Таблица, "Документ.РасчетСебестоимостиТоваров");
	ДобавитьДокумент(Таблица, "Документ.РегламентнаяОперация");
	ДобавитьДокумент(Таблица, "Документ.ПереоценкаВалютныхСредств");
	ДобавитьДокумент(Таблица, "Документ.ПоступлениеБезналичныхДенежныхСредств");
	ДобавитьДокумент(Таблица, "Документ.СчетФактураПолученныйАванс");
	ДобавитьДокумент(Таблица, "Документ.СчетФактураВыданный");
	ДобавитьДокумент(Таблица, "Документ.СчетФактураВыданныйАванс");
	ДобавитьДокумент(Таблица, "Документ.ВзаимозачетЗадолженности");
	ДобавитьДокумент(Таблица, "Документ.РеализацияТоваровУслуг");
	ДобавитьДокумент(Таблица, "Документ.СписаниеБезналичныхДенежныхСредств");
	ДобавитьДокумент(Таблица, "Документ.ПоступлениеБезналичныхДенежныхСредств");
	ДобавитьДокумент(Таблица, "Документ.АктВыполненныхРабот");
	ДобавитьДокумент(Таблица, "Документ.РаспределениеПроизводственныхЗатрат");
	ДобавитьДокумент(Таблица, "Документ.СборкаТоваров");
	ДобавитьДокумент(Таблица, "Документ.ВыработкаСотрудников");
	ДобавитьДокумент(Таблица, "Документ.ВыпускПродукции");
	ДобавитьДокумент(Таблица, "Документ.ПередачаМатериаловВПроизводство");
	ДобавитьДокумент(Таблица, "Документ.ПеремещениеТоваров");
	ДобавитьДокумент(Таблица, "Документ.ЗаказНаПеремещение");
	ДобавитьДокумент(Таблица, "Документ.МаршрутныйЛистПроизводства");
	ДобавитьДокумент(Таблица, "Документ.СчетФактураПолученный");
	ДобавитьДокумент(Таблица, "Документ.ПоступлениеТоваровУслуг");
	ДобавитьДокумент(Таблица, "Документ.ПоступлениеУслугПрочихАктивов");
	ДобавитьДокумент(Таблица, "Документ.ПриемНаРаботу");
	ДобавитьДокумент(Таблица, "Документ.НачислениеЗарплаты");
	ДобавитьДокумент(Таблица, "Документ.ОтражениеЗарплатыВФинансовомУчете");
	ДобавитьДокумент(Таблица, "Документ.КорректировкаЗаказаМатериаловВПроизводство");
	ДобавитьДокумент(Таблица, "Документ.ЗаказНаПроизводство");
	ДобавитьДокумент(Таблица, "Документ.ЗаказКлиента");
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Док.Ссылка
	|ИЗ
	|	Документ.АвансовыйОтчет КАК Док
	|ГДЕ
	|	Док.Организация = &Организация";
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Организация", Организация);
	
	Для каждого СтрокаТЗ из Таблица Цикл
		
		Текст1 = СтрЗаменить(ТекстЗапроса, "Документ.АвансовыйОтчет", СтрокаТЗ.Имя);
		Текст1 = СтрЗаменить(Текст1, "Док.Организация", СтрокаТЗ.Отбор);
		
		Запрос.Текст = Текст1;
		ТаблицаДокументов = Запрос.Выполнить().Выгрузить();
		Для каждого Строка1 из ТаблицаДокументов Цикл
			
			ДокументОбъект = Строка1.Ссылка.ПолучитьОбъект();
			
			Если ДокументОбъект <> Неопределено Тогда
				
				Попытка
					ДокументОбъект.Удалить();
				Исключение
					//Сообщить(Строка(ТипЗнч(Объект)) + ": " + Строка(Объект));
				КонецПопытки;
				
			КонецЕсли;	
					
		КонецЦикла;	
		
	КонецЦикла;	
	
КонецПроцедуры	

&НаСервереБезКонтекста
Процедура ДобавитьДокумент(Таблица, Имя, Отбор = "Организация")
	
	НоваяСтрока = Таблица.Добавить();
	НоваяСтрока.Имя   = Имя;
	НоваяСтрока.Отбор = Отбор;
	
КонецПроцедуры	

#КонецОбласти
