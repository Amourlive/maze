# maze
Суть задачи в написания алгоритма для поиска пути из точки А в тобку B для лабиринта любых рамеров и любой структуры.

Алгоритм решения в maze_path.rb
1. Выбираются будущие ячейки вокруг посещенных ячеек (изначально вокруг точки старта - точки А)
2. Выбранные ячейчки проверяются на наличие стен и цели, в случае их отстутсвия на место ячейки записывается число характеризующее растояние от начала (точки А), при наличии стены адрес ячейки удаляется из "выбраных ячеек"
3. Цикл повторяется пока не найдется цель
4. Строится путь по цепочке чисел от конца к началу
5. Путь переписывается наоборот
![Иллюстрация к проекту](https://github.com/Amourlive/maze/raw/master/path.png)
Архивные версии
vers0.0.2 первая версия решения с обходом вдоль стены, решение незаконченное так как имеет ограничения на структуру лабиринта
vers0.1.0 вторая версия решения - используется что-то вроде обхода в ширину, подходит для любой структуры, находит наикрайчайший путь.
