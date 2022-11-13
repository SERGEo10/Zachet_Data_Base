-- 2.5.2
-- INSERT INTO client(name_client, city_id, email) VALUES ("Попов Илья", 1,"popov@test");
-- select * from client;

-- 2.5.3
-- INSERT INTO  buy(buy_description, client_id)
-- SELECT 'Связаться со мной по вопросу доставки', client_id
-- FROM client WHERE name_client = "Попов Илья";
-- SELECT * FROM buy;
-- 2.5.4
-- INSERT into buy_book(buy_id,book_id,amount) Values
-- (5,8,2), (5,2,1);
-- SELECT* FROM buy_book;
-- 2.5.5
-- UPDATE book inner join buy_book using(book_id)
-- set book.amount = book.amount - buy_book.amount where buy_id = 5;
-- SELECT*FROM book;
-- 2.5.6
-- CREATE TABLE buy_pay AS
-- SELECT title, name_author, price, buy_book.amount, book.price*buy_book.amount AS Стоимость
-- FROM buy_book
-- JOIN book ON book.book_id=buy_book.book_id
-- JOIN author ON author.author_id=book.author_id
-- WHERE buy_book.buy_id=5
-- ORDER BY book.title;
-- SELECT * FROM buy_pay;
-- 2.5.7
-- CREATE TABLE buy_pay AS
-- SELECT buy_id ,SUM( buy_book.amount) as Количество ,SUM( book.price*buy_book.amount )AS Итого
-- FROM buy_book
-- INNER JOIN book using(book_id)
-- WHERE buy_book.buy_id=5
-- ORDER BY book.title;
-- SELECT * FROM buy_pay;
-- 2.5.8
-- INSERT INTO buy_step(buy_id, step_id)
-- SELECT 5, step_id
-- FROM buy INNER JOIN buy_step USING(buy_id)
-- CROSS JOIN step USING(step_id)
-- GROUP BY step_id;
-- select * from buy_step;
-- 2.5.9
-- update buy_step set date_step_beg = '2020.04.12'
-- where buy_id = 5 and step_id = 1;
-- select * from buy_step;
-- 2.5.10
UPDATE 
  buy_step 
SET 
  date_step_end = IF(
    step_id = (
      SELECT 
        step_id 
      FROM 
        step 
      WHERE 
        name_step = "Оплата"
    ), 
    '2020-04-13', 
    date_step_end
  ), 
  date_step_beg = IF(
    step_id = (
      SELECT 
        step_id 
      FROM 
        step 
      WHERE 
        name_step = "Упаковка"
    ), 
    '2020-04-13', 
    date_step_beg
  )
WHERE buy_id = 5;
  
SELECT * FROM buy_step;
