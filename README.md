
<h4>Реализованная функциональность</h4>
<ul>
    <li>Прокладывание маршрута с учетом экорейтинга (iOS);</li>
    <li>Ведение по маршруту с голосовыми подсказками (iOS);</li>
    <li>Маршруты для разных видов транспорта (iOS);</li>
    <li>Получение POI с помощью Overpass (Backend);</li>
    <li>Получение данных с датчиков (Backend);</li>
    <li>Расчет экорейтинга (Backend);</li>
    <li>Создание класстера из экорейтинга и POI для прокладывания маршрута (Backend);</li>
</ul> 
<h4>Особенность проекта в следующем:</h4>
<ul>
 <li>Маршруты создаются с учетом экорейтинга;</li>
 <li>Отображение тепловой карты;</li>
 <li>ЭкоМаршруты "Мне повезет" - заранее подготовленные маршруты, если пользователь не хочет выбирать сам куда пойти погулять;</li>  
 <li>Маршруты захватывают POI объекты, интересные пользователю (например - утром кофейня);</li>  
 </ul>
<h4>Основной стек технологий:</h4>
<ul>
    <li>Swift, Graphooper, SPM - iOS.</li>
	<li>Swift, Vapor, Overpass OSM - Backend.</li>
 </ul>
<h4>Демо</h4>
<p>Демо сервиса доступно по адресу: http://demo.test </p>
<p>Реквизиты тестового пользователя: email: <b>testuser@test.ru</b>, пароль: <b>testuser</b></p>




СРЕДА ЗАПУСКА (Backend)
------------
1) развертывание сервиса производится на Ubuntu 20.04 либо на любой, который поддерживает [Swift](https://swift.org/download/);
2) Сервер требует установленный [Vapor](https://github.com/vapor/vapor);


УСТАНОВКА (Backend)
------------
### Конфигурация Файрволла

Выполните 
~~~
ufw allow OpenSSH
ufw enable
~~~

### Добавим юзера для Vapor-а

Выполните 
~~~
adduser vapor
usermod -aG sudo vapor
rsync --archive --chown=vapor:vapor ~/.ssh /home/vapor
exit
ssh vapor@your_server_ip
~~~

### Установим Swift зависимость

Выполните 
~~~
sudo apt-get update
sudo apt-get install clang libicu-dev libatomic1 build-essential pkg-config
~~~

Далее, нужно скопировать ссылку на Swift нужно платформы [отсюда](https://swift.org/download/#releases)
И нужно загрузить по этой ссылке архив
~~~
wget https://swift.org/builds/swift-5.5-release/ubuntu2004/swift-5.5-RELEASE/swift-5.5-RELEASE-ubuntu20.04.tar.gz
tar xzf swift-5.5-RELEASE-ubuntu18.04.tar.gz
~~~

### Установка Toolchain

Выполните 
~~~
sudo mkdir /swift
sudo mv swift-5.5-RELEASE-ubuntu20.04 /swift/5.5
sudo ln -s /swift/5.5/usr/bin/swift /usr/bin/swift
~~~

И проверить правильность установки с помощью
~~~
swift --version
~~~

### Установка и билд проекта

Выполните 
~~~
sudo apt-get install openssl libssl-dev zlib1g-dev libsqlite3-dev
sudo ufw allow http
git clone https://github.com/DmitriyTor/EcoRoute_Server.git
cd api-template
swift build --enable-test-discovery
~~~

### Запуск сервера

Выполните, изменив IP на IP адрес сервера
~~~
sudo .build/debug/Run serve -b 0.0.0.0:80
~~~

В целом Backend готов к работе. Далее необходимо установить клиента

СРЕДА ЗАПУСКА (iOS)
------------
1) Развертывание приложения происходит в симуляторе iOS с помощью IDE Xcode, доступный только на macOS;
2) Приложение требует установленный Xcode с AppStore;

### Генерайия проекта

Скачаайте проект и откройте директорию, в которой он находится
Выполните команду в терминале после первого запуска xcode для того
~~~
xcodegen generate
~~~

После этого открой проект и вверху нажмите Run и выберите тип симулятора


РАЗРАБОТЧИКИ

<h4>Дмитрий Торопкин iOS https://t.me/DmitriyTor3 </h4>
<h4>Алексей Япрынцев iOS https://t.me/yapryntsev </h4> 
<h4>Ольга Струзберг Дизайнер https://t.me/olga_struzberg </h4> 


