#DEX Explorer Kit

Это набор скриптов (bat) для упрощения жизни мобильным разработчикам в Delphi XE. Написан для личного использования, распространяется "как есть", никакой ответственности за последствия его использования я не несу. Разрешается изменять по своему усмотрению.
Основу составляет dex2jar - кроссплатформенный набор скриптов, предназначенный для конвертации dex файлов в class файлы. В данной инструкции описано как использовать DEX Explorer Kit для просмотра содержимого и модификации файла classes.dex.

===
###Теория

APK - исполнимый файл Android приложения. По сути ZIP архив, внутри которого лежит classes.dex, AndroidManifest.xml, нативные библиотеки (.so) и пр. ресурсы. Embarcadero Delphi XE использует собственный classes.dex, который помещается в каждое Android приложение, собранное в этой IDE. Файл различается в разных версиях Delphi XE. Чтобы использовать Java классы или Java библиотеку в Android приложении на Delphi, нужно добавить их в classes.dex и подменить его в процессе сборки.

Декомпиляция — процесс воссоздания исходного кода декомпилятором.

Чтобы открыть командную строку в текущей папке, используйте SHIFT + клик правой кнопкой мыши -> Открыть командную строку здесь.

===
###Декомпиляция DEX

1. В командной строке вызвать: "\<dex2jar_home\>/d2j-dex2jar.bat \<dex_path\>", где  
	dex2jar_home - путь к папке, в которую установлен dex2jar (в этом наборе ./decompile/dex2jar-2.0);  
	dex_path     - путь к файлу classes.dex.
2. Открыть получившийся jar в программе-декомпиляторе java приложений (jd-gui, например), чтобы увидеть исходники.  
	JD-GUI не входит в этот набор, но её можно скачать с сайта разработчика http://jd.benow.ca/

Используемая в наборе версия пакета dex2jar 2.0. Перед началом работы рекомендуется проверить наличие новой версии здесь https://sourceforge.net/projects/dex2jar.

===
###Добавление своего Java класса

1. Разместить исходники класса внутри папки src.
2. Разместить classes.dex в папке lib.  
	Если во время исполнения скрипта файл classes.dex не будет обнаружен в папке lib, будет использоваться classes.dex от Embarcadero (к нему необходимо указать путь - EMBO_DEX)
3. Внести изменения в build.bat: указать путь к \*.java файлам. Найти и заменить src\com\company\package\\\*.java в 28 строке файла build.bat.
4. Запустить ./build.bat из командной строки (находясь в папке compile, содержащей этот файл).  
	Результатом слияния, если оно прошло успешно, будет output\dex\classes.dex.
5. Если ваш класс Service или Activity, вероятно, его необходимо будет прописать в шаблоне манифеста - AndroidManifest.template.xml. Такой шаблон можно найти в папке любого проекта на Delphi XE с target-platform = Android.
6. Модифицированный classes.dex необходимо подключить к проекту в меню Project -> Deployment на подобие того, как это сделано с оригинальным classes.dex. Оригинальный classes.dex при этом следует отключить.

При первом использовании следует заглянуть в build.bat и определить переменные ANDROID и EMBO_DEX в соответствии со своим рабочим окружением.
ANDROID - Путь к ANDROID SDK;
EMBO_DEX - Путь к classes.dex от Embarcadero (не нужен, если присутствует classes.dex в папке lib этого набора).
PROJ_DIR - Рабочая директория (т.е. папка, из которой запущен скрипт).

===
###Добавление библиотеки (jar)

1. Разместить библиотеку в папке lib, переименовать в sdk.jar (либо исправить имя в 27 строке файла merge_jar_dex.bat);
2. Разместить classes.dex в папке lib.  
	Если во время исполнения скрипта файл classes.dex не будет обнаружен в папке lib, будет использоваться classes.dex от Embarcadero (к нему необходимо указать путь - EMBO_DEX)
3. Внести изменения в build.bat: указать путь к sdk, если он указан неверно.
4. Запустить ./merge_jar_dex.bat из командной строки (находясь в папке compile, содержащей этот файл).  
	Результатом слияния, если оно прошло успешно, будет output\dex\classes.dex.
5. Модифицированный classes.dex необходимо подключить к проекту в меню Project -> Deployment на подобие того, как это сделано с оригинальным classes.dex. Оригинальный classes.dex при этом нужно отключить.

При первом использовании следует заглянуть в merge_jar_dex.bat и определить переменные ANDROID и EMBO_DEX в соответствии со своим рабочим окружением.
ANDROID - Путь к ANDROID SDK;
EMBO_DEX - Путь к classes.dex от Embarcadero (не нужен, если присутствует classes.dex в папке lib этого набора).
PROJ_DIR - Рабочая директория (т.е. папка, из которой запущен скрипт).

===
###Распространённые ошибки

1. 'java' is not recognized as an internal or external command  
	Нужно настроить переменные окружения (JAVA_HOME и PATH).
	JAVA_HOME содержит путь к java, а в PATH нужно добавить %JAVA_HOME%\bin

2. Dx bad class file magic (cafebabe) or version ...  
	Может возникать при сочетании dx.jar из Delphi XE5 (Android 4.2) и Java 7.
	Решение: использовать Java 6.
	(Текущая версия Java выводится в начале работы скрипта)

3. Чёрный экран при запуске приложения.  
	Внутри apk находится более одного classes.dex. 
	Решение: лишние classes.dex нужно отключать/удалять в меню Project -> Deployment.

===
###Credits

1. Автор оригинального скрипта build.bat: Brian Long aka blong (http://blong.com/Articles/DelphiXE5AndroidActivityResult/ActivityResult.htm)
2. Автор dex2jar: Bob Pan aka pxb1988 (https://sourceforge.net/projects/dex2jar/) 
3. Инструкция и изменения в скрипте: Pavel Homal aka naXa!
