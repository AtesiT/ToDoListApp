# To Do List
Приложение, отображающее задачи, которое использует Core Data для хранения данных, а также инициализации данных при установке приложения с помощью DummyJSON API .

## 📱 Интерфейс и создание задач
Возможность добавления задач и автоматическое удаление задач (если пользователь закрыл экран, не введя текст).

<div style="display: flex; justify-content: space-between;">
    <img src="Images/Simulator Screenshot - iPhone 17 - 2026-02-11 at 20.53.41.png" alt="Старт" width="32%">
    <img src="Images/Simulator Screenshot - iPhone 17 - 2026-02-11 at 20.54.51.png" alt="Добавление задачи" width="32%">
    <img src="Images/Simulator Screenshot - iPhone 17 - 2026-02-11 at 20.53.25.png" alt="Добавленные задачи" width="32%">
</div>

* Все задачи кэшируются локально и доступны без интернета.
* Счетчик в Toolbar динамически склоняет слово «задача» в зависимости от их количества.

---

## 🛠 Управление и контекстные действия
Удобное взаимодействие с ячейками через контекстное меню.

<div style="display: flex; justify-content: space-between;">
    <img src="Images/Simulator Screenshot - iPhone 17 - 2026-02-11 at 20.53.54.png" alt="Контекстное меню" width="32%">
    <img src="Images/Simulator Screenshot - iPhone 17 - 2026-02-11 at 20.54.16.png" alt="Редактирование задачи" width="32%">
    <img src="Images/Simulator Screenshot - iPhone 17 - 2026-02-11 at 20.54.28.png" alt="Поделиться" width="32%">
</div>

* Быстрый доступ к редактированию, удалению и функции «Поделиться» через `UIActivityViewController`.
* Быстрая отметка о выполнении задачи по нажатию на иконку с эффектом зачеркивания текста.
* Любые правки сохраняются автоматически при закрытии экрана редактирования через `viewWillDisappear`.

---

## 🔍 Поиск и фильтрация
Добавлен `UISearchController` для поиска по названию задачи.

<div style="display: flex; justify-content: space-between;">
    <img src="Images/Simulator Screenshot - iPhone 17 - 2026-02-11 at 20.55.21.png" alt="SearchBar" width="49%">
    <img src="Images/Simulator Screenshot - iPhone 17 - 2026-02-11 at 20.55.13.png" alt="Поиск задачи" width="49%">
</div>

* Чтобы интерфейс не «зависал», фильтрация выполняется в фоновом потоке.
* Поисковая панель интегрирована в `navigationItem` с поддержкой микрофона.
