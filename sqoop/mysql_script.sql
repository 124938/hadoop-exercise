/* 
#Login to MySQL using root user
$mysql -u root -p
Enter Password: cloudera
*/

/* Create database */
CREATE DATABASE sqoop_db;
SHOW DATABASES;

/* Create user and provide required grants */
CREATE USER 'sqoop'@'localhost' identified by 'sqoop';
GRANT ALL ON sqoop_db.* to 'sqoop'@'localhost';

/*
#Login to MySQL using schema/user 
$mysql -u sqoop -h localhost sqoop_db -p
*/

/* Create tables and insert data */
USE sqoop_db;

CREATE TABLE `cities` (`id` INTEGER UNSIGNED NOT NULL, `country` VARCHAR(50), `city` VARCHAR(150), PRIMARY KEY (`id`));

INSERT INTO `cities`(`id`, `country`, `city`) VALUES (1, "USA", "Palo Alto");
INSERT INTO `cities`(`id`, `country`, `city`) VALUES (2, "Czech Republic", "Brno");
INSERT INTO `cities`(`id`, `country`, `city`) VALUES (3, "USA", "Sunnyvale");

CREATE TABLE `staging_cities` LIKE `cities`;
CREATE TABLE `export_cities` LIKE `cities`;
CREATE TABLE `export_using_batch_cities` LIKE `cities`;
CREATE TABLE `export_using_multiple_rows_cities` LIKE `cities`;
CREATE TABLE `export_using_transaction_cities` LIKE `cities`;
CREATE TABLE `export_all_nothing_cities` LIKE `cities`;
CREATE TABLE `export_update_cities` LIKE `cities`;


CREATE TABLE `countries` (`country_id` INTEGER UNSIGNED NOT NULL, `country` VARCHAR(50), PRIMARY KEY (`country_id`));

INSERT INTO `countries`(`country_id`, `country`) VALUES (1, "USA");
INSERT INTO `countries`(`country_id`, `country`) VALUES (2, "Czech Republic");

CREATE TABLE `normcities` (`id` INTEGER UNSIGNED NOT NULL, `country_id` INTEGER UNSIGNED NOT NULL, `city` VARCHAR(150), PRIMARY KEY (`id`), FOREIGN KEY (`country_id`) REFERENCES `countries`  (`country_id`);

INSERT INTO `normcities`(`id`, `country_id`, `city`) VALUES (1, 1, "Palo Alto");
INSERT INTO `normcities`(`id`, `country_id`, `city`) VALUES (2, 2, "Brno");
INSERT INTO `normcities`(`id`, `country_id`, `city`) VALUES (3, 1, "Sunnyvale");

CREATE TABLE `visits` (`id` INTEGER UNSIGNED NOT NULL, `city` VARCHAR(50), `last_update_date` DATETIME NOT NULL, PRIMARY KEY (`id`), KEY (`last_update_date`));

INSERT INTO `visits`(`id`, `city`, `last_update_date`) VALUES(1, "Freemont", "1983-05-22 01:01:01");
INSERT INTO `visits`(`id`, `city`, `last_update_date`) VALUES(2, "Jicin", "1987-02-02 02:02:02");

SHOW tables;

