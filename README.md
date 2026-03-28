# Дипломная работа по профессии «Системный администратор» Студент`Ганопольский Евгений`

### terraform

   В терраформ я полностью создал инфраструктуру, как и было указано в задании. На скриншоте видно, что я разбил на отдельные файлы создание сети, групп безопасности, переменные, виртуальные машины, снепшот и балансировщик нагрузки. 

   ![1](https://github.com/Tolstevich/netology_diplom/blob/master/img/image.png)

   После создания outputs выводит все ip адреса виртуальных машин. В клауд-инит файле у меня прописано создание пользователей, их ключи, а также обновление виртуальных машин. Файл хостс создается заранее собирая информацию для использования в будущем ансибл.

   ![1](https://github.com/Tolstevich/netology_diplom/blob/master/img/output.png)

   В общем-то, это была самая простая часть для меня =))

   Сама работа терраформ в процессе выполнения

   ![1](https://github.com/Tolstevich/netology_diplom/blob/master/img/terraform.png)

   Созданные виртуальные машины, сети, балансировщик, группы безопасности и т.д. в консоле яндекс

   ![1](https://github.com/Tolstevich/netology_diplom/blob/master/img/yandexcloud.png)
   
   Тут видно, что все ВМ работают. Все актуальные IP адреса для сервисов видно на этом скриншоте

   ![1](https://github.com/Tolstevich/netology_diplom/blob/master/img/yandexcloud3.png)


### ansible

   Установку всего необходимого ПО через ансибл я разбил, естетственно, на роли. Заббикс устанавливается с помощью коллекции, которую я нашел в открытом доступе. 

   Запуск и работа ансибл

   ![1](https://github.com/Tolstevich/netology_diplom/blob/master/img/ansiblework.png)

   ![1](https://github.com/Tolstevich/netology_diplom/blob/master/img/ansible.png)

### zabbix

   Тут видно настроенные дашборды для заббикса. ЦПУ, диски, память и т.д.

   ![1](https://github.com/Tolstevich/netology_diplom/blob/master/img/zabbix_dash.png)

   Здесь видно подключенные агенты на всех серверах.
   ![1](https://github.com/Tolstevich/netology_diplom/blob/master/img/vmonzabbix.png)

### logs

   Эластик, файлбит и кибана были настроены, логи с веб-серверов собираются

   ![1](https://github.com/Tolstevich/netology_diplom/blob/master/img/logi.png)
   
### load_balancer

   Балансировщик работает корректно, запросы перебрасывает между двух веб-серверов

   ![1](https://github.com/Tolstevich/netology_diplom/blob/master/img/balancer.png)
   
   ![1](https://github.com/Tolstevich/netology_diplom/blob/master/img/balancer2.png)
   


   






